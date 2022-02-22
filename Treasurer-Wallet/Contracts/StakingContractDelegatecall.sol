//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { StakingPrecompilesDelegatecall, Directive } from "./StakingPrecompilesDelegatecall.sol";

contract StakingContractDelegatecall is StakingPrecompilesDelegatecall {

    event StakingPrecompileCalled(uint8 directive, bool success);


    function _delegate(address validatorAddress, uint256 amount) public returns (bool success) {
        uint256 result = delegate(validatorAddress, amount);
        success = result != 0;
        emit StakingPrecompileCalled(uint8(Directive.DELEGATE), success);
    }

    function _undelegate(address validatorAddress, uint256 amount) public returns (bool success) {
        uint256 result = undelegate(validatorAddress, amount);
        success = result != 0;
        emit StakingPrecompileCalled(uint8(Directive.UNDELEGATE), success);
    }

    function _collectRewards() public returns (bool success) {
        uint256 result = collectRewards();
        success = result != 0;
        emit StakingPrecompileCalled(uint8(Directive.COLLECT_REWARDS), success);
    }
}
