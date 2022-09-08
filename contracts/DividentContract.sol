// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.16;

import "node_modules/@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Divident Contract
 * @author Edicha Joshua <mredichaj@gmail.com>
 */
contract DividentContract is Ownable {

    mapping(address => uint256 ) private _balances;

    /// @dev zero address error
    /// @param _msg friendly message :)
    error ZeroAddress(string _msg);

    /// @dev investor registration event
    /// @param _addr address of the investor registered
    event InvestorRegistration(address indexed _addr);
    
    /// @dev divident claim event
    /// @param _addr address of the investor
    event DividentClaimed(address indexed _addr);

    /**
     * @notice add new investor
     * @dev registering zero address reverts the transaction
     * @param _addr address of the investor
     */
    function registerInvestor(address _addr) public payable onlyOwner {
        if(_addr == address(0)) revert ZeroAddress({_msg: "Zero address provided"});

        _balances[_addr] = msg.value; // register investor with initial investment

        emit InvestorRegistration({_addr: _addr}); // emit event
    }

    /// @notice claim divident
    function claimDivident() public {
        require(_balances[msg.sender] > 0, "You dont have any investment");
        
        uint256 amt = _balances[msg.sender];

        delete _balances[msg.sender]; // reset invested amount

        payable(msg.sender).transfer(amt); // pay investor

        emit DividentClaimed(msg.sender); // emit event
    }



}