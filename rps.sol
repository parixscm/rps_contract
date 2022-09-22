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

    enum GameStatus {
        NOT_STARTED, STARTED, COMPLETE, ERROR
    }

    struct Game {
        Player host;
        Player guest;
        uint256 totalBetAmount;
        GameStatus status;
    }

    mapping(uint => Game) rooms;
    uint roomLen = 0;
    
    function createRoom(Hand _hand) public payable returns(uint roomNum) {
        rooms[roomLen] = Game(
            Player(
                payable(msg.sender),
                msg.value,
                _hand,
                PlayerStatus.PENDING
            ),
            Player(
                payable(msg.sender),
                0,
                Hand.rock,
                PlayerStatus.PENDING
            ),
            msg.value,
            GameStatus.NOT_STARTED
        );
        roomNum = roomLen;
        roomLen += 1;
    }
}