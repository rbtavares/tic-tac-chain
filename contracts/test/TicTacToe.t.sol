// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {TicTacToe} from "../src/TicTacToe.sol";

contract TicTacToeTest is Test {
    TicTacToe public game;

    function setUp() public {
        game = new TicTacToe{value: 1 ether}(300);
    }

    function testCreationDeposit() public {
        // Check game entry deposit
        assertEq(address(game).balance, 1 ether);
        // Check entry fee variable
        assertEq(game.entryFee(), 1 ether);
    }

    function testHostInformation() public {
        // Check game host address
        assertEq(game.host(), address(this));
        // Check host is set as current player
        assertEq(game.currentPlayer(), address(this));
        assertEq(game.getCurrentPlayer(), address(this));
        assertEq(game.getCurrentPlayer(), game.currentPlayer());
    }

}
