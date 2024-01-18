// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract TicTacToe {

    //> Variables
    // Players
    address public host;
    address public opponent;

    // Game Data
    address public currentPlayer;
    address public winner;

    uint256 public gameCreated;
    uint256 public entryFee;

    address[3][3] public board;

    //> Constructor
    constructor() payable {

        // Game entry fee
        require(msg.value >= 0.001 ether, "minimum entry fee is 0.001 ether");
        entryFee = msg.value;

        // Define initial player information
        host = msg.sender;
        currentPlayer = host;

        // Register initial game data
        gameCreated = block.timestamp;

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
    function getWinner() public view returns (address) {
        require(winner != address(0), "game not finished yet");
        return winner;
    }

    // Get the current player to make a move
    function getCurrentPlayer() public view returns (address) {
        require(winner == address(0), "game already finished");
        return currentPlayer;
    }

    // Get the current board state
    function getCurrentBoard() public view returns (address[3][3] memory) {
        address[3][3] memory _list = board;
        return _list;
    }

    //! Temp Functions
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    //> Join/Leave Functions
    // Join the game as opponent
    function joinGame() payable public {
        require(opponent == address(0), "game is full");
        require(msg.sender != host, "can't play against self");
        require(msg.value == entryFee, "wrong entry fee");
        require(winner == address(0), "game already finished");
        opponent = msg.sender;
    }

    //> Auxiliary Functions
    function swapCurrentPlayer() private {
        currentPlayer = currentPlayer == host ? opponent : host;
    }

    function checkWinner() private {
        require(winner == address(0), "game already finished");

        address[2] memory players = [host, opponent];

        for(uint p = 0; p < players.length; p++) {
            address player = players[p];

            // Check diagonals
            if ((board[0][0] == player && board[1][1] == player && board[2][2] == player) || (board[0][2] == player && board[1][1] == player && board[2][0] == player)) {
                winner = player;
                break;
            }

            // Check rows & columns
            for(uint i = 0; i < board.length; i++) {
                if ((board[i][0] == player && board[i][1] == player && board[i][2] == player) || (board[0][i] == player && board[1][i] == player && board[2][i] == player) ) {
                    winner = player;
                    break;
                }
            }

            // If the winner is already picked break
            if (winner != address(0)) {
                break;
            }
        }

        if (winner != address(0)) {
            payWinner();
        }
    }

    function payWinner() private {
        require(winner != address(0), "no winner yet");
        bool sent = payable(winner).send(address(this).balance);
        require(sent, "Failed to send Ether");
    }

    //> Move Functions
    function makeMove(uint8 _i, uint8 _j) public {
        require(winner == address(0), "game already finished");
        require(board[_i][_j] == address(0), "tile already taken");
        require(host != address(0), "game has no host yet");
        require(opponent != address(0), "game has no opponent yet");
        require(currentPlayer == msg.sender, "player not allowed to make moves now");

        board[_i][_j] = msg.sender;
        checkWinner();

        if (winner == address(0)) {
            swapCurrentPlayer();
        }
    }

}