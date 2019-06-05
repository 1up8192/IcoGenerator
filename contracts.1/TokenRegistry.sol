pragma solidity ^0.4.18;

import './TokenSale.sol';

contract TokenRegistry {

    address public owner;
    uint tokenCutPercent = 0;
    uint etherCutPercent = 0;
        
    struct TokenData {
        string name;
        string info;
        address tokenAddress;
        address saleAddress;
        uint timeAdded;
    }
    
    TokenData[] public tokens;
    
    event newTokenSale(uint number, address saleAddress, address tokenAddress);
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function TokenRegistry() public {
        owner = msg.sender;
    }
    
    function addToken(uint256 _rate, address _wallet, uint256 _cap, string _name, string _symbol, string _info, uint _saleStart, uint _saleEnd, uint _ownerTokenCutPercent) public onlyOwner {
        Crowdsale sale = new TokenSale(_rate, _wallet, _cap, _name, _symbol, owner, _saleStart, _saleEnd, _ownerTokenCutPercent, tokenCutPercent, etherCutPercent);
        tokens.push(TokenData({name: _name, info: _info, tokenAddress:sale.token(), saleAddress:address(sale), timeAdded:now}));
        newTokenSale(tokens.length - 1, address(sale), sale.token());
    }
    
    function getToken(uint number) public view returns (string name, string info, address tokenAddress, address saleAddress, uint timeAdded) {
        TokenData token = tokens[number];
        return (token.name, token.info, token.tokenAddress, token.saleAddress, token.timeAdded);
    }

    function modifyCuts(uint newTokenCutPercent, uint newEtherCutPercent) public onlyOwner{
        require(newTokenCutPercent <=10 && newEtherCutPercent <=10);
            uint tokenCutPercent = newTokenCutPercent;
            uint etherCutPercent = newEtherCutPercent;
    }

}