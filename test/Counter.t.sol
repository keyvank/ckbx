// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FlipFlop} from "../src/FlipFlop.sol";

contract FlipFlopTest is Test {
    function setUp() public {
    }

    function test_Increment() public {
        FlipFlop f = new FlipFlop(3);
        f.flip(0);
        f.flip(1);
        f.flip(1);
        f.flip(2);
        f.flip(1);
    }
}
