//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

enum Directive {
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

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

contract StakingPrecompilesDelegatecall is Context {
  function delegate(address validatorAddress, uint256 amount) internal returns (uint256 result) {
    bytes memory encodedInput = abi.encodeWithSelector(StakingPrecompilesSelectors.Delegate.selector,
                                    _msgSender(),
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
                                    _msgSender(),
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
                                    _msgSender());
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
