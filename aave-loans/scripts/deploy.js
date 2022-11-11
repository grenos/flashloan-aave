// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

const PoolAddressesProvider_Avalanche_Fuji =
    "0x1775ECC8362dB6CaB0c7A9C0957cF656A5276c29";

const PoolAddressesProvider_Aave = "0xc4dCB5126a3AfEd129BC3668Ea19285A9f56D15D";

async function main() {
    const FlashLoan = await hre.ethers.getContractFactory("FlashLoan");
    const flashLoan = await FlashLoan.deploy(PoolAddressesProvider_Aave);
    await flashLoan.deployed();
    console.log(`Flashloan deployed to ${flashLoan.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
