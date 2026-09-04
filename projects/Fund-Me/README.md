# FundMe — Foundry Smart Contract Project

A beginner-friendly Ethereum crowdfunding smart contract built with **Solidity** and **Foundry**.

The project allows users to fund the contract with ETH. The contract uses a **Chainlink Price Feed** to make sure the minimum contribution is worth at least **$5 USD**. Only the contract owner can withdraw the funds.

## 🚀 Features

* Users can fund the contract with ETH.
* Minimum funding requirement of $5 USD.
* Uses Chainlink Price Feeds for ETH/USD price conversion.
* Tracks how much each address has funded.
* Keeps track of funders.
* Only the owner can withdraw funds.
* Includes unit tests and integration tests.
* Includes deployment and interaction scripts.
* Supports local testing with Anvil.
* Includes network-specific configuration and mocks.

## 🛠️ Tech Stack

* **Solidity**
* **Foundry**

  * Forge
  * Anvil
  * Cast
* **Chainlink Price Feeds**
* **Foundry DevOps**

## 📁 Project Structure

```text
Fund-Me/
├── src/
│   ├── FundMe.sol
│   └── PriceConverter.sol
│
├── script/
│   ├── DeployFundMe.s.sol
│   ├── HelperConfig.s.sol
│   └── Interactions.s.sol
│
├── test/
│   ├── Unit/
│   │   └── FundMe.t.sol
│   ├── Integration/
│   │   └── FundMeIntegration.t.sol
│   └── Mocks/
│       └── MockV3aggregator.sol
│
├── foundry.toml
├── Makefile
└── README.md
```

## 🧪 Testing

Run all tests:

```bash
forge test
```

Run a specific test:

```bash
forge test --mt testUserCanFundAndOwnerWithdraw -vv
```

Generate a gas report:

```bash
forge test --gas-report
```

## ⛓️ Local Development

Start a local Ethereum blockchain using Anvil:

```bash
anvil
```

Custom Anvil setup:

```bash
anvil -m "test test test test test test test test test test test junk" --steps-tracing --block-time 1
```

> ⚠️ The mnemonic above is for local development only. Never use it with real funds.

## 🚢 Deployment

The project includes deployment scripts using Foundry Script.

Run the deployment script:

```bash
forge script script/DeployFundMe.s.sol
```

Deploy to a local Anvil blockchain:

```bash
forge script script/DeployFundMe.s.sol --rpc-url http://127.0.0.1:8545 --broadcast
```

## 💰 Interacting With the Contract

The project contains interaction scripts for:

* Funding the contract
* Withdrawing funds

The `foundry-devops` library is used to find the most recently deployed `FundMe` contract on the current chain.

## 🧠 What I Learned

Through this project, I learned and practiced:

* Solidity smart contract development
* Interfaces
* Chainlink Price Feeds
* Libraries and modifiers
* `msg.sender` and `msg.value`
* Contract ownership
* ETH transfers
* Unit testing with Foundry
* Integration testing
* Foundry cheatcodes
* Mock contracts
* Deployment scripts
* Helper configuration
* Anvil local blockchain
* Gas testing
* Foundry DevOps
* Git and GitHub

## 🔐 Security Notes

This project is primarily a **learning project** and has not been professionally audited.

Do not use it with real funds without a proper security review.

Never commit:

```text
.env
private keys
wallet credentials
API secrets
```

## 📚 Purpose

This project was built as part of my journey learning **Solidity, Foundry, Ethereum smart contract development, and smart contract security**.

It serves as a practical example of building, testing, deploying, and interacting with a Solidity smart contract.
