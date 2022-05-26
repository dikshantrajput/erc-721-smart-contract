const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DKTokenNft", function () {
  it("Should return the total supply equal to 100", async function () {
    const DKTokenNft = await ethers.getContractFactory("DKTokenNft");
    const dKTokenNft = await DKTokenNft.deploy();
    await dKTokenNft.deployed();

    expect(await dKTokenNft.totalSupply()).to.equal(100);

  });

  it("Should mint one nft in users account", async function () {
    const DKTokenNft = await ethers.getContractFactory("DKTokenNft");
    const dKTokenNft = await DKTokenNft.deploy();
    await dKTokenNft.deployed();

    let [owner,addr1] = await ethers.getSigners();

    let tx = await dKTokenNft.connect(owner).generateToken("dk",21,50,addr1.address,"uri");
    await tx.wait();

    expect(await dKTokenNft.ownerOf(1)).to.equal(addr1.address);

    let token = await dKTokenNft.getToken(1);

    expect(token.name).to.equal("dk");
    expect(token.age).to.equal(21);
    expect(token.weight).to.equal(50);

    expect(await dKTokenNft.getImageURI(1)).to.equal("uri");
  });

});
