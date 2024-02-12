// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import './CommitReveal.sol';

contract RPS is CommitReveal{

    struct Player {
        uint choice;
        // 0,1,2,3...,5,6 => rock, fire, scissors, sponge, paper, air, water
        bytes32 hashedChoice;
    }

    uint public numPlayer = 0;
    uint public reward = 0;
    mapping (address => Player) public player;
    mapping (uint => address) private indexPlayer;
    
    uint public numInput = 0;
    uint public numReveal = 0;

    function addPlayer() public payable {
        require(numPlayer < 2);
        require(msg.value == 1 ether);
        reward += msg.value;
        indexPlayer[numPlayer] = msg.sender;
        numPlayer++;
    }

    function input(bytes32 hashedChoice) public  {
        require(numPlayer == 2);
        player[msg.sender].hashedChoice = hashedChoice;
        commit(hashedChoice);
        numInput++;
    }

    function hashInp(uint choice) external view returns(bytes32){
        return getHash(bytes32(choice));
    }

    function playerReveal(uint choice) public {
        require(numInput == 2);
        reveal(bytes32(choice));
        numReveal++;
        player[msg.sender].choice = choice;
        if (numReveal == 2)
        {
            _checkWinnerAndPay();
        }
    }

    function _checkWinnerAndPay() private {
        address p0addr = indexPlayer[0];
        address p1addr = indexPlayer[1];
        uint p0Choice = player[p0addr].choice;
        uint p1Choice = player[p1addr].choice;
        address payable account0 = payable(p0addr);
        address payable account1 = payable(p1addr);
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
    }
}
