// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "./Event.sol";

contract Marketplace {
    address[] public events;

    event NewEvent(address creator, address eventAddress);

    function createEvent(
        uint _saleStart,
        uint _saleEnd,
        uint _ticketsPrice,
        uint _maxTickets,
        string memory _metadata
    ) external {
        address newEvent = address(
            new Event(
                _saleStart,
                _saleEnd,
                _ticketsPrice,
                _maxTickets,
                _metadata,
                msg.sender
            )
        );

        events.push(newEvent);
        emit NewEvent(msg.sender, newEvent);
    }
}
