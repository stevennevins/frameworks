// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {NFT} from "../src/NFT.sol";

contract Deploy is Script {

    function run() public {
        vm.broadcast();
        new NFT();

    }
}
