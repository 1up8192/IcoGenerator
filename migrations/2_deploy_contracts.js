var TestSale = artifacts.require("./TestSale.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(TestSale, 1, accounts[0]);
}
