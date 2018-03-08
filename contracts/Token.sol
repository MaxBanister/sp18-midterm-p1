pragma solidity ^0.4.15;

import './interfaces/ERC20Interface.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {
	event Transfer(address indexed from, address index to, uint tokens);
	event Approval(address indexed tokenOwner, address index spender, uint tokens);

	uint totalSupply = 5000;
	address owner;
	mapping (address => uint) balances;
	mapping(address => mapping (address => uint256)) allowed;

	modifier onlyOwner {
		require(msg.sender == owner);
		_;
	}

	function Token(uint supply) {
		owner = msg.sender;
		totalSupply = supply;
	}
	function totalSupply() public constant returns (uint) {
		return totalSupply;
	}
	function balanceOf(address tokenOwner) public constant returns (uint balance) {
		return balances[tokenOwner];
	}
	function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
		return transferRights[tokenOwner][spender];
	}
	function transfer(address to, uint tokens) public returns (bool success) {
		if (balances[msg.sender] >= tokens) {
			balances[msg.sender] = balances[msg.sender] - tokens;
			balances[to] += tokens;
			Transfer(msg.sender, to, tokens);
			return true;
		}
		return false;
	}
	function approve(address spender, uint tokens) public returns (bool success) {
		allowed[msg.sender][spender] = tokens;
		Approval(msg.sender, spender, tokens);
		return true;
	}
	function transferFrom(address from, address to, uint tokens) public returns (bool success) {
		if (allowed[from][msg.sender] >= tokens) {
			allowed[from][msg.sender] = allowed[from][msg.sender] - tokens;
			transfer(to, tokens);
			return true;
		}
		return false;
	}
	function burn(uint tokens) public onlyOwner() returns (bool success) {
		if (balances[msg.sender] >= tokens) {
			balances[msg.sender] = balances[msg.sender] - tokens;
			require(balances[msg.sender] >= 0);
			totalSupply -= tokens;
			require(totalSupply >= 0);
			return true;
		}
		return false;
	}
	function mint(uint tokens) public onlyOwner() {
		totalSupply += tokens;
	}
	function assignBalance(address person, uint tokens) public onlyOwner() {
		balances[person] = balances[person] + tokens;
	}
	function() public payable {
		revert();
	}
}
