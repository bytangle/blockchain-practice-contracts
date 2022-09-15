// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.0 < 0.9.0;

contract Converter {
    address immutable _owner;
    uint multiplier;
    uint result;

    constructor(uint _multiplier) {
        _owner = msg.sender;
        multiplier = _multiplier;
    }

    function getStringFromBytes(bytes memory what) public pure returns (string memory) {
        return string(what);
    }

    function getBytesFromString(string memory what) public pure returns (bytes memory) {
        return bytes(what);
    }

    function getOwner() public view returns (address) {
        return _owner;
    }

    function multiply(uint x) public returns (uint) {
        result = x * multiplier;
        return result;
    }
}