// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./vault.sol";

contract Land {
    struct LandInfo {
        address owner;
        uint256 purchasePrice;
        bool isOwned;
    }

    mapping(uint256 => LandInfo) public landInfo;
    address public vaultAddress;

    event LandPurchased(uint256 indexed landId, address indexed buyer, uint256 purchasePrice);

    constructor(address _vaultAddress) {
        vaultAddress = _vaultAddress;
    }

    function purchaseLand(uint256 _landId, uint256 _purchasePrice) external {
        require(!landInfo[_landId].isOwned, "Land already owned");
        Vault(vaultAddress).withdraw(_purchasePrice);
        landInfo[_landId] = LandInfo({
            owner: msg.sender,
            purchasePrice: _purchasePrice,
            isOwned: true
        });
        emit LandPurchased(_landId, msg.sender, _purchasePrice);
    }
}
