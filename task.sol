// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./vault.sol";

contract Tasks {
    enum BattleStatus { Incomplete, Completed }

    struct Battle {
        uint256 battleId;
        string battleDescription;
        uint256 reward;
        BattleStatus status;
    }

    Battle[] public battles;
    address public vaultAddress;

    event BattleCompleted(uint256 indexed battleId, address indexed player, uint256 reward);

    constructor(address _vaultAddress) {
        vaultAddress = _vaultAddress;
    }

    function createBattle(string memory _battleDescription, uint256 _reward) external {
        uint256 battleId = battles.length;
        battles.push(Battle({
            battleId: battleId,
            battleDescription: _battleDescription,
            reward: _reward,
            status: BattleStatus.Incomplete
        }));
    }

    function EndBattle(uint256 _battleId) external payable{
        require(_battleId < battles.length, "Battle does not exist");
        require(battles[_battleId].status == BattleStatus.Incomplete, "You Won the Battle!");

        battles[_battleId].status = BattleStatus.Completed;
        Vault(vaultAddress).deposit(battles[_battleId].reward);

        emit BattleCompleted(_battleId, msg.sender, battles[_battleId].reward);
    }
}