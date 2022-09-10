// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.16;

/// @dev subscriber data structure
struct Subscriber {
    address addr; // address of subscriber
    uint256 subscriptionDate; // in millisecond
    uint256 daysSubscribed; // number of days subscribed
}

/**
 * @title Subscription contract - subscribe to a certain service
 */
contract ServiceSubscription {
    address immutable private _owner;

    mapping(address => uint256) private _subscriptions; // address of subscribers => days subscribed
    Subscriber[] private _subscribers; // list of subscribers

    /// @dev subscription fee per day
    uint256 private _subscriptionFee = 1 ether;

    /// @dev used with revert on unauthorized attempts
    error Unauthorized();

    /// @dev used with revert when throwing as a result of expired subscription
    /// @param _expired the time it expired [formular: currentMillisecond - timeOfSubscriptionExpiration]
    error SubscriptionExpired(uint256 _expired);

    /// @dev used with revert when throwing as a result of active subscription
    error SubscriptionActive();

    /// @dev emit when the subscrionFee changes
    /// @param _newAmount new subscription amount
    event SubscriptionFeeUpdate(uint256 _newAmount);

    /// @dev only owner can use any function guarded by this modifier
    modifier onlyOwner {
        if(msg.sender != _owner)
            revert Unauthorized();
        _;
    }

    /// @dev only addresses with active subscription can use any function guarded by this modifier
    modifier subscriptionActive {
        uint256 subscriptionExpiration = _subscriptions[msg.sender];
        if(block.timestamp > subscriptionExpiration)
            revert SubscriptionExpired({
                _expired: subscriptionExpiration != 0 ? block.timestamp - _subscriptions[msg.sender] : 0
            });
        _;
    }

    /// @dev only addreses with expired subscription can use any function guarded by this modifier
    modifier subscriptionExpired {
        if(block.timestamp < _subscriptions[msg.sender])
            revert SubscriptionActive();
        _;
    }

    constructor(uint256 subscriptionFee_) {
        _owner = msg.sender;
        _subscriptionFee = subscriptionFee_;
    }

    /// @notice change the subscription fee
    /// @param _newAmount new value
    function updateSubscriptionFee(uint256 _newAmount) public onlyOwner {
        _subscriptionFee = 0;
        _subscriptionFee = _newAmount;

        emit SubscriptionFeeUpdate(_newAmount);
    }

    /// @notice subscribe for a given number of days
    /// Note: you can only subscribe when not subscribed
    /// @param _days the number of days to subscribe for
    function subscribe(uint256 _days) public payable subscriptionExpired {
        require(_days > 0 && _days < type(uint256).max); // validate days provided

        require(_subscriptionFee * _days <= msg.value, "Not enough fund to subscribe"); // ensure msg.value equals

        uint256 currentTime =  block.timestamp;

        uint256 daysInMilliseconds = (_days * 24 * 60 * 60 * 1000); // convert to millisecond;
        _subscriptions[msg.sender] = currentTime + daysInMilliseconds;

        _subscribers.push(Subscriber({
            addr: msg.sender,
            subscriptionDate: currentTime, // in milliseconds,
            daysSubscribed: _days
        })); // save subscriber

        // refund excess fund
        if(_subscriptionFee * _days < msg.value)
            payable(msg.sender).transfer(msg.value - (_subscriptionFee * _days));
    }

    /// @notice get the list of subscribers
    /// @return list of {Subscriber} struct
    function getSubscribers() public view returns (Subscriber[] memory) {
        return _subscribers;
    }

    /// @notice call this function to utilize the service
    function useService() public subscriptionActive {
        // implement service
    }

    /// @notice withdraw subscription funds from this contract
    function withdraw() public onlyOwner {
        payable(_owner).transfer(address(this).balance);
    }

    
}