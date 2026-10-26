// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableBank {
    mapping(address => uint256) public balances;

    // Users deposit ETH ( money ) into the bank
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    // VULNERABILITY: External call happens BEFORE state update
    function withdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // 1. INTERACTIONS: External call sends ETH first
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");

        // 2. EFFECTS: State update happens AFTER the external call (Too late!)
        balances[msg.sender] -= _amount;
    }

    // Helper to check contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
