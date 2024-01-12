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
        require(msg.value >= 0.001 ether, "minimum fee 0.001 ether");
        entryFee = msg.value;

        // Define initial player information
        host = payable(msg.sender);
        currentPlayer = host;

        // Register initial game data
        gameCreated = block.timestamp;

    }

    //> Modifiers
    // Check if the game has ended
    modifier gameNotOver() {
        require(winner == address(0), "Game has already finished");
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
    function getWinner() public view gameNotOver returns (address) {
        return winner;
    }

    // Get the current player to make a move
    function getCurrentPlayer() public view gameNotOver returns (address) {
        return currentPlayer;
    }

    //> Join/Leave Functions
    // Join the game as opponent
    function joinGame() payable public gameNotOver {
        require(opponent == address(0), "this game already has 2 players");
        require(msg.sender != host, "can't play against self");
        require(msg.value == entryFee, "wrong entry fee");
        opponent = payable(msg.sender);
    }

}