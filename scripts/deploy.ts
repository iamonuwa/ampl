import { Contract, ContractFactory } from "ethers";
const hre = require("hardhat");

const { ethers } = hre;

const tokenName = "Wrapped AMPL";
const tokenSymbol = "sAMPL";
const amplAddress = "0x3E0437898a5667a4769B1Ca5A34aAB1ae7E81377";

async function main(): Promise<void> {
  // Hardhat always runs the compile task when running scripts through it.
  // If this runs in a standalone fashion you may want to call compile manually
  // to make sure everything is compiled
  // await run("compile");
  // We get the contract to deploy
  const SAMPL: ContractFactory = await ethers.getContractFactory("SAMPL");
  const sAMPL: Contract = await SAMPL.deploy(
    tokenName,
    tokenSymbol,
    amplAddress
  );

  // The contract is NOT deployed yet; we must wait until it is mined
  await sAMPL.deployed();
  console.log("sAMPL deployed to: ", sAMPL.address);

  console.log(`Finished deploying SAMPL Contract`);
  console.log("=======================================");

  await sAMPL.deployTransaction.wait(5);

  await hre.run("verify:verify", {
    address: sAMPL.address,
    constructorArguments: [tokenName, tokenSymbol, amplAddress],
  });
}

// Recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  });
