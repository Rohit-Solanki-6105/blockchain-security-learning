// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableAuction {
    address public highestBidder;
    uint256 public highestBid;

    function bid() external payable {
        require(msg.value > highestBid, "Bid too low");

        // VULNERABILITY (Push Payment):
        // Directly sending ETH to the previous highest bidder.
        // If highestBidder rejects the transfer, this call reverts!
        if (highestBidder != address(0)) {
            (bool success, ) = payable(highestBidder).call{value: highestBid}("");
            require(success, "Refund failed");
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
    }
}