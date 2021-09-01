var Ontology = artifacts.require("./Ontology.sol");

module.exports = function(deployer) {
  deployer.deploy(Ontology);
};