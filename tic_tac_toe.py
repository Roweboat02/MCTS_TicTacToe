# -*- coding: utf-8 -*-
"""
Created on Sun Aug 15 16:43:31 2021

@author: noahr
"""
import copy
import tree_search as mcts

def bits_to_str(bits):
    """
    Simple function for taking an interger and returning a string of it's bits.
    Will return a minimum of 9 bits, in little endian order (LSB first)
    """
    return format(bits, '09b')[::-1]

class TicTacToe:
    """
    A tic-tac-toe board class.
    """
    
    # A tuple with the symbols for this game. 
    # False (at index 0) is used to represent X, True O
    SYMBOLS = ('X', 'O')
    
    # All binary value for a winning chess board, saved to avoid recalculation.
    WINS = (0b111_000_000,
            0b000_111_000,
            0b000_000_111,
            0b001_001_001,
            0b010_010_010,
            0b100_100_100,
            0b100_010_001,
            0b001_010_100)

    def __init__(self):
        """
        Constructor for a tic-tac-toe game.
        """
        # First (0 or False) bitboard is X's, second (1, True) is O's
        self.board = [0, 0]

        self.turn = True # False if X's turn, true if O's

    def __str__(self):
        """ String representation of board. X is 'X', O is 'O' and empty is '.' """
        out = ''
        for count, (x,o) in enumerate(zip(bits_to_str(self.board[0]),
                                          bits_to_str(self.board[1]))):
            if count != 0 and count%3==0:
                out += '\n'
            if x==o=='0':
                out+='.'
            elif x=='1':
                out+='X'
            elif o=='1':
                out+='O'
        return out

    # Movement methods
    def possible_moves(self):
        """Generate a list of numbers of open squares."""
        _board = self.board[0] | self.board[1]
        return [n for n in range(9) if not (_board & 1<<n)]

    def make_move(self, square):
        """
        Places [self.turn]'s symbol at [square]
        
        NOTE: 
        Does not check if move is valid, potentially allowing for undefined behaviour.
        """
        self.board[self.turn] = self.board[self.turn] | 1<<square
        self.turn = not self.turn

    def make_random_move(self):
        """Chooses a random move from available, and places [self.turn]'s symbol there"""
        self.make_move(choice(self.possible_moves()))

    def make_move_using_mcts(self):
        """Find and make a move using the MCTS algorithm"""
        self.make_move(mcts.find_best_move(self))

    @property
    def winner(self):
        """
        Checks if there is a winner, or a draw.

        If game is done, returns the symbol of winner ('X' or 'O') or 'TIE'
        Returns None if game is not over.
        """
        if self._check_draw(self.board[0] | self.board[1]):
            return 'TIE'
        elif self._check_win(self.board[0]):
            return 'X'
        elif self._check_win(self.board[1]):
            return 'O'
        else:
            return None

    @classmethod
    def _check_draw(cls, bits):
        """Check if given interger [bits] is a full bitboard (0b111_111_111)"""
        return bits == 0b111_111_111

    @classmethod
    def _check_win(cls, bits):
        """Checks if [bits] has any of the patterns from possible win states"""
        for i in cls.WINS:
            if i == bits&i:
                return True
        else:
            return False

if __name__ == '__main__':
    a = TicTacToe()
    a.make_move_using_mcts()
    print(a)