# Myriad: Democratising Governance and Medical System
> Find V1 (MediChain) at: https://github.com/sadityakumar9211/medichain-hardhat

A decentralized system for digitalizing the medical ecosystem where patients can consult doctors, store medical documents securely (e2e encryption), ask the AI chatbots (MedPaLM / ChatGPT), vote on improvement proposals and issues in the existing system, along with doctors and other personnels. This proposes to democratise the medical ecosystem and patients will also have a say in the changes made to the system.

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

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
