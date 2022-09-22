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

    modifier isValidHand(Hand _hand) {
        require((_hand == Hand.rock) || (_hand == Hand.scissors) || (_hand == Hand.paper));
        _;
    }
    
    function createRoom(Hand _hand) public payable isValidHand(_hand) returns(uint roomNum) {
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

    function joinRoom(uint roomNum, Hand _hand) public payable isValidHand(_hand) {
        rooms[roomNum].guest = Player(
            payable(msg.sender),
            msg.value,
            _hand,
            PlayerStatus.PENDING
        );
        rooms[roomNum].totalBetAmount += msg.value;
        compareHands(roomNum);
    }

    function compareHands(uint roomNum) private {
        uint8 host = uint8(rooms[roomNum].host.hand);
        uint8 guest = uint8(rooms[roomNum].guest.hand);
        
        rooms[roomNum].status = GameStatus.STARTED;

        if (host == guest) {
            rooms[roomNum].host.status = PlayerStatus.TIE;
            rooms[roomNum].guest.status = PlayerStatus.TIE;
        } else if ((guest + 1) % 3 == host) {
            rooms[roomNum].host.status = PlayerStatus.WIN;
            rooms[roomNum].guest.status = PlayerStatus.LOSE;
        } else if ((host + 1) % 3 == guest) {
            rooms[roomNum].host.status = PlayerStatus.LOSE;
            rooms[roomNum].guest.status = PlayerStatus.WIN;
        } else {
            rooms[roomNum].status = GameStatus.ERROR;
        }
    }
}