var TokenRegistry = artifacts.require("./TokenRegistry.sol");

module.exports = function(deployer) {
  deployer.deploy(TokenRegistry, {gasLimit: 3200000});
};
