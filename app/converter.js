
const Eth = require("web3-eth")//.Eth;
const HttpProvider = require("web3-providers-http")//.HttpProvider;

const Converter = require("../build/contracts/Converter.json");
const ConverterAddr = "0x3f512e2Abb3903f487290097815B9Ee36BD7d2F1";
// error data: 0x5cee6be12d13d4796162c7adffb70c43df64d59df52f81dab11906d9a7c25c72
async function main() {
    const eth = new Eth(new HttpProvider("http://127.0.0.1:7545"));

    const accounts = await eth.getAccounts();

    console.log(accounts);

    // contract
    const C = new eth.Contract(Converter.abi, ConverterAddr);

    console.log(C.options.address);

    console.log(await convertBytesToString(C, "0x82a763"));
    //console.log(await convertStringToBytes(C, "My name is Joshua"));

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