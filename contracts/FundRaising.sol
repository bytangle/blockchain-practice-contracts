// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/// @dev illustration of state machine and access restriction design patterns
contract FundRaising {
    address private _admin; // admin

    /// @notice total amount raised
    uint256 private _amount;
    uint256 private _targetAmount; // target amount

    /// @dev donations => address and the amount donated
    DonationInfo[] private _donations;

    /// @dev donation details struct
    struct DonationInfo {
        address donator;
        uint256 amount;
    }

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

    /// @dev emit when a donator donates
    /// @param _donator address of the person who donated
    /// @param _amount amount donated
    event Donation(address _donator, uint256 _amount);

    /// @dev used with revert when throwing as a result of unauthorized attempt to call a function
    error Unauthorized();

    /// @dev fund raising hasn't started
    error FundRaisingHasNotStarted();

    /// @dev used with revert when fund raising is running
    error FundRaisingIsRunning();

    /// @dev guard against unathorized access [only admin can call functions with this modifier]
    modifier onlyAdmin {
        if(_admin != msg.sender) revert Unauthorized();
        _;
    }

    /// @dev ensure fund raising has started
    modifier ensureFundRaisingStarted {
        if(status == Phase.ENDED) revert FundRaisingHasNotStarted(); // ensure fund raising has started
        _;
    }

    /// @dev ensure fund raising hasn't started
    modifier ensureFundRaisingEnded {
        if(status == Phase.STARTED) revert FundRaisingIsRunning(); // ensure fund raising has not started
        _;    
    }

    constructor() {
        _admin = msg.sender;
    }

    /**
     * @notice start fund raising
     * @param _target amount to achieve
     */
    function beginFundRaising(uint256 _target) public onlyAdmin ensureFundRaisingEnded {
        require(_targetAmount == 0); // target amount must be zero

        _targetAmount = _target; // set target

        status = Phase.STARTED; // update status

        emit FundRaisingStarted(block.timestamp); // emit event
    }

    /**
     * @notice end fund raising
     */
    function endFundRaising() public onlyAdmin ensureFundRaisingStarted {

        uint256 amt = _amount;

        delete _targetAmount; // reset target amount to zero
        delete _amount; // reset amount

        status = Phase.ENDED; // update status

        payable(_admin).transfer(amt); // transfer funds to the admin

        emit FundRaisingEnded(block.timestamp, amt); // emit event
    }

    /// fallback function that'll be called when ether is sent directly to this contract
    receive() external payable {
        donate();
    }

    /// @notice donate to this contract
    function donate() public payable ensureFundRaisingStarted {
        require(msg.value > 0); // cannot donate 0 amount

        _amount += msg.value; // update amount

        _donations.push(DonationInfo(msg.sender, msg.value)); // save donation detail

        emit Donation(msg.sender, msg.value); // emit event
    }

    /// @dev retrieve donations info
    /// @return array of donation details {address, amount}
    function getDonationDetails() public view returns (DonationInfo[] memory) {
        return _donations;
    }
}