// Layout of the contract file:
// version
// imports
// errors
// interfaces, libraries, contract

// Inside Contract:
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @title A sample Raffle Contract
 * @author Mahesh Babu
 * @notice This contract is for creating a sample raffle
 */

contract Raffle{
    /**errors */
    error Raffle__NotEnoughEthSent();
    uint256 private immutable i_entranceFee;
    address payable [] private s_players;

    constructor(uint256 entranceFee){
        i_entranceFee = entranceFee;
    }


    function enterRaffle() external payable{
        // require(msg.value >= i_entranceFee,"Send enough ETH");
        if(msg.value < i_entranceFee){
            revert Raffle__NotEnoughEthSent();
        }
        s_players.push(payable(msg.sender));
    }
    function pickWinner() public{}

    /**
     * Getter Function
     */
    function getEntranceFee() public view returns(uint256){
        return i_entranceFee;
    }
}