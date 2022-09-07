// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.16;

/**
 * @title Divident Contract
 * @author Edicha Joshua <mredichaj@gmail.com>
 */
contract DividentContract {

    address[] private _investors;

    error ZeroAddress(string _msg);

    event InvestorRegistration(address indexed _addr);

    /**
     * @notice add new investor
     * @dev registering zero address reverts the transaction
     * @param _addr address of the investor
     */
    function registerInvestor(address _addr) public {
        if(_addr == address(0)) revert ZeroAddress({_msg: "Zero address provided"});

        _investors.push(_addr); // register investor

        emit InvestorRegistration({_addr: _addr}); // emit event
    }

}