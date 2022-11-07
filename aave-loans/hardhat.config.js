require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: "0.8.10",
    networks: {
        avalanche_main: {
            url: process.env.AVALANCHE_MAIN_URL,
            accounts: {
                mnemonic: process.env.MNEMONIC,
                path: "m/44'/60'/0'/0",
                initialIndex: 0,
                count: 1,
                passphrase: "",
            },
        },
        avalanche_test: {
            url: process.env.AVALANCHE_TEST_URL,
            accounts: {
                mnemonic: process.env.MNEMONIC,
                path: "m/44'/60'/0'/0",
                initialIndex: 0,
                count: 1,
                passphrase: "",
            },
        },
        goerli: {
            url: process.env.GOERLI_URL,
            accounts: {
                mnemonic: process.env.MNEMONIC,
                path: "m/44'/60'/0'/0",
                initialIndex: 0,
                count: 1,
                passphrase: "",
            },
        },
    },
};
