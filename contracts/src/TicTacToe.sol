// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract TicTacToe {

    // Players
    address payable public host;
    address payable public opponent;

    // Game Data
    uint256 public gameCreated;
    uint256 public entryFee;

    // Game Mechanic
    uint8[3][3] public board;

    // Constructor
    constructor() payable {
        require(msg.value >= 0.001 ether, "minimum fee 0.001 ether");
        entryFee = msg.value;
        host = payable(msg.sender);
        gameCreated = block.timestamp;
    }

    function getHost() public view returns (address) {
        return host;
    }

    function getOpponent() public view returns (address) {
        return opponent;
    }

    function joinGame() payable public {
        require(opponent == address(0), "this game already has 2 players");
        require(msg.sender != host, "can't play against self");
        require(msg.value == entryFee, "wrong entry fee");
        opponent = payable(msg.sender);
    }

}