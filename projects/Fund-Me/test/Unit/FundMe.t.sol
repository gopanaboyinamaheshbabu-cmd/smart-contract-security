// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.30;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    DeployFundMe deployFundMe;
    address user = makeAddr("user");
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant SEND_VALUE = 10e18;
    // uint256 constant GAS_PRICE = 1;

    function setUp() external {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(user, STARTING_BALANCE);
    }

    function testMinimumUSD() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerOfFundMeContract() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testVersionOfPriceFeed() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWIthoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFundDataStructure() public {
        vm.prank(user);
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getaddressToAmountFunded(user);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testNotOwnerWillNotWidrawFunds() public {
        vm.prank(user);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testAddFundersToArrayOfFunders() public {
        vm.prank(user);
        fundMe.fund{value: SEND_VALUE}();
        address funders = fundMe.getFunder(0);
        assertEq(funders, user);
    }
    modifier funded() {
        vm.prank(user);
        fundMe.fund{value: SEND_VALUE}();
        assert(address(fundMe).balance > 0);
        _;
    }

    function testOnlyOwnerCanWithdrawFunds() public funded {
        vm.expectRevert();
        vm.prank(user);
        fundMe.withdraw();
    }

    function testWithdrawFromASingleFunder() public funded {
        //Arrange
        uint256 startingfundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        //Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        //assert

        uint256 endingFundMeBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = fundMe.getOwner().balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(startingfundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint160 noOfFunders = 10;
        uint160 startIndex = 1;
        for (uint160 i = startIndex; i < noOfFunders + startIndex; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingfundMeBalance = address(fundMe).balance;

        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        vm.startPrank(fundMe.getOwner());

        fundMe.withdraw();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        assert(startingfundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
        assert((noOfFunders + 1) * SEND_VALUE == fundMe.getOwner().balance - startingOwnerBalance);
    }

    function testwithdrawFromMultipleFundersCheaper() public funded {
        uint160 noOfFunders = 10;
        uint160 startIndex = 1;
        for (uint160 i = startIndex; i < noOfFunders + startIndex; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingfundMeBalance = address(fundMe).balance;

        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        vm.startPrank(fundMe.getOwner());

        fundMe.cheaperWithdraw();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        assert(startingfundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
        assert((noOfFunders + 1) * SEND_VALUE == fundMe.getOwner().balance - startingOwnerBalance);
    }
}
