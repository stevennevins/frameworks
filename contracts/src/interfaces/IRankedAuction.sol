// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {LinkedListLib, BidInfo, LinkedList} from "../LinkedListLib.sol";

interface IRankedAuction {
    error AlreadyClaimed();
    error InsufficientBalance();
    error InsufficientBid();
    error InvalidFId();
    error SaleInactive();
    error SaleNotOver();

    function bid(uint256 _fId) external payable;

    function settle() external;

    function claim(address _to) external;

    function withdraw(address _to) external;

    function setReserve(uint256 _minReserve) external;

    function setSupply(uint256 _supply) external;

    function setTime(uint256 _startTime, uint256 _endTime) external;

    function setToken(address _token) external;

    function timeRemaining() external view returns (uint256);

    function getBidInfo(
        address _bidder
    ) external view returns (uint96 amount, address nextBidder);

    function getListBids() external view returns (BidInfo[] memory bids);

    function getPreviousBidder(address _bidder) external view returns (address);
}
