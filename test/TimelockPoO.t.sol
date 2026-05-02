// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/TimelockControllerPoO.sol";

contract TimelockPoOTest is Test {
    TimelockControllerPoO timelock;

    // replicate event signature EXACTLY (for expectEmit)
    event OperationExecuted(
        bytes32 authorityId,
        bytes32 operationId,
        address target,
        bytes32 dataHash,
        uint256 timestamp
    );

    address proposer = address(1);
    address executor = address(2);

    address target = address(3);
    uint256 value = 0;
    bytes data = abi.encodeWithSignature("noop()");
    bytes32 predecessor = bytes32(0);
    bytes32 salt = keccak256("salt");

    function setUp() public {
        address[] memory proposers = new address[](1);
        proposers[0] = proposer;

        address[] memory executors = new address[](1);
        executors[0] = executor;

        timelock = new TimelockControllerPoO(
            1,
            proposers,
            executors,
            address(this)
        );
    }

    function testScheduleEmitsPoO() public {
        vm.prank(proposer);

        vm.expectEmit(true, true, true, true);
        emit OperationExecuted(
            bytes32(uint256(uint160(proposer))),
            keccak256("SCHEDULE"),
            target,
            keccak256(data),
            block.timestamp
        );

        timelock.schedule(
            target,
            value,
            data,
            predecessor,
            salt,
            1
        );
    }

    function testExecuteEmitsPoO() public {
        vm.prank(proposer);
        timelock.schedule(target, value, data, predecessor, salt, 1);

        vm.warp(block.timestamp + 2);

        vm.prank(executor);

        vm.expectEmit(true, true, true, true);
        emit OperationExecuted(
            bytes32(uint256(uint160(executor))),
            keccak256("EXECUTE"),
            target,
            keccak256(data),
            block.timestamp
        );

        timelock.execute(target, value, data, predecessor, salt);
    }

    function testCancelEmitsPoO() public {
        vm.prank(proposer);
        timelock.schedule(target, value, data, predecessor, salt, 1);

        bytes32 id = timelock.hashOperation(
            target,
            value,
            data,
            predecessor,
            salt
        );

        vm.prank(proposer);

        vm.expectEmit(true, true, true, true);
        emit OperationExecuted(
            bytes32(uint256(uint160(proposer))),
            keccak256("CANCEL"),
            address(0),
            keccak256(abi.encode(id)),
            block.timestamp
        );

        timelock.cancel(id);
    }
}
