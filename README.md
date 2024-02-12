# Rock, Paper, Scissors (RPS) Game

## Problem 1: Clone RPS GitHub Repository

### Solution:
1. Clone the RPS repository from Ajarn's Paruj's GitHub account.
2. Clone the repository to your local machine.

## Problem 2: Manage Front-Running Attack by Commit-Reveal Contract

### Solution:
1. Create a new RPS contract with inheritance from the commit-reveal contract.
2. Modify the input function to store the hash of the input (hashed choice, not the choice itself).
3. Retrieve the hashed choice from the `hashInp` function (external view) that will call the `getSaltedHash` function from the commit-reveal contract.
4. Store the hashed choice in the mapping of the player's address and commit the hashed choice to the contract.
5. Players reveal their choices by calling the `reveal` function and providing their choice.
6. When two players have revealed their choices, the contract compares the hashed choice with the choice itself to determine the winner.
7. The winner receives the prize, and the game is reset.

## Problem 3: Cancel Transaction After 1 Day

### Solution:
1. Implement a new public `cancel` function to cancel the transaction after 1 day (requiring it to be after 1 day).
2. Track the time when the impactful transaction was created by the contract and compare it with the current time when the `cancel` function is called.
3. If the time exceeds 1 day, reset the contract and return the prize to each player (players may not receive the prize if they fail to complete the transaction within 1 day).
4. Manage reward split based on the game state and result.

## Problem 4: Expand to Have 7 Choices Instead of 3 (RWAPSSF Instead of RPS)

### Solution:
1. Make the game compatible with 7 choices by adjusting the `_checkWinnerAndPay` function.
2. Modify the winner logic condition to accommodate the expanded choice set, for example: `((p0Choice + 1) % 7 == p1Choice || (p0Choice + 2) % 7 == p1Choice || (p0Choice + 3) % 7 == p1Choice)` for player 0 win.
3. Completed!
