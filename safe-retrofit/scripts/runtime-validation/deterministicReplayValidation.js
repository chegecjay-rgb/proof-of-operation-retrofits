const hre = require("hardhat");
const { ethers } = hre;

function encodeTransaction(operation, to, value, data) {
  const operationHex = ethers.zeroPadValue(ethers.toBeHex(operation), 1).slice(2);
  const toHex = ethers.zeroPadValue(to, 20).slice(2);
  const valueHex = ethers.zeroPadValue(ethers.toBeHex(value), 32).slice(2);
  const dataLengthHex = ethers.zeroPadValue(ethers.toBeHex(data.length / 2 - 1), 32).slice(2);
  const dataHex = data.slice(2);

  return "0x" + operationHex + toHex + valueHex + dataLengthHex + dataHex;
}

async function main() {
  const [deployer] = await ethers.getSigners();

  const MultiSend = await ethers.getContractFactory("MultiSend");
  const multiSend = await MultiSend.deploy();
  await multiSend.waitForDeployment();

  const SemanticMultiSendShadow = await ethers.getContractFactory("SemanticMultiSendShadow");
  const semanticShadow = await SemanticMultiSendShadow.deploy(
    await multiSend.getAddress()
  );
  await semanticShadow.waitForDeployment();

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

  const transactions = ethers.concat([
    tx1,
    tx2
  ]);

  const systemId = ethers.keccak256(
    ethers.toUtf8Bytes("SAFE_SYSTEM")
  );

  const safeTxHash = ethers.keccak256(
    ethers.toUtf8Bytes("SAFE_TX")
  );

  const nonce = 1;
  const executionContext = 1;

  const tx = await semanticShadow.semanticMultiSend(
    systemId,
    safeTxHash,
    nonce,
    executionContext,
    transactions
  );

  const receipt = await tx.wait();

  const semanticEvents = receipt.logs
    .map((log) => {
      try {
        return semanticShadow.interface.parseLog(log);
      } catch {
        return null;
      }
    })
    .filter(Boolean)
    .filter((parsed) => parsed.name === "ProofOfOperation");

  console.log("ProofOfOperation events:", semanticEvents.length);

  if (semanticEvents.length !== 2) {
    throw new Error("Deterministic semantic emission count mismatch");
  }

  const first = semanticEvents[0].args;
  const second = semanticEvents[1].args;

  console.log("Operation 1 Index:", first.operationIndex.toString());
  console.log("Operation 2 Index:", second.operationIndex.toString());

  console.log("Operation Count:", first.operationCount.toString());

  console.log(
    "Shared ParentOperationId:",
    first.parentOperationId === second.parentOperationId
  );

  console.log(
    "Distinct OperationIds:",
    first.operationId !== second.operationId
  );

  const replayTx = await semanticShadow.semanticMultiSend(
    systemId,
    safeTxHash,
    nonce,
    executionContext,
    transactions
  );

  const replayReceipt = await replayTx.wait();

  const replayEvents = replayReceipt.logs
    .map((log) => {
      try {
        return semanticShadow.interface.parseLog(log);
      } catch {
        return null;
      }
    })
    .filter(Boolean)
    .filter((parsed) => parsed.name === "ProofOfOperation");

  const deterministicReplay =
    semanticEvents[0].args.operationId === replayEvents[0].args.operationId &&
    semanticEvents[1].args.operationId === replayEvents[1].args.operationId;

  console.log("Deterministic Replay:", deterministicReplay);

  if (!deterministicReplay) {
    throw new Error("Replay-stable equivalence validation failed");
  }

  console.log("Deterministic semantic replay validation PASSED");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
