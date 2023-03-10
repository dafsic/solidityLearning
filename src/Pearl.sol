// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

//import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

error InsufficientBalance();

contract Pearl is IERC20 {
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowance;
    string private _name = "Pearl Token";
    string private _symbol = "PT";
    uint8 private _decimals = 18;

    function transfer(address to, uint256 amount) external returns (bool) {
        uint256 senderBalance = _balances[msg.sender];
        //require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        if (senderBalance < amount) {
            revert InsufficientBalance();
        }

        _balances[msg.sender] = senderBalance - amount;
        _balances[to] = _balances[to] + amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address to, uint256 amount) external returns (bool) {
        _allowance[msg.sender][to] = amount;
        emit Approval(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        uint256 allowBalance = _allowance[from][msg.sender];
        require(allowBalance >= amount, "ERC20: transferFrom amount exceeds balance 1");

        uint256 senderBalance = _balances[from];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance 2");

        _allowance[from][msg.sender] = allowBalance - amount;
        _balances[from] = senderBalance - amount;
        _balances[to] = _balances[to] + amount;

        emit Transfer(from, to, amount);
        return true;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowance[owner][spender];
    }

    function mint(uint256 amount) external {
        _balances[msg.sender] += amount;
        _totalSupply += amount;

        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint256 amount) external {
        _balances[msg.sender] -= amount;
        _totalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);
    }
}
