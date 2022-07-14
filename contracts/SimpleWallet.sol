// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Allowance.sol";

contract SimpleWallet is Allowance {

    // events that manage Money transactions (sent and received)
    event MoneySent(address indexed _to, uint amount);
    event MoneyReceived(address indexed _from, uint amount);

    // this payable function receives the ether and this ether resides in the smart contract
    function receiveMoney() public payable {
        emit MoneyReceived(msg.sender, msg.value);
    }

    // this function enables the user to withdraw ether from his allowance balance
    function withdrawMoney(address payable _to, uint _amount) public payable ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "You dont have enough funds!");
        _to.transfer(_amount);
        if(owner() != msg.sender) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
    }

    // fallback function
    receive() external payable {
        receiveMoney();
    }
}