const HelloBlockchain = artifacts.require("PractitionerContract");

module.exports = function (deployer) {
  deployer.deploy(HelloBlockchain);
};