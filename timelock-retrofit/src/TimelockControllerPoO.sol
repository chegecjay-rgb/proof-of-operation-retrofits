// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/governance/TimelockController.sol";
import "./poo/PoOEmitter.sol";

contract TimelockControllerPoO is TimelockController, PoOEmitter {
    bytes32 private constant OP_SCHEDULE = keccak256("SCHEDULE");
    bytes32 private constant OP_EXECUTE  = keccak256("EXECUTE");
    bytes32 private constant OP_CANCEL   = keccak256("CANCEL");

    constructor(
        uint256 minDelay,
        address[] memory proposers,
        address[] memory executors,
        address admin
    ) TimelockController(minDelay, proposers, executors, admin) {}

    function schedule(
        address target,
        uint256 value,
        bytes calldata data,
        bytes32 predecessor,
        bytes32 salt,
        uint256 delay
    ) public override {
        super.schedule(target, value, data, predecessor, salt, delay);

        _emitPoO(
            bytes32(uint256(uint160(msg.sender))),
            OP_SCHEDULE,
            target,
            data
        );
    }

    function execute(
        address target,
        uint256 value,
        bytes calldata data,
        bytes32 predecessor,
        bytes32 salt
    ) public payable override {
        super.execute(target, value, data, predecessor, salt);

        _emitPoO(
            bytes32(uint256(uint160(msg.sender))),
            OP_EXECUTE,
            target,
            data
        );
    }

    function cancel(bytes32 id) public override {
        super.cancel(id);

        _emitPoO(
            bytes32(uint256(uint160(msg.sender))),
            OP_CANCEL,
            address(0),
            abi.encode(id)
        );
    }
}
