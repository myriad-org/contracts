-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil scopefile

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

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

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast -v

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -v
endif

dep-myriad:
	@forge script script/DeployMyriad.s.sol:DeployMyriad $(NETWORK_ARGS)

upgrade-myriad:
	@forge script script/UpgradeMyriad.s.sol:UpgradeMyriad $(NETWORK_ARGS)

dep-gov-token:
	@forge script script/DeployGovernanceToken.s.sol:DeployGovernanceToken $(NETWORK_ARGS)

dep-gov-cont:
	@forge script script/DeployGovernorContract.s.sol:DeployGovernorContract $(NETWORK_ARGS)

dep-timelock:
	@forge script script/DeployTimelock.s.sol:DeployTimelock $(NETWORK_ARGS)

check-myriad:
	@forge script script/Custom.s.sol:Custom $(NETWORK_ARGS)

reg-patient:
	@forge script script/RegisterPatient.s.sol:RegisterPatient $(NETWORK_ARGS)

