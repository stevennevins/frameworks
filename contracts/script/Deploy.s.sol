// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from "forge-std/Script.sol";

import {NFT} from "../src/NFT.sol";
import {RankedAuction} from "../src/RankedAuction.sol";

contract Deploy is Script {
    uint256 supply;
    uint256 startTime;
    uint256 endTime;
    uint256 price;

    function setUp() public {
        supply = 20;
        startTime = block.timestamp;
        endTime = block.timestamp + 86400;
        price = 0.0001 ether;
    }

    function run() public {
        vm.startBroadcast();
        NFT nft = new NFT();
        RankedAuction auction = new RankedAuction(
            address(nft),
            supply,
            startTime,
            endTime,
            price
        );
        nft.updateMinter(address(auction));
        vm.stopBroadcast();
    }
}
