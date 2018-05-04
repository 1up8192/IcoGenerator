pragma solidity ^0.4.18;

import './TokenSale.sol';

contract TokenRegistry {
    address public owner;
        
    struct TokenData {
        string name;
        string info;
        address tokenAddress;
        address saleAddress;
        uint timeAdded;
    }
    
    TokenData[] public tokens;
    
    event newTokenSale(uint number);
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function TokenRegistry() public {
        owner = msg.sender;
    }
    
    function addToken(uint256 _rate, address _wallet, uint256 _cap, string _name, string _symbol, string _info, uint _saleStart, uint _saleEnd) public onlyOwner {
        Crowdsale sale = new TokenSale(_rate, _wallet, _cap, _name, _symbol, owner, _saleStart, _saleEnd);
        tokens.push(TokenData({name: _name, info: _info, tokenAddress:address(sale.token), saleAddress:address(sale), timeAdded:now}));
        newTokenSale(tokens.length - 1);
    }
    
    function getToken(uint number) public view returns (string name, string info, address tokenAddress, address saleAddress, uint timeAdded) {
        TokenData token = tokens[number];
        return (token.name, token.info, token.tokenAddress, token.saleAddress, token.timeAdded);
    }

}