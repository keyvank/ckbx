// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Ckbx is ERC20 {
    event Toggled(uint256 index);

    uint256 public numCheckboxes;
    uint256 public checkboxPrice;
    uint256 public totalChecked;
    uint256 public numFreeFlips;
    address public winner;
    mapping(uint256 => uint256) public counter;

    constructor(uint256 _numCheckboxes, uint256 _checkboxPrice, uint256 _numFreeFlips) ERC20("ckbx.xyz", "CKBX") {
        require(_numCheckboxes > 0, "Invalid number of checkboxes!");
        numCheckboxes = _numCheckboxes;
        checkboxPrice = _checkboxPrice;
        numFreeFlips = _numFreeFlips;

        _mint(msg.sender, 1 ether * (_numCheckboxes / 10));
    }

    function flip(uint256[] memory indices) public payable {
        if (numFreeFlips == 0) {
            require(msg.value == checkboxPrice * indices.length, "Invalid amount of ETH!");
        } else {
            if (numFreeFlips >= indices.length) {
                require(msg.value == 0, "Invalid amount of ETH!");
            } else {
                uint256 remainder = indices.length - numFreeFlips;
                require(msg.value == checkboxPrice * remainder, "Invalid amount of ETH!");
            }
        }
        require(winner == address(0), "The game has ended!");

        for (uint256 i = 0; i < indices.length; i++) {
            uint256 ind = indices[i];
            require(ind < numCheckboxes, "Invalid checkbox!");

            _mint(msg.sender, 1 ether >> counter[ind]);
            counter[ind] += 1;

            emit Toggled(ind);

            if (counter[ind] % 2 == 1) {
                totalChecked += 1;
                if (totalChecked == numCheckboxes) {
                    winner = msg.sender;
                    payable(winner).transfer(address(this).balance / 2);
                }
            } else {
                totalChecked -= 1;
            }
        }

        if (numFreeFlips > indices.length) {
            numFreeFlips -= indices.length;
        } else {
            numFreeFlips = 0;
        }
    }

    function getState(uint256 since, uint256 count) public view returns (uint256[] memory, uint256) {
        require(since + count <= numCheckboxes, "Invalid checkbox indices!");
        uint256[] memory state = new uint256[](count);
        for (uint256 i = since; i < since + count; i++) {
            state[i - since] = counter[i];
        }

        return (state, numFreeFlips);
    }

    function checkOut() public returns (uint256) {
        require(winner != address(0), "Game has not ended yet!");

        uint256 bal = balanceOf(msg.sender);
        uint256 eth = (address(this).balance * bal) / totalSupply();
        _burn(msg.sender, bal);
        payable(msg.sender).transfer(eth);

        return eth;
    }
}
