# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat init

npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js

//安装remixd
npm install -d @remix-project/remixd

//安装失败配置 GitHub SSH 密钥
//先尝试清理缓存
npm cache clean --force
npm install -g @remix-project/remixd
//生成 SSH 密钥
//输入以下命令生成密钥（替换为你的 GitHub 邮箱）：
ssh-keygen -t ed25519 -C "your_email@example.com"
//按提示连续按三次回车（不设置密码）
生成的密钥默认保存在：C:\Users\你的用户名\.ssh\id_ed25519.pub
//复制 SSH 公钥
cat ~/.ssh/id_ed25519.pub | clip
//或进入目录：C:\Users\你的用户名\.ssh\
//用记事本打开id_ed25519.pub文件
//复制文件中的全部内容
//添加 SSH 公钥到 GitHub登录 GitHub → 点击右上角头像 → Settings → SSH and GPG keys点击 New SSH key
//Title 填写：My Windows PC
//Key 区域粘贴刚才复制的内 点击 Add SSH key
//测试 SSH 连接
在 Git Bash 中执行：
//ssh -T git@github.com



//启动remixde
npx remixd




//合约升级
//使用安装
npm install -D hardhat-deploy
//运行
npx hardhat deploy
npx hardhat deploy 的作用是：
自动执行项目中 deploy 文件夹下的所有部署脚本（如 01_depoly_nft_auction.js）。
根据脚本内容，自动部署智能合约到指定的区块链网络（本地、测试网或主网）。
会记录合约部署信息（如地址、ABI 等）到 deployments 文件夹，方便前端或后续脚本读取。
简而言之：

//导入"@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
//npm install @openzeppelin/contracts-upgradeable 如果失败的话用管理员启动
//npm install @openzeppelin/hardhat-upgrades


//集成预言机比价
//https://docs.chain.link/data-feeds/price-feeds/addresses?page=1&testnetPage=1#sepolia-testnet


```
