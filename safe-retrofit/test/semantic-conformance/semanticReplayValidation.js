const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();

    const MultiSend = await ethers.getContractFactory("MultiSend");
    const multiSend = await MultiSend.deploy();
    await multiSend.waitForDeployment();

    const Harness = await ethers.getContractFactory("SemanticMultiSendReplayHarness");
    const harness = await Harness.deploy(await multiSend.getAddress());
    await harness.waitForDeployment();

    const systemId = ethers.keccak256(
        ethers.toUtf8Bytes("SAFE_SYSTEM")
    );

    const safeTxHash = ethers.keccak256(
        ethers.toUtf8Bytes("SAFE_TX")
    );

    const nonce = 1;
    const executionContext = 1;

    const target = deployer.address;
    const value = 0;
    const payload = "0x";

    const packed = ethers.solidityPacked(
        ["uint8", "address", "uint256", "uint256", "bytes"],
        [0, target, value, 0, payload]
    );

    const tx1 = await harness.executeReplayValidation(
        systemId,
        safeTxHash,
        nonce,
        executionContext,
        packed
    );

    const receipt1 = await tx1.wait();

    const tx2 = await harness.executeReplayValidation(
        systemId,
        safeTxHash,
        nonce,
        executionContext,
        packed
    );

    const receipt2 = await tx2.wait();

    const events1 = receipt1.logs;
    const events2 = receipt2.logs;

    console.log("Replay Validation Complete");
    console.log("Run 1 Events:", events1.length);
    console.log("Run 2 Events:", events2.length);
    console.log("Deterministic Replay Executed");
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
