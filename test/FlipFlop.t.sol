// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FlipFlop} from "../src/FlipFlop.sol";

contract FlipFlopTest is Test {
    function setUp() public {
    }

    function test_Increment() public {
        FlipFlop f = new FlipFlop(3, 1);
        f.flip{value: 1}(0);
        f.flip{value: 1}(1);
        f.flip{value: 1}(1);
        f.flip{value: 1}(2);
        f.flip{value: 1}(1);
    }
}
