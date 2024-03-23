// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

struct BidInfo {
    uint96 amount;
    address next;
}

struct LinkedList {
    uint96 size;
    address head;
    uint256 finalPrice;
    mapping(address => BidInfo) bids;
}

library LinkedListLib {
    function insert(
        address _node,
        uint256 _amount,
        LinkedList storage _list
    ) internal {
        address previous;
        address current = _list.head;
        // While current node is not null and new amount is greater than current node amount
        while (current != address(0) && _list.bids[current].amount < _amount) {
            previous = current;
            current = _list.bids[current].next;
        }

        // Sets node values
        _list.bids[_node] = BidInfo(uint96(_amount), current);

        // Checks if node does not have previous node
        if (previous == address(0)) {
            // Sets node to list head
            _list.head = _node;
        } else {
            // Sets node to next of previous node
            _list.bids[previous].next = _node;
        }

        _list.size++;
    }

    function remove(
        address _node,
        LinkedList storage _list,
        mapping(address => uint256) storage _balances
    ) internal {
        address previous = getPrevious(_node, _list);
        if (previous == address(0)) {
            _list.head = _list.bids[_node].next;
        } else {
            _list.bids[previous].next = _list.bids[_node].next;
        }

        _balances[_node] += _list.bids[_node].amount;

        delete _list.bids[_node];
        _list.size--;
    }

    function reduce(
        LinkedList storage _list,
        mapping(address => uint256) storage _balances
    ) internal {
        address current = _list.head;
        address next = _list.bids[_list.head].next;
        _balances[current] += _list.bids[current].amount;

        delete _list.bids[current];
        _list.head = next;
        _list.size--;
    }

    function getList(
        LinkedList storage _list
    ) internal view returns (BidInfo[] memory bids) {
        uint256 index;
        address current = _list.head;
        bids = new BidInfo[](_list.size);
        while (current != address(0)) {
            bids[index] = _list.bids[current];
            current = _list.bids[current].next;
            index++;
        }
    }

    function getPrevious(
        address _node,
        LinkedList storage _list
    ) internal view returns (address previous) {
        address current = _list.head;
        while (current != address(0) && current != _node) {
            previous = current;
            current = _list.bids[current].next;
        }
    }
}
