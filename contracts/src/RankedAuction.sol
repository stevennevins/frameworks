// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import {NFT} from "./NFT.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {IRankedAuction, LinkedListLib, BidInfo, LinkedList} from "./interfaces/IRankedAuction.sol";

contract RankedAuction is IRankedAuction, Ownable {
    address public token;
    uint256 public supply;
    uint256 public startTime;
    uint256 public endTime;
    uint256 public minReserve;

    mapping(address => uint256) public balances;
    LinkedList public bidList;

    constructor(
        address _token,
        uint256 _supply,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _minReserve
    ) Ownable(msg.sender) {
        setToken(_token);
        setSupply(_supply);
        setTime(_startTime, _endTime);
        setReserve(_minReserve);
    }

    function bid() external payable {
        if (block.timestamp < startTime || block.timestamp >= endTime) {
            revert SaleInactive();
        }
        uint256 minBid = (bidList.bids[bidList.head].amount * 10_500) / 10_000;
        if (
            msg.value < minReserve ||
            (bidList.size == supply && msg.value < minBid)
        ) {
            revert InsufficientBid();
        }
        uint256 amount = bidList.bids[msg.sender].amount;
        if (amount > 0) {
            if (msg.value <= amount) {
                revert InsufficientBid();
            }
            LinkedListLib.remove(msg.sender, bidList, balances);
        }
        uint64 extendedTime = uint64(block.timestamp + 5 minutes);
        if (endTime < extendedTime) {
            endTime = extendedTime;
        }
        LinkedListLib.insert(msg.sender, msg.value, bidList);
        if (bidList.size > supply) {
            LinkedListLib.reduce(bidList, balances);
        }
    }

    function settle() external {
        if (block.timestamp < endTime) {
            revert SaleNotOver();
        }
        bidList.finalPrice = bidList.bids[bidList.head].amount;
        uint256 saleTotal = bidList.finalPrice * bidList.size;

        Address.sendValue(payable(owner()), saleTotal);
    }

    function claim(address _to) external {
        if (block.timestamp < endTime) {
            revert SaleNotOver();
        }
        uint256 amount = bidList.bids[msg.sender].amount;
        if (amount == 0) {
            revert AlreadyClaimed();
        }
        delete bidList.bids[msg.sender].amount;

        uint256 price = bidList.finalPrice;
        Address.sendValue(payable(msg.sender), amount - price);
        NFT(token).mint(_to);
    }

    function withdraw(address _to) external {
        if (balances[_to] == 0) {
            revert InsufficientBalance();
        }
        uint256 balance = balances[_to];
        delete balances[_to];

        Address.sendValue(payable(_to), balance);
    }

    function setReserve(uint256 _minReserve) public onlyOwner {
        minReserve = _minReserve;
    }

    function setSupply(uint256 _supply) public onlyOwner {
        supply = _supply;
    }

    function setTime(uint256 _startTime, uint256 _endTime) public onlyOwner {
        startTime = _startTime;
        endTime = _endTime;
    }

    function setToken(address _token) public onlyOwner {
        token = _token;
    }

    function timeRemaining() external view returns (uint256) {
        return endTime > block.timestamp ? endTime - block.timestamp : 0;
    }

    function getBidInfo(
        address _bidder
    ) external view returns (uint96 amount, address nextBidder) {
        BidInfo memory bidInfo = bidList.bids[_bidder];
        amount = bidInfo.amount;
        nextBidder = bidInfo.next;
    }

    function getListBids() external view returns (BidInfo[] memory bids) {
        return LinkedListLib.getList(bidList);
    }

    function getPreviousBidder(
        address _bidder
    ) external view returns (address) {
        return LinkedListLib.getPrevious(_bidder, bidList);
    }
}
