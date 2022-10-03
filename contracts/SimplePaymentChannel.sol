// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

/// @title Side-Channel Micropayment contract
/// @dev check solidity documentation for deep example and explanation
contract SimplePaymentChannel {
    address payable public sender;
    address payable public recipient;
    uint256 public expiration;

    constructor(address _recipient, uint256 _duration) payable {
        sender = payable(msg.sender);

        require(_recipient != address(0));

        recipient = payable(_recipient);
        expiration = block.timestamp + _duration;
    }

    function close(uint amount, bytes memory sig) public {
        require(msg.sender == recipient);
        require(isValidSignature(amount, sig));

        recipient.transfer(amount);
        selfdestruct(sender);
    }

    function extend(uint256 newExpiration) public {
        require(msg.sender == sender);

        require(newExpiration > expiration);

        expiration = newExpiration;
    }

    function claimTimeout() public {
        require(block.timestamp > expiration);
        selfdestruct(sender);
    }

    function isValidSignature(uint256 amount, bytes memory sig) internal view returns (bool) {
        bytes32 message = prefixed(keccak256(abi.encodePacked(address(this), amount)));

        return recoverSigner(message, sig) == sender;
    }

    function prefixed(bytes32 hash) internal pure returns (bytes32 hashed) {
        hashed = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }

    function recoverSigner(bytes32 message, bytes memory signature) internal pure returns (address) {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(signature);
        return ecrecover(message, v, r, s);
    }

    function splitSignature(bytes memory signature) internal pure returns (uint8 v, bytes32 r, bytes32 s) {
        require(signature.length == 65);

        assembly {
            v := mload(add(signature, 32))
            r := mload(add(signature, 64))
            s := byte(0, mload(add(signature, 96)))
        }
    }
}