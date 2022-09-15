
const Eth = require("web3-eth").Eth;
const Web3Utils = require("web3-utils");
const HttpProvider = require("web3-providers-http")//.HttpProvider;

const Converter = require("../build/contracts/Converter.json");
const ConverterAddr = "0x09D979069518dc8394bFf1F53e410FEb67Db3c17";
// error data: 0x5cee6be12d13d4796162c7adffb70c43df64d59df52f81dab11906d9a7c25c72
async function main() {
    const eth = new Eth(new HttpProvider("http://127.0.0.1:7545"));

    const accounts = await eth.getAccounts();

    console.log(accounts);

    // contract
    const C = new eth.Contract(Converter.abi, ConverterAddr, {
        from: accounts[0],
        gas: 5000000,
        gasPrice: '10000000000000'
    });

    C.once("Smile", {
        filter: {firstIndexedParam : ['me', 'you'], secondIndexedParam : [5,2]}
    }, (err, event) => {
        console.log(event);
    });

    C.events.JoshEvent({
        filter: {indexedParam: [3,4,5,6]}
    }).on("connected", (subId) => console.log(subId))
    .on("data", (data) => console.log(data))
    

    const action1 = C.methods['0xa2ca1b24']("Joshua is a programmer");
    const action2 = C.methods['0xc6888fa1'](5);

    //action2.send().then(receipt => console.log("Receipt: ", receipt));
    console.log("5 IN WEI IS: ", Web3Utils.toWei("2"));
    action2.estimateGas({
        from: accounts[1],
    }).then(gasAmt => console.log(gasAmt)).catch(e => console.error(e))

    const methodAbi = action2.encodeABI();
    console.log(methodAbi);

    action2.createAccessList().then(accessList => console.log(accessList));

    // action2.call({
    //     from: accounts[2]
    // }).then(result => {
    //     console.log(result);
    // })

}

main();

async function convertBytesToString(Contract, whatToConvert) {
    const result = await Contract.methods.getStringFromBytes(whatToConvert).call();
    return result;
}

async function convertStringToBytes(Contract, whatToConvert) {
    const result = await Contract.methods.getBytesFromString(whatToConvert).call();
    return result;
}