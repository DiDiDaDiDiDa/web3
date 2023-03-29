// SPDX-License-Identifier: MIT
pragma solidity >0.8.0 <0.9.0;

import "./context.sol";

/*
    ERC20需要实现的接口
    function name() public view returns (string)
    function symbol() public view returns (string)
    function decimals() public view returns (uint8)
    function totalSupply() public view returns (uint256)
    function balanceOf(address _owner) public view returns (uint256 balance)
    function transfer(address _to, uint256 _value) public returns (bool success)
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
    function approve(address _spender, uint256 _value) public returns (bool success)
    function allowance(address _owner, address _spender) public view returns (uint256 remaining)

    event Transfer(address indexed _from, address indexed _to, uint256 _value)
    event Approval(address indexed _owner, address indexed _spender, uint256 _value)


    */
contract MyToken is Context{
    // 1、代币信息
    // 代币名称name
    string private _name;

    // 代币标识 symbol
    string private _symbol;

    // 代币小数位数 decimals
    uint8 private _decimals;

    // 代币的总发行量 totalSupply
    uint256 private _totalSupply;

    // 代币数量 balance
    mapping(address=>uint256) private _balances;

    // 授权代币数量 allowance
    mapping(address=>mapping(address=>uint256)) private _allowances;

    //2、初始化
     constructor (){
         _name="RabbitCoin";
         _symbol="RABTC";
         _decimals=18;


        //  初始化代币池
         _mint(_msgSender(),100*10000*10**_decimals);
     }

     
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);


     //3、取值器
    //  返回代币的名字
    function name()public view returns(string memory){
        return _name;
    }

    function symbol() public view returns (string memory){
        return _symbol;
    }
    function decimals() public view returns (uint8){
        return _decimals;
    }
    function totalSupply() public view returns (uint256){
         return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256){
        return _balances[_owner];
    }
    function allowancesOf(address owner,address spender) public view returns (uint256){
        return _allowances[owner][spender];
    }
    function transfer(address _to, uint256 _value) public returns (bool){
        _transfer(_msgSender(),_to,_value);
        return true;

    }

    function approve(address _spender, uint256 _value) public returns (bool){
        address owner=_msgSender();
        _approve(owner,_spender,_value);

        return true;
    }
    function transferFrom(address from,address to,uint256 amount)public returns (bool){
        address owner=_msgSender();
        _spendAllowance(from,owner,amount);
        _transfer(from,to,amount);
        return true;
    }


     // 合约内部函数
     function _mint(address account, uint256 amount) internal {
         require(account!=address(0),"ERC20:mint to the zero address");

        //  初始化货币数量
         _totalSupply+=amount;

        // 给账号注入起始资金
        unchecked{
            _balances[account]+=amount;
        }
     }
     function _transfer(address _from,address _to,uint256 amount) internal {
        require(_from!=address(0),"ERC20:transfer from the zero address");
        require(_to!=address(0),"ERC20:transfer to the zero address");
        require(_balances[_from]>=amount, unicode"ERC20:余额不足");
        unchecked{
            _balances[_from]-=amount;
            _balances[_to]+=amount;
        }
        emit Transfer(_from,_to,amount);
    }
    function _approve(address owner,address spender,uint256 amount)internal {
         require(owner!=address(0),"ERC20:mint to the zero address");
         require(spender!=address(0),"ERC20:mint to the zero address");
        require(_balances[owner]>=amount, unicode"ERC20:余额不足");
        _allowances[owner][spender]=amount;
        emit Approval(owner,spender,amount);

    }

    function _spendAllowance(address owner ,address spender,uint256 amount)internal{
        uint256 currentAllowance=allowancesOf(owner,spender);
        require(_balances[owner]>=amount, unicode"ERC20:授款方余额不足");
        require(currentAllowance>=amount, unicode"ERC20:授权余额不足");
        unchecked{
            _approve(owner,spender,currentAllowance-amount);
        }
    }


    
}
