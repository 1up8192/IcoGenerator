pragma solidity ^0.4.13;

import './CustomToken.sol';
import './Crowdsale.sol';


contract TokenSale is Crowdsale {

  address serviceCreator;

  function TokenSale(uint256 _rate, address _wallet, uint256 _cap, string _name, string _symbol, address _serviceCreator, uint _saleStart, uint _saleEnd) Crowdsale(_saleStart, _saleEnd, _rate, _wallet, new CustomToken(_cap,  _name,  _symbol)) public {
  serviceCreator = _serviceCreator;
  }

    function forwardFunds() internal {
        uint serviceCreatorCut = msg.value / 100 * 5;
        wallet.transfer(msg.value - serviceCreatorCut);
        serviceCreator.transfer(serviceCreatorCut);
    }

}