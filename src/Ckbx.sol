// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "./Console.sol";

contract Ckbx is ERC20 {
    uint256 numCheckboxes;
    uint256 checkboxPrice;

    uint256 totalChecked;
    address winner;
    mapping(uint256 => uint256) counter;

    constructor(uint256 _numCheckboxes, uint256 _checkboxPrice) ERC20("ckbx.io", "CKBX") {
        require(_numCheckboxes > 0, "Invalid number of checkboxes!");
        require(_numCheckboxes % 1024 == 0, "Number of checkboxes must be a multiple of 1024!");
        numCheckboxes = _numCheckboxes;
        checkboxPrice = _checkboxPrice;
    }

    function flip(uint256[] calldata indices) public payable {
        require(msg.value == checkboxPrice * indices.length, "Invalid amount of ETH!");
        require(winner == address(0), "The game has ended!");

        console.log(msg.sender);
        console.log(msg.value);
        console.log(checkboxPrice);

        for (uint256 i = 0; i < indices.length; i++) {
            uint256 ind = indices[i];
            require(ind < numCheckboxes, "Invalid checkbox!");

            _mint(msg.sender, 1 ether >> counter[ind]);
            counter[ind] += 1;

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
    }

    function getState(uint256 since, uint256 count) public view returns (uint256[] memory) {
        require(since + count <= numCheckboxes, "Invalid checkbox indices!");
        uint256[] memory state = new uint256[](count);
        for (uint256 i = since; i < since + count; i++) {
            state[i - since] = counter[i];
        }
        return state;
    }

    function checkOut() public {
        require(winner != address(0), "Game has not ended yet!");

        uint256 bal = balanceOf(msg.sender);
        uint256 eth = address(this).balance * bal / totalSupply();
        _burn(msg.sender, bal);
        payable(msg.sender).transfer(eth);
    }
}
