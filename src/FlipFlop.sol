// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract FlipFlop is ERC20 {
    uint256 numCheckboxes;
    uint256 checkboxPrice;

    uint256 totalChecked;
    address winner;
    mapping(uint256 => bool) checkboxes;
    mapping(uint256 => address) owners;

    function decimals() public view virtual override returns (uint8) {
        return 0;
    }

    constructor(uint256 _numCheckboxes, uint256 _checkboxPrice) ERC20("Checkbox!", "CKBX") {
        numCheckboxes = _numCheckboxes;
        checkboxPrice = _checkboxPrice;
    }

    function flip(uint256 ind) public payable {
        require(msg.value == checkboxPrice, "Not enough ETH!");
        require(winner == address(0), "The game has ended!");
        require(ind < numCheckboxes, "Invalid checkbox!");

        checkboxes[ind] = !checkboxes[ind];
        if(owners[ind] == address(0)) {
            owners[ind] = msg.sender;
            _mint(msg.sender, 1);
        }

        if(checkboxes[ind]) {
            totalChecked += 1;
            if(totalChecked == numCheckboxes) {
                winner = msg.sender;
            }
        } else {
            totalChecked -= 1;
        }
    }

    function checkOut() public {
        require(winner != address(0), "Game has not ended yet!");
        
        uint256 bal = balanceOf(msg.sender);
        _burn(msg.sender, bal);
        uint256 eth = address(this).balance * bal / numCheckboxes;
        payable(msg.sender).transfer(eth);
    }
}
