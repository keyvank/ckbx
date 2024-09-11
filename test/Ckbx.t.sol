// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Ckbx} from "../src/Ckbx.sol";
import {Vm} from "forge-std/Vm.sol";

contract FlipFlopTest is Test {
    function setUp() public {}

    function test_no_flip_after_game_ends() public {
        Ckbx f = new Ckbx(3, 0.001 ether);
        uint256[] memory params = new uint256[](1);

        params[0] = 0;
        f.flip{value: 0.001 ether}(params);
        vm.assertEq(f.totalChecked(), 1);
        vm.assertEq(f.winner(), address(0));
        vm.assertEq(address(f).balance, 0.001 ether);

        params[0] = 1;
        f.flip{value: 0.001 ether}(params);
        vm.assertEq(f.totalChecked(), 2);
        vm.assertEq(f.winner(), address(0));
        vm.assertEq(address(f).balance, 0.002 ether);

        params[0] = 1;
        f.flip{value: 0.001 ether}(params);
        vm.assertEq(f.totalChecked(), 1);
        vm.assertEq(f.winner(), address(0));
        vm.assertEq(address(f).balance, 0.003 ether);

        params[0] = 2;
        f.flip{value: 0.001 ether}(params);
        vm.assertEq(f.totalChecked(), 2);
        vm.assertEq(f.winner(), address(0));
        vm.assertEq(address(f).balance, 0.004 ether);

        params[0] = 1;
        f.flip{value: 0.001 ether}(params);
        vm.assertEq(f.totalChecked(), 3);
        vm.assertEq(f.winner(), address(this));
        vm.assertEq(address(f).balance, 0.0025 ether);

        vm.expectRevert();

        params[0] = 2;
        f.flip{value: 0.001 ether}(params);
    }

    function test_cant_checkout_before_end() public {
        Ckbx f = new Ckbx(3, 0.001 ether);
        uint256[] memory params = new uint256[](1);

        vm.assertEq(address(f).balance, 0 ether);

        params[0] = 0;
        f.flip{value: 0.001 ether}(params);
        vm.assertEq(f.totalChecked(), 1);
        vm.assertEq(f.winner(), address(0));
        vm.assertEq(address(f).balance, 0.001 ether);

        params[0] = 1;
        f.flip{value: 0.001 ether}(params);
        vm.assertEq(f.totalChecked(), 2);
        vm.assertEq(f.winner(), address(0));
        vm.assertEq(address(f).balance, 0.002 ether);

        vm.expectRevert();

        f.checkOut();
    }

    function test_complete() public {
        Ckbx f = new Ckbx(3, 0.001 ether);
        uint256[] memory params = new uint256[](1);

        vm.assertEq(address(f).balance, 0 ether);

        params[0] = 0;
        f.flip{value: 0.001 ether}(params);
        vm.assertEq(f.totalChecked(), 1);
        vm.assertEq(f.winner(), address(0));
        vm.assertEq(address(f).balance, 0.001 ether);

        params[0] = 1;
        f.flip{value: 0.001 ether}(params);
        vm.assertEq(f.totalChecked(), 2);
        vm.assertEq(f.winner(), address(0));
        vm.assertEq(address(f).balance, 0.002 ether);

        params[0] = 2;
        f.flip{value: 0.001 ether}(params);
        vm.assertEq(f.totalChecked(), 3);
        vm.assertEq(f.winner(), address(this));
        vm.assertEq(address(f).balance, 0.0015 ether);

        vm.assertEq(f.checkOut(), 0.0015 ether);
    }

    function test_multi_not_enough() public {
        Ckbx f = new Ckbx(3, 0.001 ether);
        uint256[] memory params = new uint256[](2);

        params[0] = 0;
        params[0] = 1;

        vm.expectRevert();
        f.flip{value: 0.001 ether}(params);
    }

    function test_multi_enough() public {
        Ckbx f = new Ckbx(3, 0.001 ether);
        uint256[] memory params = new uint256[](2);

        params[0] = 0;
        params[0] = 1;

        f.flip{value: 0.002 ether}(params);
    }

    function test_multi_flow() public {
        Ckbx f = new Ckbx(3, 0.001 ether);
        uint256[] memory params = new uint256[](2);

        params[0] = 0;
        params[1] = 1;
        f.flip{value: 0.002 ether}(params);
        vm.assertEq(f.totalChecked(), 2);
        vm.assertEq(address(f).balance, 0.002 ether);

        params[0] = 1;
        params[1] = 2;
        f.flip{value: 0.002 ether}(params);
        vm.assertEq(f.totalChecked(), 2);
        vm.assertEq(address(f).balance, 0.004 ether);

        params[0] = 0;
        params[1] = 2;
        f.flip{value: 0.002 ether}(params);
        vm.assertEq(f.totalChecked(), 0);
        vm.assertEq(address(f).balance, 0.006 ether);

        params[0] = 0;
        params[1] = 1;
        f.flip{value: 0.002 ether}(params);
        vm.assertEq(f.totalChecked(), 2);
        vm.assertEq(address(f).balance, 0.008 ether);

        uint256[] memory params1 = new uint256[](1);
        params1[0] = 2;
        f.flip{value: 0.001 ether}(params1);
        vm.assertEq(f.totalChecked(), 3);
        vm.assertEq(address(f).balance, 0.0045 ether);

        vm.assertEq(f.checkOut(), 0.0045 ether);
    }

    function test_get_status() public {
        Ckbx f = new Ckbx(6, 0.001 ether);
        uint256[] memory params = new uint256[](1);

        params[0] = 1;
        f.flip{value: 0.001 ether}(params);

        params[0] = 3;
        f.flip{value: 0.001 ether}(params);

        params[0] = 5;
        f.flip{value: 0.001 ether}(params);

        params[0] = 3;
        f.flip{value: 0.001 ether}(params);

        uint256[] memory out1 = f.getState(0, 3);
        vm.assertEq(out1[0], 0);
        vm.assertEq(out1[1], 1);
        vm.assertEq(out1[2], 0);

        uint256[] memory out2 = f.getState(3, 3);
        vm.assertEq(out2[0], 2);
        vm.assertEq(out2[1], 0);
        vm.assertEq(out2[2], 1);

        uint256[] memory out3 = f.getState(2, 3);
        vm.assertEq(out3[0], 0);
        vm.assertEq(out3[1], 2);
        vm.assertEq(out3[2], 0);

        vm.expectRevert();
        f.getState(4, 3);
    }

    function test_checkout() public {
        payable(address(1234)).transfer(1 ether);
        payable(address(2345)).transfer(1 ether);
        payable(address(3456)).transfer(1 ether);

        Ckbx f = new Ckbx(3, 0.001 ether);
        uint256[] memory params = new uint256[](1);

        vm.assertEq(address(1234).balance, 1 ether);
        vm.startPrank(address(1234));
        params[0] = 0;
        f.flip{value: 0.001 ether}(params);
        vm.stopPrank();
        vm.assertEq(address(1234).balance, 1 ether - 0.001 ether);

        vm.assertEq(address(2345).balance, 1 ether);
        vm.startPrank(address(2345));
        params[0] = 1;
        f.flip{value: 0.001 ether}(params);
        vm.stopPrank();
        vm.assertEq(address(2345).balance, 1 ether - 0.001 ether);

        vm.assertEq(address(3456).balance, 1 ether);
        vm.startPrank(address(3456));
        params[0] = 2;
        f.flip{value: 0.001 ether}(params);
        vm.stopPrank();
        vm.assertEq(
            address(3456).balance,
            1 ether - 0.001 ether + 0.0015 ether
        );

        vm.startPrank(address(1234));
        f.checkOut();
        vm.stopPrank();
        vm.startPrank(address(1234));
        f.checkOut();
        vm.stopPrank();
        vm.startPrank(address(2345));
        f.checkOut();
        vm.stopPrank();
        vm.startPrank(address(2345));
        f.checkOut();
        vm.stopPrank();
        vm.startPrank(address(2345));
        f.checkOut();
        vm.stopPrank();
        vm.startPrank(address(3456));
        f.checkOut();
        vm.stopPrank();

        vm.assertEq(
            address(1234).balance,
            1 ether - 0.001 ether + 0.0005 ether
        );
        vm.assertEq(
            address(2345).balance,
            1 ether - 0.001 ether + 0.0005 ether
        );
        vm.assertEq(
            address(3456).balance,
            1 ether - 0.001 ether + 0.0015 ether + 0.0005 ether
        );
    }

    function test_checkout_large_game() public {
        for (uint256 i = 10; i < 110; i++) {
            payable(address(uint160(i))).transfer(1 ether);   
        }

        Ckbx f = new Ckbx(100, 0.001 ether);

        for (uint256 i = 10; i < 110; i++) {
            vm.startPrank(address(uint160(i)));
            uint256[] memory params = new uint256[](1);
            params[0] = i - 10;
            f.flip{value: 0.001 ether}(params);
            vm.stopPrank();
            if (i < 109) {
                vm.assertEq(address(uint160(i)).balance, 1 ether - 0.001 ether);
            } else {
                vm.assertEq(address(uint160(i)).balance, 1 ether - 0.001 ether + 0.05 ether);
            }
        }

        for (uint256 i = 10; i < 110; i++) {
            vm.startPrank(address(uint160(i)));
            f.checkOut();
            vm.stopPrank();
        }

        for (uint256 i = 10; i < 110; i++) {
            if (i < 109) {
                vm.assertEq(address(uint160(i)).balance / 10 * 10, 1 ether - 0.001 ether + 0.000454545454545450 ether);
            } else {
                vm.assertEq(address(uint160(i)).balance / 10 * 10, 1 ether - 0.001 ether + 0.05 ether + 0.000454545454545450 ether);
            }
        }
    }

    // Allow the game contract to pay back the test contract
    receive() external payable {}
}
