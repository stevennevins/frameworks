// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

interface INFT {
    function mint(address _to) external payable;

    function tokenURI(uint256 _tokenId) external view returns (string memory);

    function updateMinter(address _minter) external;
}
