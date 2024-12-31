// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;
import "forge-std/Script.sol";
import "../src/voting.sol";

contract DeployVoting is Script {
    function run() external {
        // Begin Broadcasting
        vm.startBroadcast();
        // Deploying the voting contract
        new Voting();
        // End broadcasting
        vm.stopBroadcast();
    }
}
