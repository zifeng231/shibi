pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// 引入Ownable用于权限管理（只有 owner 可调整税率）
import "@openzeppelin/contracts/access/Ownable.sol";

contract ShibStyleTokenStep3 is ERC20 , Ownable {

    //=====新增：交易限制变量=====
    uint256 public maxTransactionAmount; // 单笔最大交易金额
    uint256 public maxDailyTransactions = 10; // 每日最大交易次数

    //=====新增：交易限制相关映射=====
    mapping(address => uint256) public dailyTransactionCount; // 记录每日交易次数

    mapping(address => uint256) public lastTransactionTimestamp; // 记录地址的最后交易时间

    mapping(address => bool) public whiteListedAddress; // 白名单地址（不受限制）



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
        //==新增==
        //初始单笔最大交易为总供应量的1%（可后续调整）
        maxTransactionAmount = totalSupply / 100;
        //部署者加入白名单
        whiteListedAddress[msg.sender] = true;
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
    function _update(
        address sender,
        address recipient,
        uint256 amount
    ) internal override {
            //==新增==
            // 校验交易限制
            //判断是否在白名单中
            if (!whiteListedAddress[sender] && !whiteListedAddress[recipient]) {
                _checkTransactionLimits(sender, amount); // 检查交易限制
            }
            
            
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
            super._update(sender, recipient, transferAmount);
            //处理营销税
            if (marketingTax > 0) {
                super._update(sender, marketingAddress, marketingTax);
            }
            //处理流动性税
            if (liquidityTax > 0 && liquidityAddress != address(0)) {
                super._update(sender, liquidityAddress, liquidityTax);
            }
            //处理销毁的税
            if (taxAmount > 0) {
                super._update(sender, address(0), taxAmount); // 直接用 super._update 销毁
            }
            //触发事件
            emit TaxDistributed(liquidityTax, marketingTax, taxAmount);
    }

    //==新增==
    //更新交易限制参数
    function updateTransactionLimits(uint256 _maxTransactionAmount, uint256 _maxDailyTransactions) external onlyOwner {
        maxTransactionAmount = _maxTransactionAmount;
        maxDailyTransactions = _maxDailyTransactions;
    }

    //管理白名单
    function setWhiteListedAddress(address _address, bool _status) external onlyOwner {
        require(_address != address(0), "Invalid address");
        whiteListedAddress[_address] = _status;
    }

    //新增  校验交易限制的内部函数
    function _checkTransactionLimits(address sender, uint256 amount) internal {
        // 如果是白名单地址，则不受限制
        if (whiteListedAddress[sender]) {
            return;
        }
        // 检查单笔交易金额限制
        require(amount <= maxTransactionAmount, "Transaction amount exceeds limit");

        // 检查每日交易次数限制
        uint256 currentTime = block.timestamp;
        if (lastTransactionTimestamp[sender] < currentTime - 1 days) {
            dailyTransactionCount[sender] = 0; // 重置每日交易次数
            lastTransactionTimestamp[sender] = currentTime; // 更新最后交易时间
        }
        require(dailyTransactionCount[sender] < maxDailyTransactions, "Daily transaction limit exceeded");
        
        dailyTransactionCount[sender]++; // 增加交易次数计数
    }




}
