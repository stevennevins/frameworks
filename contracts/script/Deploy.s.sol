// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from "forge-std/Script.sol";

import {NFT} from "../src/NFT.sol";
import {RankedAuction} from "../src/RankedAuction.sol";

contract Deploy is Script {
    address registry;
    address token;
    uint256 supply;
    uint256 startTime;
    uint256 endTime;
    uint256 price;

    function setUp() public {
        registry = 0x00000000Fc6c5F01Fc30151999387Bb99A9f489b;
        token = 0xcb2e1d15c237C0A356dA9C31fd149170190526C5;
        supply = 20;
        startTime = block.timestamp;
        endTime = block.timestamp + 86400;
        price = 0.0001 ether;
    }

    function run() public {
        vm.startBroadcast();
        RankedAuction auction = new RankedAuction(
            registry,
            token,
            supply,
            startTime,
            endTime,
            price
        );
        NFT(token).updateMinter(address(auction));
        vm.stopBroadcast();
    }
}
