# Voting Smart Contract
![License](https://img.shields.io/badge/license-MIT-blue.svg)


## Overview
This project implements a decentralized voting system on the Ethereum blockchain using Solidity. The contract ensures that:
- Voters can register and vote securely.
- Candidates can be added dynamically.
- Voting integrity is maintained (one voter, one vote).
- The winner is determined fairly after the voting period ends.

---

## Features
1. **Voter Registration:**
   - Users can register themselves as voters.
   - The system ensures only registered voters can vote.

2. **Candidate Registration:**
   - Candidates can be added dynamically.
   - Each candidate’s name and vote count are stored.

3. **Voting Process:**
   - Registered voters can cast their votes for any valid candidate.
   - Voters cannot vote more than once.

4. **Results Viewing:**
   - Users can view the total votes for each candidate.
   - The contract provides a way to determine the winner after the voting period ends.

---

## Prerequisites
- **Solidity:** ^0.8.0
- **Foundry:** A fast, portable, and modular toolkit for Ethereum development.
- **Node.js & npm:** For managing dependencies.
- **MetaMask:** For interacting with the deployed contract.

---

## Contract Details
### Structs
1. **`voter`**
   - `string s_name`: Name of the voter.
   - `uint256 s_age`: Age of the voter.
   - `bool s_voted`: Indicates if the voter has already voted.

2. **`candidate`**
   - `string s_candidateName`: Name of the candidate.
   - `uint256 s_totalVotes`: Total votes received by the candidate.

### Mappings
- `mapping(address => voter) voters`: Links an Ethereum address to its corresponding voter struct.
- `mapping(string => uint256) candidateVotes`: Maps a candidate's name to their total votes.

### Arrays
- `candidate[] candidates`: Stores all registered candidates.

---

## Functions

### 1. `registerVoter`
```solidity
function registerVoter(string memory _name, uint256 _age) public;
```
- **Purpose:** Allows users to register as voters.
- **Requirements:**
  - The caller must not already be registered.
  - Age must be greater than 18.

### 2. `addCandidate`
```solidity
function addCandidate(string memory _candidateName) public;
```
- **Purpose:** Adds a new candidate to the election.
- **Requirements:**
  - The candidate name must be unique.

### 3. `vote`
```solidity
function vote(string memory _candidateName) public;
```
- **Purpose:** Allows registered voters to cast a vote for a candidate.
- **Process:**
  - Validates that the voter is registered and hasn’t voted yet.
  - Checks if the candidate exists and increments their vote count.
  - Marks the voter as having voted.

### 4. `seeVotes`
```solidity
function seeVotes(string memory _candidateName) public view returns (uint256);
```
- **Purpose:** Allows users to view the total votes for a specific candidate.

### 5. `getWinner`
```solidity
function getWinner() public view returns (string memory);
```
- **Purpose:** Determines the candidate with the highest votes.
- **Tie Handling:** Returns a message if there is a tie between candidates.

---

## Deployment on Foundry

### Prerequisites
1. Install Foundry:
   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```

2. Set up a new Foundry project:
   ```bash
   forge init voting-system
   cd voting-system
   ```

### Add the Contract
1. Navigate to the `src/` directory and create your contract file:
   ```bash
   touch src/Voting.sol
   ```

2. Copy your smart contract code into `src/Voting.sol`.

### Write Deployment Script
1. Create a deployment script in the `script/` directory:
   ```bash
   touch script/DeployVoting.s.sol
   ```

2. Add the following code to `DeployVoting.s.sol`:
   ```solidity
   // SPDX-License-Identifier: MIT
   pragma solidity ^0.8.0;

   import "forge-std/Script.sol";
   import "src/Voting.sol";

   contract DeployVoting is Script {
       function run() external {
           vm.startBroadcast();

           // Deploy the Voting contract
           Voting voting = new Voting();

           console.log("Voting contract deployed at:", address(voting));

           vm.stopBroadcast();
       }
   }
   ```

### Compile the Contract
Run the following command to compile the contract:
```bash
forge build
```

### Deploy the Contract
1. Deploy the contract to a local or test network using Foundry:
   ```bash
   forge script script/DeployVoting.s.sol --broadcast --rpc-url <RPC_URL>
   ```

2. Replace `<RPC_URL>` with the RPC endpoint of your preferred network (e.g., Anvil, Goerli, etc.).

3. Example for a local Anvil network:
   ```bash
   anvil
   forge script script/DeployVoting.s.sol --broadcast --rpc-url http://127.0.0.1:8545
   ```

---

## Example Usage

### Register a Voter
```javascript
await contract.registerVoter("Alice", 25);
```

### Add a Candidate
```javascript
await contract.addCandidate("John Doe");
```

### Cast a Vote
```javascript
await contract.vote("John Doe");
```

### View Total Votes for a Candidate
```javascript
let votes = await contract.seeVotes("John Doe");
console.log(`Total Votes for John Doe: ${votes}`);
```

### Determine the Winner
```javascript
let winner = await contract.getWinner();
console.log(`Winner: ${winner}`);
```

---

## Security Considerations
1. **Double Voting:** Prevented by tracking voter addresses and marking them as having voted.
2. **Data Integrity:** Ensured by using mappings and hash-based candidate validation.
3. **Gas Efficiency:** Minimized storage reads and writes to optimize gas costs.

---

## Future Enhancements
1. **Role-based Access:** Allow only administrators to add candidates.
2. **Voting Deadline:** Implement a time-bound voting period.
3. **Event Emission:** Emit events for key actions like registration, voting, and result announcement.
4. **Anonymous Voting:** Use cryptographic techniques to anonymize votes.

---

## License
This project is licensed under the MIT License.
