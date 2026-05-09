// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.8.20 <0.9.0;

import "../semantic-runtime/SemanticMultiSendShadow.sol";

contract SemanticMultiSendReplayHarness is SemanticMultiSendShadow {
    constructor(address multiSendAddress)
        SemanticMultiSendShadow(multiSendAddress)
    {}

    function executeReplayValidation(
        bytes32 systemId,
        bytes32 safeTxHash,
        uint256 nonce,
        uint8 executionContext,
        bytes memory transactions
    ) external payable {
        semanticMultiSend(
            systemId,
            safeTxHash,
            nonce,
            executionContext,
            transactions
        );
    }
}
