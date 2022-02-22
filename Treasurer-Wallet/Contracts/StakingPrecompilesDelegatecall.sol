//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

enum Directive {
  //CREATE_VALIDATOR, // unused
  //EDIT_VALIDATOR,   // unused
  DELEGATE,
  UNDELEGATE,
  COLLECT_REWARDS
}

abstract contract StakingPrecompilesSelectors {
  function Delegate(address delegatorAddress,
                    address validatorAddress,
                    uint256 amount) public virtual;
  function Undelegate(address delegatorAddress,
                      address validatorAddress,
                      uint256 amount) public virtual;
  function CollectRewards(address delegatorAddress) public virtual;
  function Migrate(address from, address to) public virtual;
}

contract StakingPrecompilesDelegatecall {
  function delegate(address validatorAddress, uint256 amount) internal returns (uint256 result) {
    bytes memory encodedInput = abi.encodeWithSelector(StakingPrecompilesSelectors.Delegate.selector,
                                    msg.sender,
                                    validatorAddress,
                                    amount);
    assembly {
      // we estimate a gas consumption of 25k per precompile
      result := delegatecall(25000,
        0xfc,
        
        add(encodedInput, 32),
        mload(encodedInput),
        mload(0x40),
        0x20
      )
    }
  }

  function undelegate(address validatorAddress, uint256 amount) internal returns (uint256 result) {
    bytes memory encodedInput = abi.encodeWithSelector(StakingPrecompilesSelectors.Undelegate.selector,
                                    msg.sender,
                                    validatorAddress,
                                    amount);
    assembly {
      // we estimate a gas consumption of 25k per precompile
      result := delegatecall(25000,
        0xfc,
        
        add(encodedInput, 32),
        mload(encodedInput),
        mload(0x40),
        0x20
      )
    }
  }

  function collectRewards() internal returns (uint256 result) {
    bytes memory encodedInput = abi.encodeWithSelector(StakingPrecompilesSelectors.CollectRewards.selector,
                                    msg.sender);
    assembly {
      // we estimate a gas consumption of 25k per precompile
      result := delegatecall(25000,
        0xfc,
        
        add(encodedInput, 32),
        mload(encodedInput),
        mload(0x40),
        0x20
      )
    }
  }
}
