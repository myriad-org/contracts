-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil scopefile

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
PATIENT_PRIVATE_KEY := 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d

all: remove install build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install foundry-rs/forge-std --no-commit && forge install openzeppelin/openzeppelin-contracts --no-commit && forge install openzeppelin/openzeppelin-contracts-upgradeable --no-commit 

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY)
endif

dep-myriad:
	@forge script script/4DeployMyriad.s.sol:DeployMyriad $(NETWORK_ARGS)

upgrade-myriad:
	@forge script script/6UpgradeMyriad.s.sol:UpgradeMyriad $(NETWORK_ARGS)

dep-gov-token:
	@forge script script/1DeployGovernanceToken.s.sol:DeployGovernanceToken $(NETWORK_ARGS)

dep-gov-cont:
	@forge script script/3DeployGovernorContract.s.sol:DeployGovernorContract $(NETWORK_ARGS)

dep-timelock:
	@forge script script/2DeployTimelock.s.sol:DeployTimelock $(NETWORK_ARGS)

check-myriad:
	@forge script script/99Custom.s.sol:Custom $(NETWORK_ARGS)

reg-patient:
	@forge script script/5RegisterPatient.s.sol:RegisterPatient --rpc-url http://localhost:8545 --private-key $(PATIENT_PRIVATE_KEY) --broadcast

reg-doctor:
	@forge script script/7AddDoctorDetails.s.sol:AddDoctorDetails $(NETWORK_ARGS)

reg-hospital:
	@forge script script/8AddHospitalDetails.s.sol:AddHospitalDetails $(NETWORK_ARGS)

reg-clinic:
	@forge script script/9AddClinicDetails.s.sol:AddClinicDetails $(NETWORK_ARGS)

reg-lab:
	@forge script script/10AddLabDetails.s.sol:AddLabDetails $(NETWORK_ARGS)

setup:
	make dep-gov-token
	make dep-timelock
	make dep-gov-cont
	make dep-myriad
	make reg-patient
	make reg-doctor
	make reg-hospital
	make reg-clinic
	make reg-lab

