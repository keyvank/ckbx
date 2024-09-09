// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Ckbx is ERC20 {
    uint256 numCheckboxes;
    uint256 checkboxPrice;

    uint256 totalChecked;
    address winner;
    mapping(uint256 => uint256) counter;

    function decimals() public view virtual override returns (uint8) {
        return 3;
    }

    constructor(uint256 _numCheckboxes, uint256 _checkboxPrice) ERC20("ckbx.io", "CKBX") {
        require(_numCheckboxes > 0, "Invalid number of checkboxes!");
        require(_numCheckboxes % 1024 == 0, "Number of checkboxes must be a multiple of 1024!");
        numCheckboxes = _numCheckboxes;
        checkboxPrice = _checkboxPrice;
    }

    function flip(uint256 ind) public payable {
        require(msg.value == checkboxPrice, "Not enough ETH!");
        require(winner == address(0), "The game has ended!");
        require(ind < numCheckboxes, "Invalid checkbox!");

        _mint(msg.sender, 1000 >> counter[ind]);
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

    function getState(uint256 page) public view returns (uint[] memory) {
        require(page < numCheckboxes / 1024, "Invalid page number!");
        uint256 start = page * 1024;
        uint256 end = start + 1024;
        if (end > numCheckboxes) {
            end = numCheckboxes;
        }

        uint[] memory states = new uint[](end - start);
        for (uint256 i = start; i < end; i++) {
            states[i - start] = counter[i];
        }

        return states;
    }

    function checkOut() public {
        require(winner != address(0), "Game has not ended yet!");

        uint256 bal = balanceOf(msg.sender);
        uint256 eth = address(this).balance * bal / totalSupply();
        _burn(msg.sender, bal);
        payable(msg.sender).transfer(eth);
    }
}
