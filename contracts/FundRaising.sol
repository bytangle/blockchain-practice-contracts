// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.16;

/// @dev illustration of state machine and access restriction design patterns
contract FundRaising {
    address private _admin; // admin

    /// @notice total amount raised
    uint256 private _amount;
    uint256 private _targetAmount; // target amount

    /// @dev donations => address and the amount donated
    mapping(address => uint256) private _donations;

    /// @notice state definition
    enum Phase {
        STARTED, ENDED
    }

    // if Phase.ENDED no one can send funds to this contract.
    Phase private status = Phase.ENDED;

    /// @dev emit when fund raising has started
    event FundRaisingStarted(uint256 _time);

    /// @dev emit when fund raising ends
    event FundRaisingEnded(uint256 _time, uint256 _totalAmountRaised);

    /// @dev used with revert when throwing as a result of unauthorized attempt to call a function
    error Unauthorized();

    /// @dev guard against unathorized access [only admin can call functions with this modifier]
    modifier onlyAdmin {
        if(_admin != msg.sender) revert Unauthorized();
        _;
    }

    /**
     * @notice start fund raising
     * @param _target amount to achieve
     */
    function beginFundRaising(uint256 _target) public onlyAdmin {
        
    }
}