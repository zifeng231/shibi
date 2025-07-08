pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract ShibStyleTokenStep1 is ERC20 {

    // 构造函数：初始化代币名称、符号、总供应量
    constructor(
        string memory name,
        string memory symbol,
        uint256 totalSupply // 总供应量（如1000万亿：1）
    ) ERC20(name, symbol) {
        // 将总供应量转换为最小单位（如1个代币 = 10**18 wei）
        _mint(msg.sender, totalSupply * 10 ** decimals());
    }
}
