// SPDX-License-Identifier: MIT

//Send: To send currency
//Withdraw: To withdraw currency


pragma solidity ^0.8.0;

//--------------------ORIGINAL CODE W/O USIG THE PRICE CONVERTER LIBRARY-------------------
// import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"; 
// //from the npm chainlink package [GitHub Repo]

// contract FundMe{
//     uint256 public amountUSD = 50 * 1e18; // Read below for why we multiplied
//     //1e18 = 1 X 10^18 // 1 eth = 10^18 wei
//     //payable allows us to access the universal value variable
//     function send() public payable {
//         require(getConvertedValueInUSD(msg.value) >= amountUSD, "Not Enough"); 
//         //"Not Enough" is the revert msg here. Reverts make sure that if the require condition 
//         //isn't met, then the remaining gas(the total gas the function was called with, the 
//         //amount of gas remaining after execution of this line) is returned. Also all the data
//         // changes made upto this line are reverted back.
//     }

//     //To get the real world values of the USD, this decentralized network need a data source,
//     //since it cannot directly contact external real world data sources. Also we cannot use
//     //a single node as data source because it beats the purpose of decentralisation.
//     //This is where decentralized data source platforms such as ChainLink come in.
//     //here we use one of their contracts to get the realtime values.
//     //definitely check out the actual code on their docs.

//     function getPrice() public view returns(uint256) {
//         //ABI
//         //Address: In this case the address of this contract for Sepolia TestNet
//         //         for the USD-Eth conversion rate: 0x694AA1769357215DE4FAC081bf1f309aDC325306

//         AggregatorV3Interface object = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
//         (, int256 answer,,,) = object.latestRoundData();
//         //Above is the same as below:
//         //(uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) = object.latestRoundData();
//         //Since the latestRoundData() returns 5 values {ctrl+click on the import link}
//         return uint256(answer * 1e10);
//         //Eth in terms of USD
//         //msg.value is a 18 decimal no. & answer is 8 decimal number, therfore to match up we
//         //multiply by 1e10.
//         //Using decimal point in solity messes up large calculations.
//         //The actual value can be easily determined by finding the number of decimal places
//         //which is easily obtained by using the .decimals() function of this
//         //AggregatorV3Interface contract. Usually this is 8.
//     }

//     function getConvertedValueInUSD(uint256 ethAmt) public view returns(uint256){
//         uint256 rate = getPrice();
//         uint256 amtUSD = (rate * ethAmt) / 1e18; //since it will now have 36 digits, we divide.
//         return amtUSD;
//     }  

// }

//-------------------------USING THE PRICE CONVERTOR CUSTOM LIBRARY----------------------

import "./CreatingLibraryMathCalc.sol";

contract FundMe{

    //we can use constant and immutable keywords when the value won't ever change
    //this save gas

    using PriceConvertor for uint256;
    uint256 public constant amountUSD = 50 * 1e18;  
    address[] public SenderList; //address is being treated as a data type to store adrresses
    mapping(address => uint256) public senderToAmountSent;
    
    AggregatorV3Interface private priceFeedAddress;

    //this constructor block ensures that the one who deplous the contract becomes the
    //owner of the contract. Thus making sure certain functions (eg: withdraw()) are 
    //available only to the owner of the contract
    address public immutable owner;//updateable once in the constructor
    constructor(address priceFeed){//this runs only once, at the time of deployment
        owner = msg.sender;
        priceFeedAddress = AggregatorV3Interface(priceFeed);
    }

    function send() public payable {
        require(msg.value.getConvertedValueInUSD(priceFeedAddress) >= amountUSD, "Not Enough");
        //the refactored code
        //PATTERN: first_param.function(sec_param,third_param,...) 
        //continuing ahead from the previous section of creating and implementing library

        SenderList.push(msg.sender);
        senderToAmountSent[msg.sender] += msg.value;
    }

    //Now we need a function to withdraw all the amount deposited in the contract
    //The address that runs this functions will withdraw all the amount and the senderList
    //will be reset. The entire deposited funcd wiil be sent to the calling address

    function withdraw() public ownerOnly{

        //resetting the mapping
        for(uint256 startingIndex = 0; startingIndex < SenderList.length; startingIndex++){
            address sender = SenderList[startingIndex];
            senderToAmountSent[sender] = 0;
        }
        //resetting the array
        SenderList = new address[](0);

        //Now we need to actually send the funds to the calling address

        //IMPORTANT-------------------------IMPORTANT--------------------------IMPORTANT
        //There are three ways to send funds:

        //[1] transfer: returns error in case of failure
        //    payable(msg.sender).tansfer(address(this).balance);
        //              msg.sender is just an address
        //              payable(msg.sender)  is a transactional address 

        //[2] send: returns a boolean 
        //    bool success = payable(msg.sender).send(address(this).balance);
        //    require(success, "Transaction failed));

        //MOST RECOMMENDED, therefore we use this in here
        //[3] call: returns two values. Also: .call(/*any other functions that needs to be called can be put here*/)
        //    (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        //    require(success, "Transaction failed");
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "Transaction failed");
    }

    //the modifier block ensures that we don't need to write this require statement 
    //under all those functions that require the owner prvileges
    //Whenever the compiler confronts this ownerOnly modifier it runs the code inside this 
    //snippet first
    modifier ownerOnly{
        require(msg.sender == owner, "Sender isn't the owner");
        _; //signals the compiler to return and compile the rest of the code
    }

    //this function block runs automatically if someone send funds wihtout calling the 
    //appropriate function
    receive() external payable {
        send();
    }

    //look up, IDK
    fallback() external payable {
        send();
    }
    
}