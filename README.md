# Myriad: Democratising Governance and Medical System
A decentralized system for digitalizing the medical ecosystem where patients can consult doctors, store medical documents securely (e2e encryption), ask the AI chatbots (MedPaLM / ChatGPT), vote on improvement proposals and issues in the existing system, along with doctors and other personnels. This proposes to democratise the medical ecosystem and patients will also have a say in the changes made to the system. 

## Features / Requirements

Actors in the System: -

1. Patient - can register, view dashboard, view files, ask queries (to doctor / ai chatbot)
2. Doctors - dao adds to system, chat with patient, upload patient files, update profile info
3. Hospitals - dao adds to system, doctors are registered to hospitals / clinic, update profile info
4. Clinics - dao adds to system, doctors are registered to hospitals / clinic, update profile info
5. Diagnostic Lab - dao adds to system, update profile info

With DAO (Decentralized Autonomous Organization), every actor is given 1 vote with which they can participate and contribute to the decisions/proposals of this system. 

### Features
- Upgradable Contracts (contracts can be upgraded based on voting)
- DAO integration: People can create, discuss, and vote on the issues/proposals -- Everyone will get a single vote. 

- Chatbot integration (either MedPaLM or ChatGPT - best --> ChatGPT / MedPaLM 2) - can export the conversation details.
- A way to interact with the doctor's directly if they want (via chats / calling)


## Side Note:
- not completely replacing the existing system but working towards a solution in that direction - some common of regular checkups can be replaced by this. online consultation - doctors can decide if they want to examine the patients physically (a way to pass info to doctors before going to checkup)
- This is a complimentary system and is designed to work with the existing system and I am trying to remove as much as possible problems in the existing systems.



### Secondary Features
- a payment infrastructure (both via web3 way and fiat way - payment infrastructure — who determines the cost: cost of consultation is determined initially and the patient has to pay to the escrow account and the patient releases the money upon consultation. both can report each other in case of anything suspicious)




----------------------------------------------------------------------------------------------
## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

