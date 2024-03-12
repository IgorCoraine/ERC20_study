// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Token {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

    error InsufficientBalance(uint256 available, uint256 required);
    error AddressNotValid(address invalidAddress);
    error InsufficientAllowance(uint256 available, uint256 required);

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor (){
        _name = "Igor Coraine";
        _symbol = "CORA";
        _decimals = 18;
        _totalSupply = 1000000*1e18;
        _balances[msg.sender] = _totalSupply;
    }    

    function name() public view returns (string memory){
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

    function balanceOf(address _owner) public view returns (uint256 balance){
        return _balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success){
        if (_to == address(0)){
            revert AddressNotValid({
                invalidAddress: _to
            });
        }
        if (_balances[msg.sender] < _value){
            revert InsufficientBalance({
                available: _balances[msg.sender],
                required: _value
            });
        }
        _balances[msg.sender] -= _value;
        _balances[_to] += _value;
        success = true;
        emit Transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        if (_to == address(0)){
            revert AddressNotValid({
                invalidAddress: _to
            });
        }
        if (_from == address(0)){
            revert AddressNotValid({
                invalidAddress: _from
            });
        }
        if (_allowances[_from][msg.sender] < _value){
            revert InsufficientAllowance({
                available: _balances[msg.sender],
                required: _value
            });
        }
        if (_balances[_from] < _value){
            revert InsufficientBalance({
                available: _balances[_from],
                required: _value
            });
        }
        _allowances[_from][msg.sender] -= _value;
        _balances[_from] -= _value;
        _balances[_to] += _value;
        success = true;
        emit Transfer(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) public returns (bool success){
        if (_spender == address(0)){
            revert AddressNotValid({
                invalidAddress: _spender
            });
        }
        _allowances[msg.sender][_spender] = _value;
        success = true;
        emit Approval(msg.sender, _spender, _value);
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining){
        return _allowances[_owner][_spender];
    }


}
