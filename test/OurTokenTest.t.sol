// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test{
    OurToken public ourToken;
    DeployOurToken public deployer;
    address USER1 = makeAddr("user1");
    address USER2 = makeAddr("user2");
    uint256 public constant STARTING_BALANCE = 100 ether;
    function setUp() public{
        deployer = new DeployOurToken();
        ourToken = deployer.run();
        vm.prank(msg.sender);
        ourToken.transfer(USER1,STARTING_BALANCE);
    }
    function testBalance() public view{
        assertEq(STARTING_BALANCE , ourToken.balanceOf(USER1));
    }
    function testAllowances() public{
        uint256 initialAllowance = 1000;
        vm.prank(USER1);
        ourToken.approve(USER2,initialAllowance);
        vm.prank(USER2);
        uint256 transferAmount = 500;
        ourToken.transferFrom(USER1,USER2,transferAmount);
        assertEq(ourToken.balanceOf(USER2),transferAmount);
        assertEq(ourToken.balanceOf(USER1),STARTING_BALANCE - transferAmount);
    }
}

// forge test --match-test