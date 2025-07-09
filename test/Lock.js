const{ expect } = require('chai');
const { ethers } = require('hardhat');

describe('ShibStyleTokenStep4', async function () {
   let ShibToken;
    let shibToken;
    let owner;
    let user1;
    let marketingWallet;
    let liquidityWallet;
  beforeEach(async function () {
    [owner, user1, marketingWallet, liquidityWallet] = await ethers.getSigners();
    ShibToken = await ethers.getContractFactory('ShibStyleTokenStep4');
    shibToken = await ShibToken.deploy(
      'ShibStyleToken',
      'SST',
      1, // Initial supply of 1,000,000 tokens
      marketingWallet // 营销地址
    );
    await shibToken.waitForDeployment();
  })
  //测试设置流动性地址
  it('should set the liquidity address', async function () {
    await shibToken.setLiquidityAddress(liquidityWallet);
    console.log("测试设置流动性地址" + await shibToken.liquidityAddress());
    console.log("测试设置流动性地址" + liquidityWallet.address);
    
    expect(await shibToken.liquidityAddress()).to.equal(liquidityWallet);
  })
  //添加流动性
  it('should add liquidity', async function () {
    // 先设置流动性地址
    await shibToken.setLiquidityAddress(liquidityWallet);
    // 获取流动性地址
    const liquidityAddress = await shibToken.liquidityAddress();
    // 获取流动性地址的余额  注意这里是代币的余额 不是eth的余额
    let liquidityBalance = await shibToken.balanceOf(liquidityAddress);
    console.log("流动性地址:" + liquidityWallet.address + "代币余额:" + liquidityBalance);
    //获取我的代币余额
    const balance = await shibToken.balanceOf(owner);
    console.log("我的地址:" + owner.address + "代币余额:" + balance);
    //添加流动性并发送eth
    await shibToken.addLiquidity(500, {value: ethers.parseEther('500')});
    //获取流动性池的代币余额
    liquidityBalance = await shibToken.balanceOf(liquidityWallet);
    console.log("流动性池代币余额:" + liquidityWallet.address + "代币余额:" + liquidityBalance);
    //获取流动性池的eth余额
    const liquidityEthBalance = await ethers.provider.getBalance(liquidityWallet);
    console.log("流动性池" + liquidityWallet.address + "eth余额:" + ethers.formatEther(liquidityEthBalance));
    //获取我的eth余额
    const ownerEthBalance = await ethers.provider.getBalance(owner);
    console.log("我的地址" + owner.address + "eth余额:" + ethers.formatEther(ownerEthBalance));
    //获取我的代币余额
    const ownerTokenBalance = await shibToken.balanceOf(owner);
    console.log("我的地址" + owner.address + "代币余额:" + ownerTokenBalance);
    expect(await shibToken.liquidityAddress()).to.equal(liquidityWallet);
  })
  //测试转账
  it('should transfer tokens', async function () {
    //设置流动性地址
    await shibToken.setLiquidityAddress(liquidityWallet);
    //获取流动性地址
    const liquidityAddress = await shibToken.liquidityAddress();
    console.log("流动性地址:" + liquidityAddress);
    //获取流动性地址的余额
    const liquidityBalance = await shibToken.balanceOf(liquidityAddress);
    console.log("流动性地址" + liquidityAddress + "代币余额:" + liquidityBalance);
    //转账
    await shibToken.transfer(user1, 100);
    //获取用户1的代币余额
    const user1Balance = await shibToken.balanceOf(user1);
    console.log("用户1地址" + user1.address + "代币余额:" + user1Balance);
    //获取用户1的eth余额
    const user1EthBalance = await ethers.provider.getBalance(user1);
    console.log("用户1地址" + user1.address + "eth余额:" + ethers.formatEther(user1EthBalance));
    //获取流动性地址的余额
    const liquidityBalance1 = await shibToken.balanceOf(liquidityAddress);
    console.log("流动性地址" + liquidityAddress + "代币余额:" + liquidityBalance1);
    //获取流动性地址eth余额
    const liquidityEthBalance = await ethers.provider.getBalance(liquidityAddress);
    console.log("流动性地址" + liquidityAddress + "eth余额:" + ethers.formatEther(liquidityEthBalance));
    //获取我的代币余额
    const ownerBalance = await shibToken.balanceOf(owner);
    console.log("我的地址" + owner.address + "代币余额:" + ownerBalance);
    //获取我的eth余额
    const ownerEthBalance = await ethers.provider.getBalance(owner);
    console.log("我的地址" + owner.address + "eth余额:" + ethers.formatEther(ownerEthBalance));

    //获取营销地址余额
    const marketingBalance = await shibToken.balanceOf(marketingWallet);
    console.log("营销地址" + marketingWallet.address + "代币余额:" + marketingBalance);
    //获取营销地址eth余额
    const marketingEthBalance = await ethers.provider.getBalance(marketingWallet);
    console.log("营销地址" + marketingWallet.address + "eth余额:" + ethers.formatEther(marketingEthBalance));

  })
})