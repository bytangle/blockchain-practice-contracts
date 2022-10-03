const { ethers } = require("ethers");
const Eth = require("web3-eth")//.Eth;
const HttpProvider = require("web3-providers-http")//.HttpProvider;


class MicroPayment {
    constructor(httpProviderHttpAddr) {
        this.eth = new Eth(new HttpProvider(httpProviderHttpAddr));
    }

    constructMsg(contractAddr, amount) {
        return ethers.utils.defaultAbiCoder.encode(
            ["address", "uint256"],
            [contractAddr, amount]
        );
    }

    async signMsg(msg) {
        await this.#initAccts();

        return this.eth.personal.sign(msg, this.addrs[0]).catch(e => {
            throw new Error(e.message)
        });
    }

    async #initAccts() {
        if(!this.addrs) {
            this.addrs = await this.eth.getAccounts();
        }
    }
}

async function main() {
    const mp = new MicroPayment("http://127.0.0.1:7545");
    const msg = mp.constructMsg("0x950515b4E56069e8dDa9E3C23Df89911086B74f8", ethers.utils.parseEther("2"));
    mp.signMsg(msg).then(r => {
        console.log(r);
    })
}

main();