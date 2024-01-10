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


----------------------------------------------------
# Myriad: Democratising Governance and Medical System

## Features / Requirements

### Primary Features

- Features of MediChain -- done
- DAO integration
- Chatbot integration (either MedPaLM or ChatGPT - best --> ChatGPT / MedPaLM 2) - can export the conversation details.
- A way to interact with the doctor's directly if they want (via chats / calling)

### Secondary Features
- a payment infrastructure (both via web3 way and fiat way - payment infrastructure — who determines the cost: cost of consultation is determined initially and the patient has to pay to the escrow account and the patient releases the money upon consultation. both can report each other in case of anything suspicious)

## Side Note:
- not completely replacing the existing system but working towards a solution in that direction - some common of regular checkups can be replaced by this. online consultation - doctors can decide if they want to examine the patients physically (a way to pass info to doctors before going to checkup)
- This is a complimentary system and is designed to work with the existing system and I am trying to remove as much as possible problems in the existing systems.
