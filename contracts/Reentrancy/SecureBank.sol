// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecureBank {
    mapping(address => uint256) public balances;
    bool private locked;

    // Reentrancy Guard Modifier (Mutex Lock)
    modifier noReentrant() {
        require(!locked, "Reentrant call detected!");
        locked = true;
        _;
        locked = false;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    // SECURE: Uses Checks-Effects-Interactions pattern AND a Mutex Lock
    function withdraw(uint256 _amount) external noReentrant {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // 1. EFFECTS: Update state BEFORE making any external calls
        balances[msg.sender] -= _amount;

        // 2. INTERACTIONS: External call happens last
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
