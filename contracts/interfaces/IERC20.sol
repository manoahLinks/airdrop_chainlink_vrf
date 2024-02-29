// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IERC20 {
    
    function transferFrom(address _from, address _to, uint _amount) external returns (bool);

    function transfer(address _to, uint _amount) external returns (bool);

    function balanceOf(address _account) external view returns (uint256); 
}