// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FlipFlop} from "../src/FlipFlop.sol";

contract FlipFlopTest is Test {
    function setUp() public {}

    function test_wins() public {
        FlipFlop f = new FlipFlop(3, 1 ether);
        f.flip{value: 1 ether}(0);
        f.flip{value: 1 ether}(1);
        f.flip{value: 1 ether}(1);
        f.flip{value: 1 ether}(2);
        f.flip{value: 1 ether}(1);
    }

    // Allow the game contract to pay back the test contract
    receive() external payable {}
}
