pragma solidity ^0.4.18;

import '../node_modules/zeppelin-solidity/contracts/token/ERC20/CappedToken.sol';

contract CustomToken is CappedToken {
  uint8 public decimals = 18;
  string public name;
  string public symbol;
  
  function CustomToken(uint256 _cap, string _name, string _symbol) CappedToken( _cap) public {
      name = _name;
      symbol = _symbol;
  }


}