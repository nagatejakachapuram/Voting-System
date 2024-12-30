//SPDX-license-Identifier: MIT

pragma solidity ^0.8.26;

contract voting {
    struct voter {
        string s_name;
        uint256 s_age;
        bool s_voted;
    }

    struct candidate {
        string s_candidateName;
        uint256 s_totalVotes;
    }

    mapping(string => uint256) candidateVotes;
    mapping(address => voter) voters;
    candidate[] public candidates;

    // Creating candidates
    function addCandidate(string memory _candidateName) public {
        candidates.push(candidate(_candidateName, 0));
    }

    // Registration of voter.
    function registerVoter(string memory s_name, uint256 s_age) public {
        require(voters[msg.sender].s_voted != false, "You have already voted");
        require(voters[msg.sender].s_age >= 18, "Voter must be 18 or older");
        voters[msg.sender] = voter(s_name, s_age, false);
    }

    // Voting for a candidate
    function vote(string memory _candidateName) public {
        voter storage sender = voters[msg.sender];
        // If voter is not registered age is defaulted to 0.
        require(sender.s_age > 0, "Voter is not registered");
        require(!sender.s_voted, "Voter has already voted");

        // Checking voters can vote to valid candidates by comparing strings.
        bool candidateExists = false;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (
                keccak256(abi.encodePacked(candidates[i].s_candidateName)) ==
                keccak256(abi.encodePacked(_candidateName))
            ) {
                candidates[i].s_totalVotes += 1;
                candidateExists = true;
                break;
            }
        }

        require(candidateExists, "Candidate does not exist");
        sender.s_voted = true; // Mark voter as having voted
    }

    function votingWinner() public {
        uint256 winningVoteCount = 0;
    }
}
