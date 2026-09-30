// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
import {Test} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
contract OurTokenTest is Test{
    uint256 public constant STARTING_BALANCE = 100 ether;
    OurToken public ourToken;
    DeployOurToken public deployer;
    address bob = makeAddr("Bob");
    address alice = makeAddr("Alice");

    function setUp() public{
        deployer = new DeployOurToken();
        ourToken = deployer.run();
        vm.prank(msg.sender);
        ourToken.transfer(bob,STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(STARTING_BALANCE,ourToken.balanceOf(bob));
    }
    function testAllowance() public {
        uint256 initialAllowance = 1000;

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

       uint256 transferAmount = 500;
       vm.prank(alice);
       ourToken.transferFrom(bob,alice,transferAmount);

       assertEq(ourToken.balanceOf(alice),transferAmount);
       assertEq(ourToken.balanceOf(bob),STARTING_BALANCE-transferAmount);
    }
}