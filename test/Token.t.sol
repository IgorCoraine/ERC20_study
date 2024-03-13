// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";

contract Tokenest is Test {
    Token public token;

    function setUp() public{
        token = new Token();
    }

    function test_getName() public {
        assertEq(token.name(), "Igor Coraine");
    }

    function test_getSymbol() public {
        assertEq(token.symbol(), "CORA");
    }

    function test_getDecimals() public {
        assertEq(token.decimals(), 18);
    }

    function test_getTotalSupply() public {
        assertEq(token.totalSupply(), 1000000*1e18);
    }

    function test_balanceOf() public {
        assertEq(token.balanceOf(address(this)), 1000000*1e18);
    }

    function testTransfer() public {
        token.transfer(address(1), 100);
        assertEq(token.balanceOf(address(this)), token.totalSupply()-100);
        assertEq(token.balanceOf(address(1)), 100);
    }

    function testApprovalAndTransferFrom() public {
        token.approve(address(1), 100);
        vm.prank(address(1));
        token.transferFrom(address(this), address(2), 50);
        assertEq(token.balanceOf(address(this)), token.totalSupply()-50);
        assertEq(token.balanceOf(address(2)), 50);
        assertEq(token.allowance(address(this), address(1)), 50);
    }

}
