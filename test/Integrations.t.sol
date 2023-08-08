// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {FundMe} from "../src/FundMe.sol";
import {IntegrationsFundMe, IntegrationsWithdraw} from "script/Integrations.s.sol";

contract Integeration is Test{
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SENDING_VALUE = 0.1 ether;
    uint256 constant STARTING_VALUE = 10 ether;
    function setUp() external{
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_VALUE);
    }

    function testFundInteraction() external{
        IntegrationsFundMe testFundMe = new IntegrationsFundMe();
        testFundMe.integrationFundMe(address(fundMe));

        IntegrationsWithdraw withdraw = new IntegrationsWithdraw();
        withdraw.integrationWithdraw(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}