https://roweboat02.github.io/MCTS_TicTacToe/

A Monte-Carlo Tree Search (MCTS), is a method of determing which action to take in a situation.
In games like chess, until recently, the primary method used for this was a game tree.
This worked by mapping out all possibilities to a certain depth, and taking the best option.
This approach's main flaw is that for games with many branching paths (i.e. chess),
the possible depth of the search is limited due to time and computational complexity.

An MCTS algorithm avoids these problems by using psuedo-random simulation.
In the case of this tic-tac-toe implementation, more random than normal.
In more complicated games, the algorithm works by 'randomly' filling out a tree of possiblilities,
the 'randomness' is guided by a function called a upper confidence bound (UCB).
Given enough simulations, we can aproximate a fully mapped out move tree.

The UCB tells the algorithm which moves are worth further exploration.
If making a move would mean instantly losing,
a player wouldn't make it and the UCB will only explore it enough to figure that out.

While the UCB is implemented, it's not being used.
Tic-tac-toe is such a simple game, the algorithm breaks down a bit.
It immediately avoids moves that make it immediately lose and then keeps running simulations.
Eventually it sees it could possibly win, if the other player just doesn't take the winning move.
In this case 'guided randomness' guides away from a definite tie or loss, in favor of a potential future win.

Purely random simulation is currently being used to run the MTCS, and it is more accurate.
However, this behavior of making seemingly illogical moves is still present and observable.
If given a situation where the opposing player has two wins set up
and the algorithm has to choose to block one or the other, sometimes, it'll choose neither.
If you want to personify the algoritm, you can say it knows it's lost and is giving up.

A UCB function for tic-tac-toe is possible, it just needs to be tuned for the game it's playing.
Factors needing to be tuned in the UCB:
- Using a diminishing number of simulations
- Adding 'proximity factors' which encourage focus on immediate end of game moves
- Tuning the UCB factors governing exploration vs. exploitation
- Adding a very slight reward for a draw

These would make the MCTS significantly more accurate than either of the other two disscussed options.
At the moment I have no plans on doing any of them.
An important skill in software engineering and particularly when doing machine learning,
is knowing what's "good enough".
With another week I could build a neural network to tune these parameters for me,
with a lot more weeks after that, I could have the best tic-tac-toe bot in the world.
I don't need the best tic-tac-toe bot in the world though, I need a tic-tac-toe bot.
I have to stop somewhere, and at the moment that's here.
