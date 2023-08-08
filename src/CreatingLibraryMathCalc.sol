// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

//from the npm chainlink package [GitHub Repo], but since we have already downloaded this library in our libraries folder,
//we have remapped the import statement to the local library in the foundry.toml file.

library PriceConvertor {
    //all the functions are internal

    function getPrice(AggregatorV3Interface object) internal view returns (uint256) {
    // function getPrice() internal view returns (uint256) {  This was the function signature before we refactored the code 
    //                                                        to make it suitble for multiple chains. Since having a hardocded 
    //                                                        contract address for getting the price feeds was not preferrable.
        //ABI
        //Address: In this case the address of this contract for Sepolia TestNet
        //         for the USD-Eth conversion rate: 0x694AA1769357215DE4FAC081bf1f309aDC325306

        // AggregatorV3Interface object = AggregatorV3Interface(
        //     0x694AA1769357215DE4FAC081bf1f309aDC325306
        // );
        //Since this address exists only on the Sepolia Chain, this won't exist on the Anvil chain. This is what will cause the error
        //when we complie or test any function or contract that uses this. To overcome this we have the RPC_URL in the .env file.
        //If we use this RPC_URL when compiling, Anvil will simulate the respective chain and deploy on it. We do it by adding:
        //```--fork-url $RPC_URL_VAR_NAME```    

        (, int256 answer, , , ) = object.latestRoundData();
        //Above is the same as below:
        //(uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) = object.latestRoundData();
        //Since the latestRoundData() returns 5 values {ctrl+click on the import link}
        return uint256(answer * 1e10);
        //Eth in terms of USD
        //msg.value is a 18 decimal no. & answer is 8 decimal number, therfore to match up we
        //multiply by 1e10.
        //Using decimal point in solity messes up large calculations.
        //The actual value can be easily determined by finding the number of decimal places
        //which is easily obtained by using the .decimals() function of this
        //AggregatorV3Interface contract. Usually this is 8.
    }

    function getConvertedValueInUSD(
        uint256 ethAmt,
        AggregatorV3Interface priceFeed //This was added while refactoing
    ) internal view returns (uint256) {
        // uint256 rate = getPrice();  orignial code
        uint256 rate = getPrice(priceFeed); //after refactoring
        uint256 amtUSD = (rate * ethAmt) / 1e18; //since it will now have 36 digits, we divide.
        return amtUSD;
    }
}
