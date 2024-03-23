// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
contract NFT is ERC721{
    uint256 public nextTokenId;
    mapping(address=>bool) public isMinter;
    constructor(string memory name, string memory symbol) ERC721(name, symbol){}

    modifier onlyMinter() {
        require(isMinter[msg.sender], "Not Minter");
        _;
    }

    function addMinter(address minter) public {
        isMinter[minter] = true;
    }

    function mint(address to, uint256 amount) external {
        for (uint256 i; i < amount; i++){
            _mint(to, nextTokenId++);
        }
    }
}

