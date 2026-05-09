const hre = require("hardhat");
const { ethers } = hre;

function encodeTransaction(operation, to, value, data) {
  const operationHex = ethers.zeroPadValue(
    ethers.toBeHex(operation),
    1
  ).slice(2);

  const toHex = ethers.zeroPadValue(
    to,
    20
  ).slice(2);

  const valueHex = ethers.zeroPadValue(
    ethers.toBeHex(value),
    32
  ).slice(2);

  const dataBytes = ethers.getBytes(data);

  const dataLengthHex = ethers.zeroPadValue(
    ethers.toBeHex(dataBytes.length),
    32
  ).slice(2);

  const dataHex = data.slice(2);

  return "0x" +
    operationHex +
    toHex +
    valueHex +
    dataLengthHex +
    dataHex;
}

async function main() {
  const [deployer] = await ethers.getSigners();

  const MultiSend = await ethers.getContractFactory("MultiSend");
  const multiSend = await MultiSend.deploy();
  await multiSend.waitForDeployment();

  const Harness = await ethers.getContractFactory(
    "DelegatecallMultiSendHarness"
  );

  const harness = await Harness.deploy(
    await multiSend.getAddress()
  );

  await harness.waitForDeployment();

  const tx1 = encodeTransaction(
    0,
    deployer.address,
    0,
    "0x1234"
  );

  const tx2 = encodeTransaction(
    0,
    deployer.address,
    0,
    "0xabcd"
  );

  const packedTransactions = ethers.concat([
    tx1,
    tx2
  ]);

  const systemId = ethers.keccak256(
    ethers.toUtf8Bytes("SAFE_SYSTEM")
  );

  const safeTxHash = ethers.keccak256(
    ethers.toUtf8Bytes("SAFE_TX")
  );

  const tx = await harness.executeDelegatecallReplay(
    systemId,
    safeTxHash,
    1,
    1,
    packedTransactions
  );

  const receipt = await tx.wait();

  const semanticEvents = receipt.logs.filter(
    (log) => {
      try {
        return (
          harness.interface.parseLog(log).name ===
          "ProofOfOperation"
        );
      } catch {
        return false;
      }
    }
  );

  console.log("ProofOfOperation events:", semanticEvents.length);

  for (let i = 0; i < semanticEvents.length; i++) {
    const parsed = harness.interface.parseLog(
      semanticEvents[i]
    );

    console.log("Operation", i);
    console.log("operationId:", parsed.args.operationId);
    console.log("parentOperationId:", parsed.args.parentOperationId);
    console.log("operationIndex:", parsed.args.operationIndex.toString());
    console.log("operationCount:", parsed.args.operationCount.toString());
    console.log("target:", parsed.args.target);
    console.log("payloadHash:", parsed.args.payloadHash);
  }

  console.log("Deterministic delegatecall replay validation complete");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
