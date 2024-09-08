// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract FlipFlop {
    uint256 numCheckboxes;
    uint256 totalChecked;
    address winner;
    mapping(uint256 => bool) checkboxes;
    mapping(uint256 => address) owners;

    constructor(uint256 _numCheckboxes) {
        numCheckboxes = _numCheckboxes;
    }

    function flip(uint256 ind) public payable {
        require(winner == address(0), "The game has ended!");
        require(ind < numCheckboxes, "Invalid checkbox!");

        checkboxes[ind] = !checkboxes[ind];
        if(owners[ind] == address(0)) {
            owners[ind] = msg.sender;
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
        
    }
}
