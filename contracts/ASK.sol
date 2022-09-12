// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.0 < 0.9.0;

/// @title Arlines Consortium
contract ASK {
    address private _chairperson; // current chairperson address

    /// @notice information about each individual airlines
    struct Details {
        uint escrow; // amount committed by each airline
        bool status; // membership status
        bytes32 detailsHash; // details hash
    }

    /// @notice balance details
    mapping(address => Details) private _balanceDetails;

    /// @notice membership status
    mapping(address => bool) private _membership;

    /// @notice describes unauthorized function calls
    error Unauthorized();

    /// @dev emit on members registration
    /// @param _addr address of the airline
    event MembershipRegistration(address _addr);

    /// @dev emit on membership rescind
    /// @param _addr address of the airline
    event MembershipCancellation(address _addr);

    /// @dev emit when a member airline logs a request
    /// @param _addr address of the airline that logged the request
    event RequestLogged(address _addr);

    /// @dev emit when a member arline logs a response to a request
    /// @param _logger address of the airline that logged the response
    /// @param _to address of the airline `_logger` is responding to
    event ResponseLogged(address _logger, address _to);

    /// @dev emit when payment is settled
    /// @param _from the address of airline settling the payment
    /// @param _to the address of the airline receiving the payment
    event PaymentSettlement(address _from, address _to);

    /// @dev only chairperson can call functions guarded by this modifier
    modifier onlyChairperson {
        if(msg.sender != _chairperson) revert Unauthorized();
        _;
    }

    /// @dev only registered members can call functions guarded by this modifier
    modifier onlyMember {
        if(!_membership[msg.sender]) revert Unauthorized();
        _;
    }

    constructor() payable {
        // authomatically register the deployer as the chairperson
        _chairperson = msg.sender;

        // create balance details for chairperson
        Details memory chairpersonDetails;
        chairpersonDetails.escrow = msg.value;
        _balanceDetails[msg.sender] = chairpersonDetails;

        // register chairperson
        _membership[_chairperson] = true;

    }

    /// @notice airlines registration
    function register() public payable {
        // setup airline details
        Details memory airline;
        airline.escrow = msg.value;
        _balanceDetails[msg.sender] = airline;

        _membership[msg.sender] = true; // register membership

        emit MembershipRegistration(msg.sender); // emit event
    }

    /// @notice cancel airliine membership
    /// @param _airline address of the airline to rescind membership
    /// Note: only chairperson can use this function and airline must be a member
    function unregister(address payable _airline) public onlyChairperson {
        require(_airline != address(0)); // ensure given address isn't a zero address
        require(_membership[_airline], "airline not a member"); // ensure given address is a member

        _membership[_airline] = false; // rescind membership
        uint escrow = _balanceDetails[_airline].escrow;

        delete _balanceDetails[_airline]; // clear details

        _airline.transfer(escrow); // refund remaining escrow

        emit MembershipCancellation(_airline);
    }

    /**
     * @notice log a request
     * @param _to address of airline sending request to
     * @param _detailsHash hashed information about the request
     */
    function request(address _to, bytes32 _detailsHash) public onlyMember {

        require(_membership[_to], "airline not a member"); /// ensure `_to` is a member

        _balanceDetails[msg.sender].status = false;
        _balanceDetails[msg.sender].detailsHash = _detailsHash;

        emit RequestLogged(msg.sender); // emit event
    }

    /**
     * @notice log response for a request
     * @param _from address of airline that actually logged a request
     * @param _detailsHash hashed information about the response
     * @param _done response status, `true` if attended to `false` otherwise
     */
    function response(address _from, bytes32 _detailsHash, bool _done) public onlyMember {

        require(_membership[_from], "airline not a member"); /// ensure `_from` is a member

        _balanceDetails[msg.sender].status = _done;
        _balanceDetails[_from].detailsHash = _detailsHash;

        emit ResponseLogged(msg.sender, _from); // emit event
    }

    function settlePayment(address payable _to) public payable onlyMember {
        require(_to != address(0)); /// ensure `_to` isn't 0x0

        address from = msg.sender;
        uint amount = msg.value;

        require(amount > 0, "zero amount cannot be sent for payment settlement"); // ensure msg.value > 0

        // check for underflow and overflow conditions
        require(type(uint).min < _balanceDetails[from].escrow - amount);
        require(type(uint).max > _balanceDetails[_to].escrow + amount);

        // update airlines escrow amounts
        _balanceDetails[from].escrow -= amount;
        _balanceDetails[_to].escrow += amount;

        _to.transfer(amount); /// transfer amount from contract to `_to` account

        emit PaymentSettlement(from, _to); // emit event
    }
}