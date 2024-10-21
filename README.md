# Myriad: Democratizing Governance and Medical System

> V1 (MediChain) can be found at: [MediChain Repository](https://github.com/sadityakumar9211/medichain-hardhat)

Myriad is a decentralized platform designed to address critical challenges in healthcare data management and governance. It empowers patients with secure control over their medical records using blockchain and gives them the ability to participate in healthcare governance through Decentralized Autonomous Organizations (DAOs). Myriad leverages decentralized storage (IPFS) and secure encryption to protect patient data, while enabling stakeholders to vote on system improvements.

This repository houses the core **smart contract logic** developed using **Foundry**.

## Key Features

- **Decentralized Data Management**: Patients securely control access to their medical data, which is stored using IPFS with end-to-end encryption (4096-bit RSA).
- **Governance with DAO**: Patients, doctors, clinics, and other entities participate in a decentralized governance system to vote on proposals related to system improvements.
- **Blockchain-based Voting**: Weighted voting mechanisms allow for fair decision-making, ensuring transparency and accountability.
- **Secure Data Sharing**: Patients can share medical data with healthcare providers through encrypted QR codes, ensuring data privacy and security.

---

## Technology Stack

- **Smart Contracts**: Solidity
- **Development Framework**: [Foundry](https://book.getfoundry.sh/)
- **Blockchain**: Ethereum (Sepolia Testnet)
- **Storage**: IPFS for decentralized file storage
- **Wallet Integration**: Metamask

---

## Getting Started

### Prerequisites

- Install **Foundry** by running:
  
  ```bash
  curl -L https://foundry.paradigm.xyz | bash
  foundryup
  ```

### Building the Project

To build the smart contracts, run:
```bash
forge build
```
### Running Tests

To execute the test suite:
```bash
forge test
```
### Deploying the Contracts

To deploy the smart contracts, use the following command with your RPC URL and private key:
```bash
forge script script/Contract.s.sol:ContractScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```
### Running a Local Test Node

You can use Anvil to spin up a local Ethereum node:
```bash
anvil
```
### Usage and Features

	•	Data Management with IPFS: Patient records are stored in encrypted form on IPFS, with hashes recorded on the blockchain.
	•	DAO Governance: Myriad utilizes a Decentralized Autonomous Organization (DAO) for healthcare governance, where participants vote on system policies and improvements using weighted voting mechanisms.
	•	Secure Sharing: Medical data can be securely shared using QR codes, ensuring only authorized access.

### Gas Snapshot

For gas analysis and optimization:
```bash
forge snapshot
```
### Other Commands

	•	Formatting: Run forge fmt to format your Solidity code.
	•	Help: View help options:
```bash
forge --help
anvil --help
cast --help
```


## Contributing

We welcome contributions from the open-source community! Please follow these steps:
1.	Fork the repository.
2.	Create a new branch (git checkout -b feature/new-feature).
3.	Commit your changes (git commit -m 'Add new feature').
4.	Push to the branch (git push origin feature/new-feature).
5.	Open a pull request.

## License

This project is distributed under the GPL-3.0 License. See the LICENSE file for details.

## Contact

- Call Me: Aditya Singh
- Twitter: @saditya9211
- LinkedIn: linkedin.com/in/saditya9211
- ETH Address: `0x1EDAFE36Fb88eE4683A9A9525c200bE5Ab8A94F3`

[Detailed project report](https://bit.ly/project-report-redacted)
