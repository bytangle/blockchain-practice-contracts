// import deps
const FundRaising = require("../build/contracts/FundRaising.json");
const Eth = require("web3-eth")//.Eth;
const HttpProvider = require("web3-providers-http");

// contract address
const contractAddr = "0xcb6Ad395426D2c24CFc77eAFB56dFA382e91413F";

// provider config
const httpConfig = {
    keepAlive: true,
    timeout: 2000
}

// connect to network
const eth = new Eth(new HttpProvider("http://127.0.0.1:7545", httpConfig));

// connect to contract
const contract = new eth.Contract(FundRaising.abi, contractAddr);


async function main() {
    const accts = await eth.getAccounts();

    eth.defaultAccount = accts[0];
    contract.defaultAccount = accts[0];

    console.log("Default account: ", eth.defaultAccount);
    console.log("Contract default account: ", contract.defaultAccount);

    /// call beginFundRaising function
    const kall = await contract.methods["0x7fbc6622"](2).call();
    //const kall = await contract.methods.getDonationDetails().call();
    console.log(kall);
}

// run main
main();