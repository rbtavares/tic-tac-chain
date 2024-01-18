// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract TicTacToe {

    //> Variables
    // Player Data
    address public host;
    address public opponent;

    address public currentPlayer;
    address public winner;

    // Prize Pool Data
    uint256 public entryFee;

    // Time Data
    uint256 public moveTimeout;
    uint256 public lastMove;

    // Board Data
    address[3][3] public board;

    //> Constructor
    constructor(uint256 _moveTimeout) payable {

        // Host defines and deposits entry fee
        require(msg.value >= 0.001 ether, "minimum entry fee is 0.001 ether"); // check minimum fee
        require(address(this).balance == msg.value, "error depositing entry fee"); // check entry fee deposited
        entryFee = msg.value;

        // Host address is saved to host variable and is set as current player
        host = msg.sender;
        currentPlayer = host;
        assert(host == msg.sender);
        assert(currentPlayer == host);

        // Move timeout is set
        moveTimeout = _moveTimeout;
        assert(moveTimeout == _moveTimeout);

    }

    //> Modifiers
    modifier gameNotFinished() {
        require(winner == address(0), "game has already finished");
        _;
    }

    modifier gameFinished() {
        require(winner != address(0), "game has not finished yet");
        _;
    }

    //> Game Info Functions
    // Get the host player
    function getHost() public view returns (address) {
        return host;
    }

    // Get the opponent player
    function getOpponent() public view returns (address) {
        require(opponent != address(0), "game does not have opponent");
        return opponent;
    }

    // Get the game winner
    function getWinner() public gameFinished view returns (address) {
        return winner;
    }

    // Get the current player to make a move
    function getCurrentPlayer() public gameNotFinished view returns (address) {
        return currentPlayer;
    }

    // Get the current board state
    function getCurrentBoard() public view returns (address[3][3] memory) {
        address[3][3] memory _boardState = board;
        return _boardState;
    }

    //! Temporary Function
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    //> Join/Leave Functions
    // Join the game as opponent
    function joinGame() payable public gameNotFinished {
        require(opponent == address(0), "game already has opponent");
        require(msg.sender != host, "can't play against self");
        require(msg.value == entryFee, "wrong entry fee");

        opponent = msg.sender;
        assert(opponent == msg.sender);

        lastMove = block.timestamp;
        assert(lastMove == block.timestamp);
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

            // Check positive diagonal
            if (board[0][0] == player && board[1][1] == player && board[2][2] == player) {
                winner = player;
                break;
            }

            // Check negative diagonal
            if (board[0][2] == player && board[1][1] == player && board[2][0] == player) {
                winner = player;
                break;
            }

            // Check rows & columns
            for(uint i = 0; i < board.length; i++) {

                // Check row i
                if (board[i][0] == player && board[i][1] == player && board[i][2] == player) {
                    winner = player;
                    break;
                }

                // Check col i
                if (board[0][i] == player && board[1][i] == player && board[2][i] == player) {
                    winner = player;
                    break;
                }
            }

            // If the winner is already picked do not check the remaining players
            if (winner != address(0)) {
                break;
            }
        }
        
        // If a player has become a winner, pay them
        if (winner != address(0)) {
            payWinner();
        }
    }


    //FIXME should I have this payWinner? Or should the winner call a withdrawPrize() function
    //FIXME (which can be called at a later time and as many times as needed incase of failure to send eth)
    function payWinner() private {
        require(winner != address(0), "no winner yet");

        // Send prize to winner
        bool sent = payable(winner).send(address(this).balance);
        require(sent, "could not pay winner");

        assert(address(this).balance == 0);
    }

    //> Move Functions
    function makeMove(uint8 _i, uint8 _j) public gameNotFinished {
        require(board[_i][_j] == address(0), "tile already taken");
        require(opponent != address(0), "game has no opponent yet");
        require(currentPlayer == msg.sender, "player not allowed to make moves now");

        // Update tile
        board[_i][_j] = msg.sender;
        assert(board[_i][_j] == msg.sender);

        // Update last move
        lastMove = block.timestamp;
        assert(lastMove == block.timestamp);

        // Check if move produced a winner
        checkWinner();

        // If there are no winners yet, swap to the other player
        if (winner == address(0)) {
            swapCurrentPlayer();
        }
    }

    //> Claim Wins
    function claimWin() public gameNotFinished {
        require(msg.sender == host || msg.sender == opponent, "you are not registered in this game"); //FIXME is it safe to do this even if opponent == 0x0000?

        // If the game has no opponent, host can claim win
        if(opponent == address(0)) {
            winner = host;
        } else {
            require(currentPlayer != msg.sender, "can't claim win when is current player");
            if (block.timestamp - lastMove > moveTimeout) {
                winner = msg.sender;
            }
        }

        // If winner was claimed pay them
        if (winner != address(0)) {
            payWinner();
        }
    }

}