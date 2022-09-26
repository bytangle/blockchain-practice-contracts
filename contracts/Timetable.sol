// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

/// @title WorkTimeline
/// @author Edicha Joshua <mredichaj@gmail.com>
/// @dev Save work timetable based on periods
contract Timetable {

    address private _dev;
    /// @notice nameOfDay => periodId(e.g break) => period [11, 13] meaning from 11AM - 1PM
    mapping(string => mapping(string => uint8[2])) timetable;

    constructor() {
        _dev = msg.sender;
    }

    function registerPeriod(string memory day, string memory periodName, uint8[2] memory period) public {
        require(period[0] <= 24);
    }
}