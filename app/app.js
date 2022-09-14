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


async function main() {
    const accts = await eth.getAccounts();

    console.log(accts);

    // connect to contract
    const contract = new eth.Contract(FundRaising.abi, contractAddr, {
        from: accts[0]
    });

    /// call beginFundRaising function
    const kall = await contract.methods["0x7fbc6622"](2).send().then(r => console.log(r));
    //const kall = await contract.methods.getDonationDetails().call();
    console.log(kall);
}

// run main
main();