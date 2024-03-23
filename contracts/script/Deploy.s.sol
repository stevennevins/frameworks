// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {NFT} from "../src/NFT.sol";
import {RankedAuction} from "../src/RankedAuction.sol";

contract Deploy is Script {

    function run() public {
        vm.startBroadcast();
        NFT nft = new NFT("Nouns Collective", "Nouns");
        RankedAuction auction = new RankedAuction(address(nft), 100, block.timestamp, block.timestamp + 100, 0.001 ether);
        nft.updateMinter(address(auction));
        vm.stopBroadcast();

    }
}
