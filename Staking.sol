// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Staking {

    address _owner;
    mapping(bytes32 => address) public whitelistedTokens;
    mapping(address => mapping(bytes32 => uint256)) public accountBalances;

    constructor() {
        _owner = msg.sender;
    }

    function whitelistedToken(bytes32 symbol, address tokenAddress) external owner {
        whitelistedTokens[symbol] = tokenAddress;
    }

    function depositTokens(uint256 amount, bytes32 symbol) external {
        accountBalances[msg.sender][symbol] += amount;
        ERC20(whitelistedTokens[symbol]).transferFrom(msg.sender, address(this), amount);
    }

    function withdrawTokens(uint256 amount, bytes32 symbol) external {
        require(accountBalances[msg.sender][symbol] >= amount, 'Insufficient funds');

        accountBalances[msg.sender][symbol] -= amount;
        ERC20(whitelistedTokens[symbol]).transfer(msg.sender, amount);
    }

    modifier owner() {
        require(msg.sender == _owner, 'This function is not public');
        _;
    }
}