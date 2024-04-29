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


## Notes
- To be upgradable by dao, the owner of the core contract should be timelock contract and in the contract proposal it should execute upgradeToAndCall function:
```solidity
upgradeToAndCall(address newImplementation, bytes memory data) 
```
- So anyone, once the proposal is succedded and the timelock period is over, can call and upgrade the smart contract. 



## IMPORTANT: 
- ADD ALREADY ADDED LOGIC - so noone should be able to call it and get multiple tokens. 


- I don't have time. so i am defaulting back to erc20 tokens for each and each will vote. will change it to erc721 if required for hackathon submission in may after presentation in first week. Whenever I have time to kill (waste).

ERC-721 ERROR: Possibly, I am getting a weight of 0 when using _getVotes for some reason, that might be the reason. I am getting nonce too high error too. That could also be a cause. 
Currently the erc721 token is in erc721-dev branch 



 -- Optimization --> Unpin previous metadata file when the new file is added or profile is updated

-- pinata can be used in a better way to upload json and handle metadata of json and files. -- see docs
https://docs.pinata.cloud/api-reference/endpoint/update-file-metadata


--> For UI, we can have the list of files in the reverse order of their uploads, i.e. most recent file at the top.

DONE
--> It's better to store timestamp with block.timestamp as it's accurate and there is a delay b/w proposing the voting (with current timestamp in ipfs) and executing the instruction.
---> need to refactor the smart contract itself. 