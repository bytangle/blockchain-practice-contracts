// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.0 < 0.9.0;

contract Converter {
    function getStringFromBytes(bytes memory what) public pure returns (string memory) {
        return string(what);
    }

    function getBytesFromString(string memory what) public pure returns (bytes memory) {
        return bytes(what);
    }
}