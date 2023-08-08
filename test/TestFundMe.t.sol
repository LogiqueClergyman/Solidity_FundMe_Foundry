//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract TestFundMe is Test{
    
    FundMe fundMe;

    function setUp() external { //This setUp() function is called before each test function automatically
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumAmount() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    //This is a test before refactoring the code
    // function testOwnerVsSender() public {
    //     console.log("Owner: ", fundMe.owner());
    //     console.log("Sender: ", msg.sender);
    //     console.log("Address of this contract: ", address(this));
    //     assertEq(fundMe.owner(), address(this)); 
    //     assertEq(fundMe.owner(), msg.sender);
        // this fails because the owner is the deployer of the contract and this contract is being depoyed by 
        //the TestFundMe, not us. We call TestFundMe and itn return it deploys the FundMe contract.abi
        //So the owner of the FundMe contract is the TestFundMe contract.        
    // }

    function testOwnerVsSender() public {
        // console.log("Owner: ", fundMe.i_owner());
        console.log("Sender: ", msg.sender);
        console.log("Address of this contract: ", address(this)); 
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testVersion() public{
        assertEq(fundMe.getVersion(), 4);
    }

    // function testFailsWithoutEnoughFunds() public {
    //     //This cheatCode returns true if the next line causes a revert.
    //     vm.expectRevert();
    //     fundMe.fund(); // This equals send 0 eth.
    // }

    
    //makeAddr is a forgeStd cheatCode that input a name and returns a random address.
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_VALUE = 10 ether; 
    function testUpdatedDataStructures() public{
        vm.prank(USER);
        vm.deal(USER, STARTING_VALUE);
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testFundersDataStructure() public{
        vm.prank(USER);
        vm.deal(USER, STARTING_VALUE);
        fundMe.fund{value: SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        vm.deal(USER, STARTING_VALUE);
        fundMe.fund{value: SEND_VALUE}();
        _;
        
    }

    function testOtherThanOwnerCannotWithdarws() public funded{
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testDrawSingleFunder() public funded{
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingBalance = address(fundMe).balance;
        assertEq(endingBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + startingBalance);
    }

    function testMultipleFundersWithdraw() public funded{
        //uint256 cannot be converted to address, uint160 can be converted to address
        uint160 startingFunderAddress = 1;
        uint160 noOfFunders = 10;
        for(uint160 i = startingFunderAddress; i < noOfFunders; i++){
            hoax(address(i), SEND_VALUE);//hoax is a forgeStd command, warking similarly to prank and deal combined.  i is being typecasted to type "address"
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        assertEq(address(fundMe).balance, 0);
        assertEq(fundMe.getOwner().balance, startingOwnerBalance + startingBalance);
    }
}