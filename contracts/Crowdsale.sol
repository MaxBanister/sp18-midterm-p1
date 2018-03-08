pragma solidity ^0.4.15;

import './Queue.sol';
import './Token.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

contract Crowdsale {

	function Crowdsale(uint _initalTokens, uint _xrate, uint _timeLimit, uint _queueTime) public payable {
	    owner = msg.sender;
	    //totalSupply = _initalTokens;
	    xrate = _xrate;
	    startTime = now;
	    endTime = startTime + _timeLimit;
	    saleQueue = new Queue(_queueTime);
	    coinsSold = 0;
	    token = new Token(_initialTokens);
	    funds = 0;
	}

	/* Fallback function */
    function() public payable {
        revert();
    }

    /* State variables */
    address public owner;
    //uint public totalSupply;
    uint public coinsSold;
    uint public xrate;
    uint public startTime;
    uint public endTime;
    Queue public saleQueue;
    Token public token;
    uint private funds;

    /* Modifiers */
    modifier ownerOnly() {if (msg.sender == owner) _;}
    modifier saleOpen() {if (now > startTime && now < endTime) _;}

    /* Events */
    event TokenPurchase(address buyer);
    event TokenRefund(address buyer);

    function mintTokens(uint amount) ownerOnly() {
        token.mint(amount);
    }

    function burnTokens(uint amount) ownerOnly() returns (bool)  {
        return token.burn(amount);
    }

    function receiveFunds() ownerOnly() {
        if (now > endTime) {
            owner.transfer(funds);
        }
    }

    function buyTokens(uint amount) public payable saleOpen() {
        require(saleQueue.getFirst() == msg.sender && saleQueue.canBuy());
        if (amount <= msg.value * xrate && token.purchase(msg.sender, amount)) {

            coinsSold += amount;
            funds += msg.value;

            TokenPurchase(msg.sender);
            saleQueue.dequeue();
        }
        else {
            revert();
        }
    }

    function refundTokens(uint amount) public saleOpen() {
        if (token.refund(msg.sender, amount)) {

            coinsSold -= amount;
            msg.sender.transfer(amount * xrate);
            funds -= amount * xrate;

            TokenRefund(msg.sender);
        }
    }

    function joinQueue() public saleOpen() returns (bool){
        if (saleQueue.qsize() < 5) {
            saleQueue.enqueue(msg.sender);
            return true;
        }
        return false;
    }

    function checkTime() public saleOpen() {
        saleQueue.checkTime();
    }

    function checkPlace() public saleOpen() returns (uint) {
        return saleQueue.checkPlace();
    }


}
