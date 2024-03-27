// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./CommitReveal.sol";

contract RPS is CommitReveal {
    struct Player {
        bool isRevealed;
        uint choice1;
        uint choice2;
        address addr;
        // 0,1,2,3...,5,6 => rock, fire, scissors, sponge, paper, air, water
        bytes32 hashedChoice1;
        bytes32 hashedChoice2;
    }

    uint public numPlayer = 0;
    uint public reward = 0;
    mapping(address => Player) public player;
    mapping(uint => address) private indexPlayer;

    uint public numInput = 0;
    uint public numReveal = 0;
    uint public time = 0;

    function addPlayer() public payable {
        require(numPlayer < 2);
        require(msg.value == 1 ether);
        if (time == 0) {
            time = block.timestamp;
        }
        reward += msg.value;
        indexPlayer[numPlayer] = msg.sender;
        player[msg.sender].addr = msg.sender;
        numPlayer++;
    }

    function input(bytes32 hashedChoice1, bytes32 hashedChoice2) public {
        require(numPlayer == 2);
        if (numInput == 0) {
            time = block.timestamp;
        }
        player[msg.sender].hashedChoice1 = hashedChoice1;
        player[msg.sender].hashedChoice2 = hashedChoice2;

        bytes32 hashedChoices = keccak256(
            abi.encodePacked(hashedChoice1, hashedChoice2)
        );
        commit(hashedChoices);
        numInput++;
    }

    function hashInp(uint choice, uint salt) external view returns (bytes32) {
        return getSaltedHash(bytes32(choice), bytes32(salt));
    }

    function playerReveal(uint choice1, uint choice2, uint salt) public {
        require(numInput == 2);
        if (numReveal == 0) {
            time = block.timestamp;
        }

        bytes32 hashedChoice1 = getSaltedHash(bytes32(choice1), bytes32(salt));
        bytes32 hashedChoice2 = getSaltedHash(bytes32(choice2), bytes32(salt));
        revealAnswer(hashedChoice1, hashedChoice2);

        numReveal++;
        player[msg.sender].choice1 = choice1;
        player[msg.sender].choice2 = choice2;
        player[msg.sender].isRevealed = true;
        if (numReveal == 2) {
            _checkWinnerAndPay();
        }
    }

    function cancelTransaction() external {
        require(
            block.timestamp > time + 1 days,
            "You can't cancel the transaction now because it's not 1 day after the transaction"
        );
        if (numPlayer == 0) {
            return;
        } else if (numPlayer == 1) {
            address payable account = payable(player[msg.sender].addr);
            account.transfer(reward);
        } else if (numPlayer == 2) {
            address payable account0 = payable(indexPlayer[0]);
            address payable account1 = payable(indexPlayer[1]);
            if (numReveal == 0) {
                account0.transfer(reward / 2);
                account1.transfer(reward / 2);
            } else if (numReveal == 1) {
                if (player[account0].isRevealed) {
                    account0.transfer(reward);
                }
                if (player[account1].isRevealed) {
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
        uint pointP0_P1 = 0;
        address p0addr = indexPlayer[0];
        address p1addr = indexPlayer[1];
        uint p0Choice = player[p0addr].choice1;
        uint p1Choice = player[p1addr].choice1;
        address payable account0 = payable(p0addr);
        address payable account1 = payable(p1addr);
        // 0,1,2,3...,5,6 => rock, fire, scissors, sponge, paper, air, water (i already did the 4 problem in first commit in line 117 and 121)
        if (
            (p0Choice + 1) % 7 == p1Choice ||
            (p0Choice + 2) % 7 == p1Choice ||
            (p0Choice + 3) % 7 == p1Choice
        ) {
            // to pay player[0]
            pointP0_P1 += 2
        } else if (
            (p1Choice + 1) % 7 == p0Choice ||
            (p1Choice + 2) % 7 == p0Choice ||
            (p1Choice + 3) % 7 == p0Choice
        ) {
            // to pay player[1]
            pointP0_P1 -= 2
        } 
        
        p0Choice = player[p0addr].choice2;
        p1Choice = player[p1addr].choice2;

        if (
            (p0Choice + 1) % 7 == p1Choice ||
            (p0Choice + 2) % 7 == p1Choice ||
            (p0Choice + 3) % 7 == p1Choice
        ) {
            pointP0_P1 += 2
        } else if (
            (p1Choice + 1) % 7 == p0Choice ||
            (p1Choice + 2) % 7 == p0Choice ||
            (p1Choice + 3) % 7 == p0Choice
        ) {
            pointP0_P1 -= 2
        } 

        if (pointP0_P1 > 0) {
            account0.transfer(reward);
        } else if (pointP0_P1 < 0) {
            account1.transfer(reward);
        } else {
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
