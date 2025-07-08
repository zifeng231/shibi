# 准备工作
## 环境搭建
- 安装 VSCode + Solidity 插件
- 安装 Hardhat
```javascript
    npm init -y && npm install --save-dev hardhat
```
- 新建项目目录shibi，使用vscode打开目录，命令行执行命令初始化一个hardhat项目
 ```javascript
    npx hardhat init
```
- 安装 OpenZeppelin 库（安全的合约基础）
```javascript
   npm install @openzeppelin/contracts
```
# 开发步骤
## 步骤1：实现基础 ERC20 代币功能
先搭建最基础的 ERC20 代币框架，确保代币的发行、转账等核心功能可用。
```javascript
   contracts\step1\ShibStyleTokenStep1
```
## 步骤2：添加代币税机制
在基础代币上增加交易税功能，对每笔交易抽税并分配到指定地址（如流动性池、营销钱包）。
```javascript
   contracts\step1\ShibStyleTokenStep2
```

## 步骤 3：添加交易限制功能
防止大额交易操纵市场，设置单笔最大额度和每日交易次数限制。
```javascript
   contracts\step1\ShibStyleTokenStep3
```

## 步骤 4：集成流动性池交互
支持用户向流动性池添加 / 移除流动性（与 DEX 的核心交互）。防止大额交易操纵市场，设置单笔最大额度和每日交易次数限制。
```javascript
   contracts\step1\ShibStyleTokenStep4
```