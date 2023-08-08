// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../src/Mocks/MockAggregatorV3.sol";

contract HelperConfig is Script {
    uint8 public constant Decimals = 8;
    int256 public constant InitialPrice = 2000e8;

    struct NetworkConfig{
        address priceFeed;
    }

    NetworkConfig public activeNetwrokConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetwrokConfig = getSepoliaConfig();
        } else if (block.chainid == 1) {
            activeNetwrokConfig = getEthMainnetConfig();
        } else {
            activeNetwrokConfig = getAnvilConfig();
        }
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory SepConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return SepConfig;
    }

    function getEthMainnetConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory EthMain = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return EthMain;
    }

    ///through this we deploy a mock aggregator contract to the Anvil chain
    function getAnvilConfig() public returns (NetworkConfig memory) {
        //This prevents the below contract from redploying if its already deplyed, since if the priceFeed variable has
        //a non-zero value - it signifies that etiher the Mock contract has been deployed or any of the other chains is being used.
        if (activeNetwrokConfig.priceFeed != address(0)) {
            return activeNetwrokConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            Decimals,
            InitialPrice
        );
        vm.stopBroadcast();
        NetworkConfig memory AnvConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return AnvConfig;
    }
}
