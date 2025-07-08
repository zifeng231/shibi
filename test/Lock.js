const{ expcet } = require('chai');
const { ethers } = require('hardhat');

describe('ShibStyleTokenStep4', async function () {
   let ShibToken;
    let shibToken;
    let owner;
    let user1;
    let marketingWallet;
    let liquidityWallet;
  beforeEach(async function () {
    ShibToken = await ethers.getContractFactory('ShibStyleTokenStep4');
    shibToken = await shibi.deploy(
      'ShibStyleToken',
      'SST',
      100, // Initial supply of 1,000,000 tokens
      '0x70997970C51812dc3A010C7d01b50e0d17dc79C8' // Replace with actual liquidity address
    );
    await shibToken.deployed();
  })
})