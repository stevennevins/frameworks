// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {LibString} from "solady/utils/LibString.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {INFT} from "./interfaces/INFT.sol";

contract NFT is INFT, ERC721, Ownable {
    using LibString for uint256;

    uint256 counter;
    address minter;

    constructor() ERC721("Cryptoadz", "TOADZ") Ownable(msg.sender) {}

    function mint(address _to) external payable {
        if (msg.sender != minter) revert();
        _mint(_to, ++counter);
    }

    function updateMinter(address _minter) external onlyOwner {
        minter = _minter;
    }

    function tokenURI(
        uint256 _tokenId
    ) public pure override(ERC721, INFT) returns (string memory) {
        return
            string.concat(
                "https://arweave.net/OVAmf1xgB6atP0uZg1U0fMd0Lw6DlsVqdvab-WTXZ1Q/",
                _tokenId.toString()
            );
    }
}
