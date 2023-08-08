//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract IntegrationsFundMe is Script {

    uint256 constant VALUE = 0.1 ether;

    function integrationFundMe(address recentlyDeployed) public{
        vm.startBroadcast();
        FundMe(payable(recentlyDeployed)).fund{value: VALUE}();
        vm.stopBroadcast();
    }

    function run() external{
        address recentlyDeployed = DevOpsTools.get_most_recent_deployment("Fundme", block.chainid);
        vm.startBroadcast();
        integrationFundMe(recentlyDeployed);
        vm.stopBroadcast();
    }
}

contract IntegrationsWithdraw is Script{
    
    function integrationWithdraw(address recentlyDeployed) public {
        vm.startBroadcast();
        FundMe(recentlyDeployed).withdraw();
        vm.stopBroadcast();
    }

    function run() external{
        address recentlyDeployed = DevOpsTools.get_most_recent_deployment("Fundme", block.chainid);
        vm.startBroadcast();
        integrationWithdraw(recentlyDeployed);
        vm.stopBroadcast();
    }
}