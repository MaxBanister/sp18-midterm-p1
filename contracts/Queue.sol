pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
	/* State variables */
	address[] queue;
	uint8 size = 5;
	uint8 pointer;
  uint public limit;
  uint first;

	/* Add events */
  event Ejected(address);

	/* Add constructor */
  function Queue(uint timeLimit) public {
  	queue = new address[](size);
    pointer = 0;
    limit = timeLimit;
  }

	/* Returns the number of people waiting in line */
	function qsize() constant returns(uint8) {
		return pointer;
	}

	/* Returns whether the queue is empty or not */
	function empty() constant returns(bool) {
		return pointer == 0;
	}

	/* Returns the address of the person in the front of the queue */
	function getFirst() constant returns(address) {
		return queue[0];
	}

	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace() constant returns(uint8) {
		for (uint8 i = 0; i < pointer; i++) {
      if (msg.sender == queue[i]) {
        return i + 1;
      }
    }
	}

	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() {
		if (now >= first + limit * 1 minutes) {
      Ejected(queue[0]);
      dequeue();
    }
	}

	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue() {
    for (uint8 i = 0; i < pointer-1; i++) {
      queue[i] = queue[i+1];
    }
    queue[pointer-1] = 0;
    pointer--;
    first = now;
	}

	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr) {
		if (empty()) {
      first = now;
    }
    if (pointer < 5) {
      queue[pointer] = addr;
      pointer ++;
    }
	}
}
