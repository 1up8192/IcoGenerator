pragma solidity ^0.4.24;

import "../node_modules/openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "./TestToken.sol";

contract TestSale is MintedCrowdsale {

	constructor
	(
		uint256 _rate,
	  address _wallet
	)
	public
	Crowdsale(_rate, _wallet, new TestToken())
	{}
  
}