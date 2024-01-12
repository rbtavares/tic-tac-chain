// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract TicTacToe {

    //> Variables
    // Players
    address payable public host;
    address payable public opponent;

    // Game Data
    address public currentPlayer;
    address public winner;

    uint256 public gameCreated;
    uint256 public entryFee;

    uint8[3][3] public board;

    //> Constructor
    constructor() payable {

        // Game entry fee
        require(msg.value >= 0.001 ether, "minimum entry fee is 0.001 ether");
        entryFee = msg.value;

        // Define initial player information
        host = payable(msg.sender);
        currentPlayer = host;

        // Register initial game data
        gameCreated = block.timestamp;

    }

    //> Modifiers
    // Check if the game has ended
    modifier isGameOver(bool _state) {
        if (_state) {
            require(winner != address(0), "game not finished yet");
        } else {
            require(winner == address(0), "game already finished");
        }
        _;
    }

    //> Game Info Functions
    // Get the host player
    function getHost() public view returns (address) {
        return host;
    }

    // Get the opponent player
    function getOpponent() public view returns (address) {
        return opponent;
    }

    // Get the game winner
    function getWinner() public view isGameOver(true) returns (address) {
        return winner;
    }

    // Get the current player to make a move
    function getCurrentPlayer() public view isGameOver(false) returns (address) {
        return currentPlayer;
    }

    //> Join/Leave Functions
    // Join the game as opponent
    function joinGame() payable public isGameOver(false) {
        require(opponent == address(0), "game is full");
        require(msg.sender != host, "can't play against self");
        require(msg.value == entryFee, "wrong entry fee");
        opponent = payable(msg.sender);
    }

}