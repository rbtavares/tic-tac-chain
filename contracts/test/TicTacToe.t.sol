// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {TicTacToe} from "../src/TicTacToe.sol";

contract TicTacToeTest is Test {
    TicTacToe public game;

    function setUp() public {
        game = new TicTacToe{value: 0.001 ether}();
    }

    function testHostAddress() public {
        assertEq(game.host(), address(this));
        assertEq(game.getHost(), address(this));
    }

    function testInitialBoardValues() public {
        assertEq(game.board(0, 0), 0);
        assertEq(game.board(0, 1), 0);
        assertEq(game.board(0, 2), 0);

        assertEq(game.board(1, 0), 0);
        assertEq(game.board(1, 1), 0);
        assertEq(game.board(1, 2), 0);

        assertEq(game.board(2, 0), 0);
        assertEq(game.board(2, 1), 0);
        assertEq(game.board(2, 2), 0);
    }

}
