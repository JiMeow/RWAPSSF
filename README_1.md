# Rock, Water, Air, Paper, Sponge, Scissors, and Fire with Commit-Reveal

This smart contract implements a version of Rock, Water, Air, Paper, Sponge, Scissors, and Fire (RWAPSSF) game on the Ethereum blockchain using the commit-reveal scheme to mitigate front-running and other security issues.

## Problem 1 - Front-running problem

### Solution:
- Implement commit-reveal scheme:
    1. Players use the `commitChoice` function to commit their choice by providing a hashed value of their choice and a salt.
    2. The contract records the commitment.
    3. After both players have committed, they can reveal their choices using the `revealChoice` function.
    4. When both players have revealed their choices, the contract checks the winner and pays accordingly.

## Problem 2 - Money Locking

### Solution:
- Implement a timeout mechanism:
    1. Record the timestamp when the first player joins to prevent indefinite locking of funds.
    2. After a specified time (e.g., 1 day), if both players have not revealed their choices, call a function to handle timeouts.
    3. Handle timeouts by returning funds and penalizing non-revealing players.
        - condition is:
       1. return funds if only player is playing
       2. only 1 person committed, return both player
       3. only 1 person revealed, return pool prize to person that revealed

## Problem 3 - Rock, Paper, Scissors => Rock, Water, Air, Paper, Sponge, Scissors, and Fire

### Solution:
1. Add additional choices (0-6) where 7 represents undefined.
2. Modify the `checkWinnerAndPay` function to handle the new choices by comparing them modulo 7.

## Example Scenarios

## 1.) Win/Loss
- Start
  - ![image](https://github.com/Npwskp/RWAPSSF/assets/86043260/45856f3f-32e0-4e9b-9af6-bce2715642ec)
- Add 2 players
  - ![image](https://github.com/Npwskp/RWAPSSF/assets/86043260/d7ab5d88-0c42-4593-8aca-7411f9c8b422)
- Input
  - Player 1
    - ![image](https://github.com/Npwskp/RWAPSSF/assets/86043260/9b4ac8ae-b085-4383-bbae-0b4dfb6ba511)
    - ![image](https://github.com/Npwskp/RWAPSSF/assets/86043260/86a6e7fe-cf62-4121-bed0-2e01a7d3421e)
  - Player 2
    - ![image](https://github.com/Npwskp/RWAPSSF/assets/86043260/6ead2b95-ead0-40bf-b4a0-7ced859cdf90)
    - ![image](https://github.com/Npwskp/RWAPSSF/assets/86043260/8a0f60f4-50e0-4f03-bcd3-65809ac779aa)
- Reveal
  - ![image](https://github.com/Npwskp/RWAPSSF/assets/86043260/7a411d42-7ffe-4214-8058-160c2115964f)
  - ![image](https://github.com/Npwskp/RWAPSSF/assets/86043260/ddc22162-2e96-449d-ae45-17cb411c16b5)
- After
  - ![image](https://github.com/Npwskp/RWAPSSF/assets/86043260/34971c2e-9033-4a9e-bbe7-3f3894828440)

## 2.) Draw
- Start
  - ![image](https://github.com/Npwskp/RWAPSSF/assets/86043260/f0826cd8-ae08-4ab5-93df-1f8d686a1987)
- Add 2 players
  - ![image](https://github.com/Npwskp/RWAPSSF/assets/86043260/81330d0e-cc4e-4de1-90c4-9da713538d6b)
- Input
  - Player 1
    - ![image](https://github.com/Npwskp/RWAPSSF/assets/86043260/e7af2906-b0fa-4f6a-8930-1a5b6db927b8)
    - ![image](https://github.com/Npwskp/RWAPSSF/assets/86043260/f6fec110-5b31-4f8f-b996-c0a616865b69)
  - Player 2
    - ![image](https://github.com/Npwskp/RWAPSSF/assets/86043260/a8873318-b035-4acb-81d6-894f61937220)
    - ![image](https://github.com/Npwskp/RWAPSSF/assets/86043260/3ffb78c0-f869-4d7d-949f-e37ee3d7d08e)
- Reveal
  - ![image](https://github.com/Npwskp/RWAPSSF/assets/86043260/e155de6e-381e-491a-85c7-300461a6bfef)
  - ![image](https://github.com/Npwskp/RWAPSSF/assets/86043260/cce4243a-2006-4983-b5b7-1cf1d3e64e51)
- After
  - ![image](https://github.com/Npwskp/RWAPSSF/assets/86043260/5ce9303c-4def-4c27-a0d5-b4c067de90cd)


