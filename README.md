<div align="center" id="top"> 
  <img src="./.github/app.gif" alt="FUND ME" />

  &#xa0;

  <!-- <a href="https://web30.netlify.app">Demo</a> -->
</div>

<h1 align="center">Fund Me</h1>

<p align="center">
  <img alt="Github top language" src="https://img.shields.io/github/languages/top/LogiqueClergyman/Solidity_FundMe_Foundry?color=56BEB8">

  <img alt="Github language count" src="https://img.shields.io/github/languages/count/LogiqueClergyman/Solidity_FundMe_Foundry?color=56BEB8">

  <img alt="Repository size" src="https://img.shields.io/github/repo-size/LogiqueClergyman/Solidity_FundMe_Foundry?color=56BEB8">

  <img alt="License" src="https://img.shields.io/github/license/LogiqueClergyman/Solidity_FundMe_Foundry?color=56BEB8">

  <!-- <img alt="Github issues" src="https://img.shields.io/github/issues/{{YOUR_GITHUB_USERNAME}}/web3-0?color=56BEB8" /> -->

  <!-- <img alt="Github forks" src="https://img.shields.io/github/forks/{{YOUR_GITHUB_USERNAME}}/web3-0?color=56BEB8" /> -->

  <!-- <img alt="Github stars" src="https://img.shields.io/github/stars/{{YOUR_GITHUB_USERNAME}}/web3-0?color=56BEB8" /> -->
</p>

<!-- Status -->

<!-- <h4 align="center"> 
	🚧  Web3 0 🚀 Under construction...  🚧
</h4> 

<hr> -->

<p align="center">
  <a href="#dart-about">About</a> &#xa0; | &#xa0; 
  <a href="#sparkles-features">Features</a> &#xa0; | &#xa0;
  <a href="#rocket-technologies">Technologies</a> &#xa0; | &#xa0;
  <a href="#white_check_mark-requirements">Requirements</a> &#xa0; | &#xa0;
  <a href="#checkered_flag-starting">Starting</a> &#xa0; | &#xa0;
  <a href="#memo-license">License</a> &#xa0; | &#xa0;
  <a href="https://github.com/{{YOUR_GITHUB_USERNAME}}" target="_blank">Author</a>
</p>

<br>

## :dart: About ##

A simple smart contract written in Solidity, and developed using the Foundry Toolkit.
Allows funders to fund the contract, then only and only the contract deployer can withdraw the funds.

## :sparkles: Features ##

:heavy_check_mark: Deployable to any ethereum like chain;\
:heavy_check_mark: Multiple tests written, and passed;\
:heavy_check_mark: Can easily be connected to Metamask;

## :rocket: Technologies ##

The following tools were used in this project:

- [Foundry](https://github.com/foundry-rs/foundry)
- [Node.js](https://nodejs.org/en/)
- [Etherscan](https://sepolia.etherscan.io/)
- [Foundry-DevOps](https://github.com/Cyfrin/foundry-devops)

## :white_check_mark: Requirements ##

Before starting :checkered_flag:, you need to have [Git](https://git-scm.com) and [Node](https://nodejs.org/en/) installed.
[Foundry](https://github.com/foundry-rs/foundry) is also required to truly run all the tests, as this project uses several Foundry cheatcodes.
Also the netwrok URLs are read through the .env file, so make sure to include the RPC_URL(s) along with your account's private key.

## :checkered_flag: Starting ##

```bash
# Clone this project
$ git clone https://github.com/LogiqueClergyman/Solidity_FundMe_Foundry

# Access
$ cd Solidity_FundMe_Foundry

# Install dependencies
$ npm i

# Deploy the project
$ forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast

# The contract deployed can be viewed in detail at [Etherscan](https://sepolia.etherscan.io/)
```

## :memo: License ##

This project is under license from MIT. For more details, see the [LICENSE](LICENSE.md) file.


Made with :heart: by <a href="https://github.com/LogiqueClergyman" target="_blank">Aditya</a>

&#xa0;

<a href="#top">Back to top</a>
