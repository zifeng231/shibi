pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// 引入Ownable用于权限管理（只有 owner 可调整税率）
import "@openzeppelin/contracts/access/Ownable.sol";

contract ShibStyleTokenStep2 is ERC20 , Ownable {
    // 定义税率（如5%）
    uint256 public taxRate = 5;//总交易税

    uint256 public liquidityTaxRate = 2; //流动性税

    uint256 public marketingTaxRate = 2; //市场营销税

    uint256 public developmentTaxRate = 1; //销毁的税（减少流通量）

    // 流动性池地址
    address public liquidityAddress;

    // 市场营销地址
    address public marketingAddress;

    // 事件：记录税费分配（方便前端追踪）
    event TaxDistributed(
        uint256 liquidityTax,
        uint256 marketingTax,
        uint256 developmentTax
    );

    // 构造函数：新增营销钱包参数
    constructor(
        string memory name,
        string memory symbol,
        uint256 totalSupply, // 总供应量（如1000万亿：1）
        address _marketingAddress // 营销钱包地址
    ) ERC20(name, symbol)  Ownable(msg.sender){//部署者为 owner
        require(_marketingAddress != address(0), "Invalid marketing address");
        marketingAddress = _marketingAddress;
        // 将总供应量转换为最小单位（如1个代币 = 10**18 wei）
        _mint(msg.sender, totalSupply * 10 ** decimals());
    }

    //仅owner可设置流动性地址
    function setLiquidityAddress(address _liquidityAddress) external onlyOwner {
        require(_liquidityAddress != address(0), "Invalid liquidity address");
        liquidityAddress = _liquidityAddress;
    }
    //仅owner可调整税率
    function updateTaxRates(
        uint256 _taxRate,
        uint256 _liquidityTaxRate,
        uint256 _marketingTaxRate,
        uint256 _developmentTaxRate
    ) external onlyOwner {
        require(_taxRate <= 100, "Total tax rate cannot exceed 100%");
        require(_liquidityTaxRate + _marketingTaxRate + _developmentTaxRate <= _taxRate, "Invalid tax distribution");
        
        taxRate = _taxRate;
        liquidityTaxRate = _liquidityTaxRate;
        marketingTaxRate = _marketingTaxRate;
        developmentTaxRate = _developmentTaxRate;
    }

    //重写 transfer 函数，添加税费逻辑
    //internal override
    function transfer(
        address sender,
        address recipient, 
        uint256 amount) internal  {
            // 计算税费 销毁的税
            uint256 taxAmount = (amount * developmentTaxRate) / 100;
            // 计算流动性税
            uint256 liquidityTax = (amount * liquidityTaxRate) / 100;
            // 计算市场营销税
            uint256 marketingTax = (amount * marketingTaxRate) / 100;
            // 计算实际转账金额
            uint256 transferAmount = amount - taxAmount - liquidityTax - marketingTax;
            // 确保转账金额不为负
            require(transferAmount >= 0, "Transfer amount must be greater than or equal to zero");
            // 调用父类的 _transfer 方法进行实际转账
            super._transfer(sender, recipient, transferAmount);
            //处理营销税
            if (marketingTax > 0) {
                super._transfer(sender, marketingAddress, marketingTax);
            }
            //处理流动性税
            if (liquidityTax > 0 && liquidityAddress != address(0)) {
                super._transfer(sender, liquidityAddress, liquidityTax);
            }
            //处理销毁的税
            if (taxAmount > 0) {
                _burn(sender, taxAmount); // 销毁税费
            }
            //触发事件
            emit TaxDistributed(liquidityTax, marketingTax, taxAmount);
    }
}
