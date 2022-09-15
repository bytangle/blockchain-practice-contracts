const Converter = artifacts.require("Converter");

module.exports = (deployer) => {
    deployer.deploy(Converter, 5);
}