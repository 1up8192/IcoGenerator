// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";

// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
import tokenregistry_artifacts from '../../build/contracts/TokenRegistry.json'
import customtoken_artifacts from '../../build/contracts/CustomToken.json'
import tokensale_artifacts from '../../build/contracts/TokenSale.json'

// MetaCoin is our usable abstraction, which we'll use through the code below.
var TokenRegistry = contract(tokenregistry_artifacts);

// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
var accounts;
var account;

var self;

function getTokenData(number){
  var name;
  var smybol;
  var tokenAddress;
  var saleAddress;
  var sharePrice;
  var ethRaised;
  var totalShares;
  var instance;
  var tokenInstance;
  var saleInstance;
  var networkID;
  return TokenRegistry.deployed().then(function(_instance){
    instance = _instance;
    console.log("getting instance");
    console.log("number");
    console.log(number);
    console.log(typeof number); 
    return instance.getToken.call(number, {from: account});
  }).then(function(tokenData){
    console.log("tokenData");
    console.log(tokenData);
    console.log(typeof tokenData); 
    name = tokenData[0];
    console.log("name");
    console.log(name);
    console.log(typeof name);
    tokenAddress = tokenData[2];
    console.log("tokenAddress");
    console.log(tokenAddress);
    console.log(typeof tokenAddress);    
    saleAddress = tokenData[3];
    console.log("saleAddress");
    console.log(saleAddress);
    console.log(typeof saleAddress); 
    //return new Web3.eth.Contract(customtoken_artifacts, tokenAddress);
    var TokenContract = contract(customtoken_artifacts);
    console.log("contract");
    TokenContract.setProvider(web3.currentProvider);
    console.log("provider");
    return TokenContract.at(tokenAddress);
  }).then(function(_instance){
    console.log("instance");
    tokenInstance = _instance;
    console.log(tokenInstance);
    return tokenInstance.symbol.call(/*{from: account}*/);
  }).then(function(_symbol){
    smybol = _symbol;
    console.log("smybol");
    console.log(smybol);
    console.log(typeof smybol);
    return tokenInstance.totalSupply.call({from: account});
  }).then(function(cap){
    totalShares = cap;
    console.log("totalShares");
    console.log(totalShares);
    console.log(typeof totalShares);
    //return new web3.eth.Contract(diamonsale_artifacts, saleAddress);
    var SaleContract = contract(tokensale_artifacts);
    SaleContract.setProvider(web3.currentProvider);
    return SaleContract.at(saleAddress);
  }).then(function(_instance){
    saleInstance = _instance;
    return saleInstance.rate.call({from: account});
  }).then(function(rate){
    sharePrice = web3.fromWei(rate, "ether").toNumber();
    console.log("sharePrice");
    console.log(sharePrice);
    console.log(typeof sharePrice);
    return saleInstance.weiRaised.call({from: account});
  }).then(function(wei){
    ethRaised = web3.fromWei(wei, "ether").toNumber();
    console.log("ethRaised");
    console.log(ethRaised);
    console.log(typeof ethRaised);
    var result = {
      name: name,
      smybol: smybol,
      tokenAddress: tokenAddress,
      saleAddress: saleAddress,
      sharePrice: sharePrice,
      ethRaised: ethRaised,
      totalShares: totalShares
    };
    console.log("queried token");
    console.log(result);
    return result;
  }).catch(function(e) {
    console.log(e);
    self.setStatus("Error; see log.");
  });
}


window.App = {
  start: function() {
    self = this;

    // Bootstrap the MetaCoin abstraction for Use.
    TokenRegistry.setProvider(web3.currentProvider);

    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("There was an error fetching your accounts.");
        return;
      }

      if (accs.length == 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
        return;
      }

      accounts = accs;
      account = accounts[0];

      self.refresh();
    });
  },

  setStatus: function(message) {
    $("#status").html(message);
  },

  refresh: function() {
    self = this;

    
  },

  deployToken: function(){
    var rate = parseInt(web3.toWei($("#priceOfShares").val(), "ether"));
    var cap = $("#numberOfShares").val();
    var name = $("#tokenName").val();
    var smybol = $("#customTokenSymbol").val();
    var data = $("#tokenData").val();
    var instance;
    TokenRegistry.deployed().then(function(_instance){
      instance = _instance;
      return instance.addToken(rate, account, cap, name, smybol, data, {from: account, gas: 2500000});
    }).then(function(result) {
      console.log("success");
      console.log(result);
      self.setStatus("Transaction complete!");
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error; see log.");
    });
  },

  showTokenData: function(){
    console.log("starttttt")
    var tokenNumber = $("#tokenNumber").val();
    return getTokenData(tokenNumber).then(function(result){
      $("#getTokenName").html(result.name);
      $("#getCustomTokenSymbol").html(result.symbol);
      $("#getCustomTokenAddress").html(result.tokenAddress);
      $("#getTokenSaleAddress").html(result.saleAddress);
      $("#getTokenSharePrice").html(result.sharePrice + " ETH");
      $("#getTokenEtherRaised").html(result.ethRaised + " ETH");
      $("#getTokenTotalShares").html(result.totalShares);
      $("#getTokenSharesSold").html(result.ethRaised / result.sharePrice);
      $("#getTokenResults").show();
    });
  }
};

window.addEventListener('load', function() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 MetaCoin, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider);
  } else {
    console.warn("No web3 detected. Falling back to http://127.0.0.1:8545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));
  }

  App.start();
});
