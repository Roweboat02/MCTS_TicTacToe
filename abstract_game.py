# -*- coding: utf-8 -*-
"""
Created on Tue Aug 17 20:12:15 2021

@author: noahr
"""


from abc import ABC, abstractmethod

class AbstractGame(ABC):

    # SYMBOLS = np.array([])
    # SYMBOLS : Should include all differentiations between players.
    #     Is never used stricly as a class attribute, but must be constant.

    # WHITE = 0
    # BLACK = 1


    # Magic Methods

    # def __init__(self, values=None, current_move=True):
    #     if not values:
    #         #if values not provided, init to default
    #         self.board = np.array([])
    #     else:
    #         self.board = values

    #     self.turn = current_move
    #     #'tie' is draw, None means undecided, otherwise winner is 'X' or 'O'
    #     self.winner = None
    #     self.check_win()

    @abstractmethod
    def __getitem__(self, pos):
        pass
    @abstractmethod
    def __str__(self):
        pass
    @abstractmethod
    def __repr__(self):
        pass


    # Instance modtification methods
    @abstractmethod
    def reset(self): pass

    @abstractmethod
    def copy(self): pass
    # copy()
    #     Returns an identical, entirely independant copy of the game in it's current state.


    # Movement methods
    @abstractmethod
    def next_moves(self): pass

    @abstractmethod
    def next_moves_list(self): pass
     # next_moves_list()
     #        Returns a list or array of all reachable states immediately after the current game state.

    @abstractmethod
    def make_move(self, move): pass
    # make_move(move)
    # Change from current game state to state described with move param.

    @abstractmethod
    def make_random_move(self): pass
    # make_random_move()
    #     Change from current game state to an immediately reachable randomly selected state.

    @abstractmethod
    def make_mcts_move(self, durration=0.5): pass


    # Methods for checking win conditions
    @abstractmethod
    def check_win(self): pass

    @abstractmethod
    def has_winner(self): pass
