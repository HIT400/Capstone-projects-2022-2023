const HelloBlockchain = artifacts.require("IdentityManagement");

module.exports = function (deployer) {
  deployer.deploy(HelloBlockchain);
};