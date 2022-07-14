// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract Allowance is Ownable {
    using SafeMath for uint;

    // event to manage any changes in allowances that occur like reduction or addition of allowances
    event AllowanceChanged(address indexed _forWho, address indexed _fromWhom, uint _oldAmount, uint _newAmount);

    // state variable which stores the allowance assigned to a given account
    mapping(address => uint) public allowance;

    // this function restricts the functionality to only owner or allowed account according to logic
    // the logic is that the amount being withdrawn should be less than the available allowance of that account
    modifier ownerOrAllowed(uint _amount) {
        require(_amount <= allowance[msg.sender] || owner() == msg.sender, "You are not allowed");
        _;
    }

    // adding allowance for an account
    function addAllowance(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who].add(_amount));
        allowance[_who] = allowance[_who].add(_amount);
    }

    // reducing allowance for an account
    function reduceAllowance(address _who, uint _amount) internal {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who].sub(_amount));
        allowance[_who] = allowance[_who].sub(_amount);
    }

    // this function overrides the already available function in Openzeppelin
    // renounceOwnership is not significant for this project. So it is better to override and make it disfunctional
    function renounceOwnership() public override virtual onlyOwner {
        revert("Cannot use this functionality");
    }
}