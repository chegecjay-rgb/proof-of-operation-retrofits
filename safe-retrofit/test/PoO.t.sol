// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../lib/safe-contracts/contracts/proxies/SafeProxyFactory.sol";
import "../lib/safe-contracts/contracts/proxies/SafeProxy.sol";
import "../lib/safe-contracts/contracts/Safe.sol";
import "../lib/safe-contracts/contracts/libraries/Enum.sol";

contract Target {
    uint256 public value;
    function setNumber(uint256 _v) external {
        value = _v;
    }
}

contract SafePoOTest is Test {
    Safe singleton;
    SafeProxyFactory factory;
    Safe safe;
    Target target;

    address owner;
    uint256 ownerPk = 1;

    bytes32 constant POO_EVENT_SIG =
        keccak256("OperationExecuted(bytes32,bytes32,address,bytes32,uint256)");

    function setUp() public {
        singleton = new Safe();
        factory = new SafeProxyFactory();

        owner = vm.addr(ownerPk);

        address[] memory owners = new address[](1);
        owners[0] = owner;

        bytes memory initializer = abi.encodeWithSelector(
            Safe.setup.selector,
            owners,
            1,
            address(0),
            hex"",
            address(0),
            address(0),
            0,
            payable(address(0))
        );

        SafeProxy proxy = factory.createProxyWithNonce(
            address(singleton),
            initializer,
            0
        );

        safe = Safe(payable(address(proxy)));

        target = new Target();
    }

    function test_exec_emits_poo() public {
        vm.recordLogs();

        bytes memory data = abi.encodeWithSignature("setNumber(uint256)", 42);

        bytes32 txHash = safe.getTransactionHash(
            address(target),
            0,
            data,
            Enum.Operation.Call,
            0,
            0,
            0,
            address(0),
            payable(address(0)),
            safe.nonce()
        );

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPk, txHash);
        bytes memory signatures = abi.encodePacked(r, s, v);

        bool success = safe.execTransaction(
            address(target),
            0,
            data,
            Enum.Operation.Call,
            0,
            0,
            0,
            address(0),
            payable(address(0)),
            signatures
        );

        assertTrue(success);
        assertEq(target.value(), 42);

        Vm.Log[] memory logs = vm.getRecordedLogs();

        bool found = false;

        for (uint256 i = 0; i < logs.length; i++) {
            if (logs[i].topics.length > 0 && logs[i].topics[0] == POO_EVENT_SIG) {
                found = true;

                (
                    bytes32 authorityId,
                    bytes32 operationId,
                    address emittedTarget,
                    bytes32 dataHash,
                    uint256 timestamp
                ) = abi.decode(
                    logs[i].data,
                    (bytes32, bytes32, address, bytes32, uint256)
                );

                assertEq(emittedTarget, address(target));
                assertEq(dataHash, keccak256(data));
                assertGt(timestamp, 0);

                assertEq(
                    operationId,
                    keccak256(
                        abi.encode(
                            keccak256("CALL"),
                            address(target),
                            0,
                            keccak256(data)
                        )
                    )
                );
            }
        }

        assertTrue(found, "PoO event not found");
    }
}
