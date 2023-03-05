// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Pearl.sol";
import {console} from "forge-std/console.sol";

contract PrealTest is Test {
    Pearl public pearl;
    address private alice;
    address private bob;

    function setUp() public {
        pearl = new Pearl();
        alice = address(1);
        bob = address(2);
    }

    function testTransfer() public {
        pearl.mint(10000);
        pearl.transfer(alice, 5000);

        //assertEq(pearl.balanceOf(alice), 5000);
        assertEq(pearl.balanceOf(address(this)), 5000);
    }

    function testApprove() public {
        pearl.mint(10000);
        pearl.approve(bob, 1000);

        assertEq(pearl.allowance(address(this), bob), 1000);
    }

    function testTransferFrom(uint256 x) public {
        pearl.mint(x);
        pearl.approve(bob, x / 2);
        vm.prank(bob);
        pearl.transferFrom(address(this), alice, x / 2);
        assertEq(pearl.balanceOf(address(this)), x - x / 2);
    }
}
