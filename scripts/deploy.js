// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const DKTokenNft = await hre.ethers.getContractFactory("DKTokenNft");
  const dKTokenNft = await DKTokenNft.deploy();

  await dKTokenNft.deployed();

  console.log("DKTokenNft deployed to:", dKTokenNft.address);

  let tx = await dKTokenNft.generateToken("dk",21,50,"0xC71207584348042e773C1AD780b3738f9C74b7c7","uri");

  let receipt = await tx.wait();
  console.log(receipt)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
