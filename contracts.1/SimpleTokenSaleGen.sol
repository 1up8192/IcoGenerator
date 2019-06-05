pragma solidity ^0.4.18;

import './Crowdsale.sol';

contract SimpleTokenSaleGen {
        
    struct TokenData {
        string name;
        string info;
        address tokenAddress;
        address saleAddress;
        uint timeAdded;
    }
    
    TokenData[] public tokens;
    
    event newTokenSale(uint number, address saleAddress, address tokenAddress);
    
    function SimpleTokenSaleGen() public {
    }
    
    function addToken(uint256 _rate, address _wallet, uint256 _cap, string _name, string _symbol, string _info) public {
        CappedToken token = new CappedToken(_cap);
        Crowdsale sale = new Crowdsale(now, 2147483648, _rate, msg.sender, token);
        tokens.push(TokenData({name: _name, info: _info, tokenAddress:address(token), saleAddress:address(sale), timeAdded:now}));
        newTokenSale(tokens.length - 1, address(sale), sale.token());
    }
    
    function getToken(uint number) public view returns (string name, string info, address tokenAddress, address saleAddress, uint timeAdded) {
        TokenData token = tokens[number];
        return (token.name, token.info, token.tokenAddress, token.saleAddress, token.timeAdded);
    }

}