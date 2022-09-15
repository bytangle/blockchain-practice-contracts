const Eth = require("web3-eth")//.Eth;
const Web3Utils = require("web3-utils");
const HttpProvider = require("web3-providers-http");
const FundRaising = require("../build/contracts/FundRaising.json");
const ServiceSubscription = require("../build/contracts/ServiceSubscription.json");
const { BigNumber } = require("ethers");

// Eth instance
const eth = new Eth(new HttpProvider("http://127.0.0.1:7545"));

const contractAddr = "0xd26C533dE9509814Bdec070ab274073d576ee802";

async function main() {
    // Fetch addresses
    let addresses = await eth.getAccounts();

    console.log(addresses);

    const FR = new eth.Contract(FundRaising.abi, contractAddr, {
        from: addresses[0],
        gas: 5000000,
        gasPrice: '20000000000000'
    });

    FR.deploy({
        data: ServiceSubscription.bytecode,
        arguments: [Web3Utils.toWei("5")]
    })//.estimateGas().then(r => console.log(r));
    .send({
        from: addresses[0],
        gas: 1500000,
        gasPrice: '2000000000000'
    }, (err, transactionHash) => {
        if(err) console.log("Send Error: ", err)
        else console.log("Trx Hash: ", transactionHash)
    })
   .on("error", (err) => console.log("Actual error: ", err))
    .on("transactionHash", (th) => console.log("Main Trx Hash: ", th))
    .on("receipt", (r) => console.log(r))
    .on("confirmation", (c, r, lb) => console.log(c,r,lb))
    .then(newContract => {
        console.log("New Contract Address: ", newContract.options.address);
    })


}

main();