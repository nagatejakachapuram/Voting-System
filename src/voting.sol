// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Voting {
    uint256 MINIMUM_AGE = 18;
    struct Voter {
        string s_name;
        uint256 s_age;
        bool s_voted;
    }

    struct Candidate {
        string s_candidateName;
        uint256 s_totalVotes;
    }

    mapping(address => Voter) public voters;
    Candidate[] public candidates;

    address private owner;

    // Events
    event CandidateAdded(string candidateName);
    event VoterRegistered(address voterAddress, string voterName);
    event VoteCast(address voterAddress, string candidateName);

    constructor() {
        owner = msg.sender;
    }

    // Modifier to allow only the owner to perform certain actions
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    // Modifier to ensure the voter is registered
    modifier isRegistered() {
        require(
            bytes(voters[msg.sender].s_name).length > 0,
            "Voter is not registered"
        );
        _;
    }

    // Modifier to ensure the voter has not voted yet
    modifier hasNotVoted() {
        require(!voters[msg.sender].s_voted, "Voter has already voted");
        _;
    }

    // Modifier to ensure the voter is of age (18 or older)
    modifier isOfAge() {
        require(
            voters[msg.sender].s_age >= MINIMUM_AGE,
            "Voter must be 18 or older"
        );
        _;
    }

    // Add a candidate (only the owner can do this)
    function addCandidate(string memory _candidateName) public onlyOwner {
        candidates.push(Candidate(_candidateName, 0));
        emit CandidateAdded(_candidateName); // Emit event
    }

    // Register a voter
    function registerVoter(
        string memory _name,
        uint256 _age
    ) public onlyOwner isOfAge {
        require(voters[msg.sender].s_age == 0, "Voter is already registered");
        voters[msg.sender] = Voter(_name, _age, false);
        emit VoterRegistered(msg.sender, _name); // Emit event
    }

    // Vote for a candidate
    function vote(
        string memory _candidateName
    ) public isRegistered hasNotVoted isOfAge {
        Voter storage sender = voters[msg.sender];
        bool candidateExists = false;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (
                keccak256(abi.encodePacked(candidates[i].s_candidateName)) ==
                keccak256(abi.encodePacked(_candidateName))
            ) {
                candidates[i].s_totalVotes += 1;
                candidateExists = true;
                emit VoteCast(msg.sender, _candidateName); // Emit event
                break;
            }
        }

        require(candidateExists, "Candidate does not exist");
        sender.s_voted = true; // Mark voter as having voted
    }

    // Get the total votes for a specific candidate
    function getCandidateVotes(
        string memory _candidateName
    ) public view returns (uint256) {
        for (uint256 i = 0; i < candidates.length; i++) {
            if (
                keccak256(abi.encodePacked(candidates[i].s_candidateName)) ==
                keccak256(abi.encodePacked(_candidateName))
            ) {
                return candidates[i].s_totalVotes;
            }
        }
        revert("Candidate doesn't exist");
    }

    // Get the total votes for all candidates
    function getAllResults() public view returns (Candidate[] memory) {
        return candidates;
    }

    // Get the winner
    function getWinner() public view returns (string memory) {
        uint256 maxVotes = 0;
        string memory winner;
        bool isTie = false;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].s_totalVotes > maxVotes) {
                winner = candidates[i].s_candidateName;
                maxVotes = candidates[i].s_totalVotes;
                isTie = false;
            } else if (candidates[i].s_totalVotes == maxVotes) {
                isTie = true;
            }
        }

        require(!isTie, "There is a tie, no winner can be determined");
        return winner;
    }
}
