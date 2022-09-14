// SPDX-License-Identifer: GPL-3.0

pragma solidity >= 0.8.0 < 0.9.0; 

contract Emma {
    string myName;
    string age;
    string address_;

    function saveName(string memory name) public returns (bool) {
        myName = name;

        return true;
    }

    function sayMyName() public view returns (string memory) {
        return myName;
    }
}