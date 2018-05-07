pragma solidity ^0.4.13;

import './CustomToken.sol';
import './Crowdsale.sol';


contract TokenSale is Crowdsale {

  address serviceCreator;
  uint serviceCreatorEtherCutPercent;
  uint ownerTokenCutPercent;
  uint serviceCreatorTokenCutPercent;

  function TokenSale(uint256 _rate, address _wallet, uint256 _cap, string _name, string _symbol, address _serviceCreator, uint _saleStart, uint _saleEnd, uint _ownerTokenCutPercent, uint _serviceCreatorTokenCutPercent, uint _serviceCreatorEtherCutPercent) Crowdsale(_saleStart, _saleEnd, _rate, _wallet, new CustomToken(_cap,  _name,  _symbol)) public {
    require(_ownerTokenCutPercent <= 50);  
    serviceCreator = _serviceCreator;
    serviceCreatorEtherCutPercent = _serviceCreatorEtherCutPercent;
    ownerTokenCutPercent = _ownerTokenCutPercent;
    serviceCreatorTokenCutPercent = _serviceCreatorTokenCutPercent;
  }

    function forwardFunds() internal {
        uint serviceCreatorCut = msg.value / 100 * serviceCreatorEtherCutPercent;
        wallet.transfer(msg.value - serviceCreatorCut);
        serviceCreator.transfer(serviceCreatorCut);
    }

    function buyTokens(address beneficiary) public payable {
        require(beneficiary != address(0));
        require(validPurchase());

        uint256 weiAmount = msg.value;

        // calculate token amount to be created
        uint256 tokens = getTokenAmount(weiAmount);
        uint ownerTokens = tokens / 100 * ownerTokenCutPercent;
        uint serviceCreatorTokens = tokens / 100 * serviceCreatorTokenCutPercent;

        uint buyerTokens = tokens - ownerTokens - serviceCreatorTokens;

        // update state
        weiRaised = weiRaised.add(weiAmount);

        token.mint(beneficiary, buyerTokens);
        token.mint(wallet, ownerTokens);
        token.mint(serviceCreator, serviceCreatorTokens);

        TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

        forwardFunds();
  }

}