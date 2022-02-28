// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import 'hardhat/console.sol';


contract WavePortal {

    uint256 totalWaves;
    /* We will be using this below to help generate a randdom number */
    uint256 private seed;

    /* google what events are in Solidity */
    event NewWave(address indexed from, uint256 timestamp, string message);

    /* Created a struct named Wave
        a struct is basically a custom datatype where we can customize what we want to hold inside it
     */

     struct Wave {
         address waver; // the address of the user who waved
         string message; // the message the user sent
         uint256 timestamp; // time when the user waved
     }

     /* Declare a variable waves that lets me store an array of structs.
        This is what lets me hold all the waves anyone ever sends to me!
       */

    Wave[] waves;

    /* This is an address => uint mapping, meaning I can associate an address with a number!
        In this case, I'll be storing the address with the last time the user waved at us.
     */
     mapping(address => uint256) public lastWavedAt;
     
    constructor () payable {
        console.log('We have been contructed!');
    
    /* Set the initial seed */
    seed = (block.timestamp + block.difficulty) % 100;
    }

    /* Notice I changed the wavefunction a little here as well and 
        now it requires a string called _message. This is the messgae our user
        sends us from the frontend!
     */ 
     function wave(string memory _message) public {
         /* We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored */
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            'Must wait 30 seconds before waving again.'
        );
        /* Update the current timestamp we have for the user */
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log('$s has waved!', msg.sender);    

    /* This is where I actually store the wave data in the array */
    waves.push(Wave(msg.sender, _message, block.timestamp));

    /* Generate a new seed for the next user that send a wave */
    seed = (block.difficulty + block.timestamp + seed) % 100;

    /* Give a 50% chance the user wins the prize */
    if(seed <= 50) {
        console.log('%s won!', msg.sender);

       /* this makes it so people can get ether for waving at me */
        uint256 prizeAmount = 0.0001 ether;
        require(
            prizeAmount <= address(this).balance, //starting at '<=' this is the balance of the contract itself
            'Trying to withdraw more money than the contract has.'
        );
        (bool success, ) = (msg.sender).call{value: prizeAmount}('');
        require(success, 'Failed to withdraw money from contract.');
    }

    /* I added some fanciness here, Google it and try to figure out what it is! */
    emit NewWave(msg.sender, block.timestamp, _message);

    }
    /* I added a function getAllWaves which will return the struct array, waves, to us.
        This will make it easy to retrieve the waves from our website!
     */
    function getAllWaves() public view returns (Wave[] memory) {
       return waves;
    }

    function getTotalWaves () public view returns (uint256) {
        /* Optional: add this line if you want to see the contract print the value
            We'll also print it over in run.js as well.
         */
        return totalWaves;
    }
}


