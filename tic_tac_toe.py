# -*- coding: utf-8 -*-
"""
Created on Sun Aug 15 16:43:31 2021

@author: noahr
"""
import copy
import random
import mcts
import abstract_game as ag

class TicTacToe(ag.AbstractGame):
    """
    A tic-tac-toe board class.
    """
    SYMBOLS = ['X', 'O']
    O = True
    X = False

    # Magic Methods

    def __init__(self, values=None, current_move=True):
        """
        Constructor for a tik-tak-toe game.

        Parameters
        ----------
        values : List of 3 lists, each with 3 items.  optional
            Each sublist describes a row. Either 'X', 'O' or None. The default is [].
        current_move : bool, optional
            Which symbol is placed first, True (O), False (X). The default is True.

        Returns
        -------
        None.

        """
        if not values:
            #if values not provided, init to 3 sets of 2 Nones
            self.board = [[None, None, None],
                          [None, None, None],
                          [None, None, None]]
        else:
            self.board = values

        self.turn = current_move
        #'tie' is draw, None means undecided, otherwise winner is 'X' or 'O'
        self.winner = None
        self.check_win()

    def __getitem__(self, pos):
        """
        Called using [pos].

        Parameters
        ----------
        pos : int

        Returns
        -------
        list
            Row at pos.

        """
        return self.board[pos]

    def __str__(self):
        """
        Represent board as three line string, using 'X', 'O' or '.' (unclaimed).

        Returns
        -------
        return_string : str
            Current board state.

        """
        return_string = ""
        for row in self.board:
            for item in row:
                if item is None:
                    return_string+=". "
                else:
                    return_string+= item + " "
            return_string+="\n"
        return return_string

    def __repr__(self):
        """
        Game state information as a string.
        Includes current board, current winner and who's turn it is.

        Returns
        -------
        str
            All current state information.

        """
        winner = self.winner
        if self.winner is None:
            winner = "undecided"
        elif self.winner == 'tie':
            winner = "Draw"

        return (self.__str__() + "Current move is " +
                str(TicTacToe.SYMBOLS[self.turn]) + ", winner is " + winner)


    # Instance modtification methods

    def reset(self, values=None, current_move=True):
        """
        Reset game to initial conditions.
        Wrapper for recalling __init__.

        Parameters
        ----------
        values : List of 3 lists, each with 3 items.  optional
            Each sublist describes a row. Either 'X', 'O' or None. The default is [].
        current_move : bool, optional
            Which symbol is placed first, True (O), False (X). The default is True.


        """
        self.__init__(values=values, current_move=current_move)

    def copy(self):
        """
        Create and return clone of Board in current state.

        Returns
        -------
        Board
            Clone of current board.

        """
        return TicTacToe(copy.deepcopy(self.board), self.turn)


    # Movement methods

    def next_moves(self):
        """
        Generator for all possible next moves.

        Yields
        ------
        row : int
        col : int

        """
        for row in range(3):
            for col in range(3):
                if self[row][col] is None:
                    yield (row,col)

    def next_moves_list(self):
        """
        Get and return list of all legal next moves.

        """
        return list(self.next_moves())

    def make_move(self, move):
        """
        Make move given by cord tuple move=(row,col)

        Parameters
        ----------
        move : tuple->(row,col)
            row and col are 0-2 ints.

        """
        if not self.has_winner():
            self[move[0]][move[1]] = TicTacToe.SYMBOLS[self.turn]
            self.turn = not self.turn
            self.check_win()

    def make_random_move(self):
        """
        Randomly choose one of available moves and make it.

        """
        self.make_move(random.choice(self.next_moves_list()))

    def make_mcts_move(self, durration=0.5):
        """
        Find move using mcts algorithm, make it.

        Parameters
        ----------
        durration : float
            Time AI has to make a decision. The default is 0.5.
        """
        if not self.has_winner():
            move = mcts.mcts(self,durration)
            self.make_move(move)
            return move


    # Methods for checking win conditions

    def check_win(self):
        """
        Check, update and return win condtition.

        Returns
        -------
        bool or str
            Updated winner variable.

        """
        #Look for diagonal 3-in-a-row
        if((self[0][0]==self[1][1]==self[2][2]!=None) or
           (self[0][2]==self[1][1]==self[2][0]!=None)):
            self.winner = self[1][1]
            return self.winner

        for index in range(3):
            #Look for horizontal 3-in-a-row
            if self[index][0]==self[index][1]==self[index][2]!=None:
                self.winner = self[index][0]
                return self.winner

            #Look for vertical 3-in-a-row
            if self[0][index]==self[1][index]==self[2][index]!=None:
                self.winner = self[0][index]
                return self.winner

        #Look for a full board (i.e a draw)
        if self.winner is None:
            if all(self[0]) and all(self[1]) and all(self[2]):
                self.winner = 'tie'
                return self.winner

        #If Board doesn't meet win/draw conditions
        return None

    def has_winner(self):
        """
        Simple method to determine if self.winner is something other than None.

        Returns
        -------
        bool

        """
        return not self.winner is None


if __name__=="__main__":
    test_board = TicTacToe()
    print(test_board)
    # move=(int(input("row: ")),int(input("col:")))
    # test_board.make_move(move)
    while not test_board.has_winner():
        test_board.make_mcts_move(durration=.5)
        print(test_board)
        # move=(int(input("row: ")),int(input("col:")))
        # test_board.make_move(move)
        # print(test_board)
    print(test_board.winner)
