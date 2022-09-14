const FundRaising = artifacts.require("FundRaising");

module.exports = (deployer) => {
    deployer.deploy(FundRaising);
}