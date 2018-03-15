'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require("./Crowdsale.sol");
const Queue = artifacts.require("./Queue.sol");
const Token = artifacts.require("./Token.sol");
// YOUR CODE HERE

contract('testTemplate', function(accounts) {
	/* Define your constant variables and instantiate constantly changing
	 * ones
	 */
	const args = {};
	let crowdsale, queue, token, owner;

	/* Do something before every `describe` method */
	beforeEach(async function() {
		owner = accounts[0];
		//crowdsale = await Crowdsale.new(100, 1, 20, 2);
	});

	/* Group test cases together
	 * Make sure to provide descriptive strings for method arguements and
	 * assert statements
	 */
	describe('~ Crowdsale Works ~', function() {
		it("Intial tokens is set properly", async function() {
			//assert(crowdsale.token.totalSupply() == 100);
		});

		it("Owner can mint and burn tokens", async function() {

		});

		it("Buyer can join the queue", async function() {

		});

		it("Buyer can make purchase if other people in queue", async function() {

		});

		it("Can't buy after sale closes", async function() {

		});
	});
});
