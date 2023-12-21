// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./vault.sol";

contract Tasks {
    enum TaskStatus { Incomplete, Completed }

    struct Task {
        uint256 taskId;
        string taskDescription;
        uint256 reward;
        TaskStatus status;
    }

    Task[] public tasks;
    address public vaultAddress;

    event TaskCompleted(uint256 indexed taskId, address indexed player, uint256 reward);

    constructor(address _vaultAddress) {
        vaultAddress = _vaultAddress;
    }

    function createTask(string memory _taskDescription, uint256 _reward) external {
        uint256 taskId = tasks.length;
        tasks.push(Task({
            taskId: taskId,
            taskDescription: _taskDescription,
            reward: _reward,
            status: TaskStatus.Incomplete
        }));
    }

    function completeTask(uint256 _taskId) external {
        require(_taskId < tasks.length, "Task does not exist");
        require(tasks[_taskId].status == TaskStatus.Incomplete, "Task already completed");

        // Your additional logic for completing the task and rewarding the player goes here

        tasks[_taskId].status = TaskStatus.Completed;
        Vault(vaultAddress).deposit(tasks[_taskId].reward);

        emit TaskCompleted(_taskId, msg.sender, tasks[_taskId].reward);
    }
}