// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import './CommitReveal.sol';

contract RPS is CommitReveal{

    struct Player {
        bool isRevealed;
        uint choice;
        address addr;
        // 0,1,2,3...,5,6 => rock, fire, scissors, sponge, paper, air, water
        bytes32 hashedChoice;
    }

    uint public numPlayer = 0;
    uint public reward = 0;
    mapping (address => Player) public player;
    mapping (uint => address) private indexPlayer;
    
    uint public numInput = 0;
    uint public numReveal = 0;
    uint public time = 0;

    function addPlayer() public payable {
        require(numPlayer < 2);
        require(msg.value == 1 ether);
        if (time == 0)
        {
            time = block.timestamp;
        }
        reward += msg.value;
        indexPlayer[numPlayer] = msg.sender;
        player[msg.sender].addr = msg.sender;
        numPlayer++;
    }

    function input(bytes32 hashedChoice) public  {
        require(numPlayer == 2);
        if (numInput == 0)
        {
            time = block.timestamp;
        }
        player[msg.sender].hashedChoice = hashedChoice;
        commit(hashedChoice);
        numInput++;
    }

    function hashInp(uint choice,uint salt) external view returns(bytes32){
        return getSaltedHash(bytes32(choice), bytes32(salt));
    }

    function playerReveal(uint choice) public {
        require(numInput == 2);
        if (numReveal == 0)
        {
            time = block.timestamp;
        }
        reveal(bytes32(choice));
        numReveal++;
        player[msg.sender].choice = choice;
        player[msg.sender].isRevealed = true;
        if (numReveal == 2)
        {
            _checkWinnerAndPay();
        }
    }

    function cancelTransaction() public {
        require(block.timestamp > time + 1 days, "You can't cancel the transaction now because it's not 1 day after the transaction");
        if (numPlayer == 0)
        {
            return;
        }
        else if (numPlayer == 1)
        {
            address payable account = payable(player[msg.sender].addr);
            account.transfer(reward);
        }
        else if (numPlayer == 2)
        {
            address payable account0 = payable(indexPlayer[0]);
            address payable account1 = payable(indexPlayer[1]);
            if (numReveal == 0)
            {
                account0.transfer(reward / 2);
                account1.transfer(reward / 2);
            }
            else if (numReveal == 1)
            {
                if (player[account0].isRevealed)
                {
                    account0.transfer(reward);
                }
                if (player[account1].isRevealed)
                {
                    account1.transfer(reward);
                }
            }
        }
        reward = 0;
        numPlayer = 0;
        numInput = 0;
        numReveal = 0;
        time = 0;
    }

    function _checkWinnerAndPay() private {
        address p0addr = indexPlayer[0];
        address p1addr = indexPlayer[1];
        uint p0Choice = player[p0addr].choice;
        uint p1Choice = player[p1addr].choice;
        address payable account0 = payable(p0addr);
        address payable account1 = payable(p1addr);
        // 0,1,2,3...,5,6 => rock, fire, scissors, sponge, paper, air, water (i already did the 4 problem in first commit in line 117 and 121)
        if ((p0Choice + 1) % 7 == p1Choice || (p0Choice + 2) % 7 == p1Choice || (p0Choice + 3) % 7 == p1Choice) {
            // to pay player[0]
            account0.transfer(reward);
        }
        else if ((p1Choice + 1) % 7 == p0Choice || (p1Choice + 2) % 7 == p0Choice || (p1Choice + 3) % 7 == p0Choice) {
            // to pay player[1]
            account1.transfer(reward);    
        }
        else {
            // to split reward
            account0.transfer(reward / 2);
            account1.transfer(reward / 2);
        }

        reward = 0;
        numPlayer = 0;
        numInput = 0;
        numReveal = 0;
        time = 0;
    }
}
