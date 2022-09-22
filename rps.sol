//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RPS {
    constructor() payable {}

    enum Hand {
        rock, scissors, paper
    }

    enum PlayerStatus {
        WIN, LOSE, TIE, PENDING
    }

    struct Player {
        address payable addr;
        uint256 betAmount;
        Hand hand;
        PlayerStatus status;
    }
}