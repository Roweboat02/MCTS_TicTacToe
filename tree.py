from copy import deepcopy
from collections import deque
from math import log, sqrt

class Node:
    """
    Tree node containg a game state, connected nodes are immediately reachable
    game states.
    """
    def __init__(self, state, move=None):
        """
        Create a tree node.

        Given state is copied, so original is unaffected.
        Apply a move by using the named parameter, don't by not supplying a move.
        """
        self.game = deepcopy(state)
        self.move = move
        if move is not None:
            self.game.make_move(move)

        # Boolean value telling if a node has been populated with children pointers
        self.populated = False 

        # List of pointers to node's children. Is set to None until populated.
        self.children = None
        # Will be initialized to length of children during population.
        # Used to keep track of which children have been visited.
        self._unvisited_index = None

        #Node stats for UCB calculation
        self.visits = 0
        self.score = 0

    @property
    def winner(self):
        """Property which returns if self.game has a winner"""
        return self.game.winner

    @property
    def child(self):
        """
        Property which returns the child which should be used in a search
        
        If node has unvisited children, will decrement the index
        then return child at [self._unvisited_index].

        If all children have been visited, return child with highest UCB.
        """
        if self._unvisited_index > 0:
            self._unvisited_index-=1
            return self.children[self._unvisited_index]
        else:
            return self.ucb()

    def populate(self):
        """
        Create and fill children list with pointers to node's children.

        Children generated from node's state and possible moves.
        """
        self.populated = True
        self.children = [Node(self.game, move) for move in self.game.possible_moves()]
        self._unvisited_index = len(self.children)

    def ucb(self, c_const=1.41, _print=False):
        """
        Find child in children list with greatest upper confidence bound.

        UCB given by UCB(v,vi) = Q(vi) / N(vi) + c * [ln(N(v)) / N(vi)]^1/2
        Where....
        v is current node, vi is child,
        c is an exploitation constant,
        Q() gives score of a node,
        N() gives visits to a node,
        """
        ucb_values = [_child.score / _child.visits + c_const * sqrt( log(self.visits) / _child.visits) for _child in self.children]
        if _print:
            print(ucb_values)
        return self.children[ucb_values.index(max(ucb_values))]

    def update_score(self, outcome, proximity):
        """
        Used to backpropogate outcome up path.

        If outcome matches the turn, increase score else decrease.
        Change score by is 1 + (6 / proximity**2) if a win.

        (6 / proximity**2) is an arbitrary term to make immediate wins/losses
        more important to the search.
        (sometimes when the possible numbers of moves are low,
        algorithm ignores immediate losses for potential distant wins.)
        """
        self.visits += 1

        if outcome == 'TIE':
            return
        else:
            self.score += self._increase_or_decrease(outcome) * (1+(6/proximity**2))
            return

    def rollout(self, depth):
        """
        Make a copy of node's state and make random moves,
        do this until a terminal state is reached.
        
        [depth] is incremented for every iteration.
        This can be used for finding proximity to terminal node.
        """
        game = deepcopy(self.game)
        while game.winner is None:
            depth+=1
            game.make_random_move()

        return game.winner, depth

    def _increase_or_decrease(self, outcome):
        """Compare outcome to node state's turn. Return 1 if inc, -1 if dec."""
        return 1 if ('X','O')[self.game.turn] == outcome else -1