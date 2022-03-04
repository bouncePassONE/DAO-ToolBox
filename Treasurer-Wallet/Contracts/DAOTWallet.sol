// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts@4.5.0/utils/Address.sol";
import "@openzeppelin/contracts@4.5.0/access/AccessControl.sol";


interface StakingContractDelegatecall {
    function _delegate( address validatorAddress , uint256 amount ) external returns (bool success);
    function _undelegate( address validatorAddress , uint256 amount ) external returns (bool success);
    function _collectRewards() external returns (bool success);
}

contract DAOTWallet is AccessControl {

    address payable public MULTISIG_DAO;
    address public constant STPREDELCALCONTRACT = 0xbf8ed4dFD20624bf259dd639BB0d3C15002eC3a3;
    bytes32 public constant TREASURER_ROLE = keccak256("TREASURER_ROLE");

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(TREASURER_ROLE, msg.sender);
        MULTISIG_DAO = payable(msg.sender);
    }

    receive() external payable {}

    function DAOWithdraw( uint256 amount ) public onlyRole(TREASURER_ROLE) {
        Address.sendValue( MULTISIG_DAO , amount) ;
    }

    function DAODelegate( address validatorAddress, uint256 amount ) public onlyRole(TREASURER_ROLE) returns(bool success) {
        StakingContractDelegatecall( STPREDELCALCONTRACT )._delegate( validatorAddress , amount );
        return (success);
    }
    
    function DAOUndelegate( address validatorAddress, uint256 amount ) public onlyRole(TREASURER_ROLE) returns(bool success) {
        StakingContractDelegatecall( STPREDELCALCONTRACT )._undelegate( validatorAddress , amount );
        return (success);
    }
    
    function DAOCollectRewards() public onlyRole(TREASURER_ROLE) returns(bool success) {
        StakingContractDelegatecall( STPREDELCALCONTRACT )._collectRewards();
        return (success);
    }
    
  
   // Override functions disable ability for default admin to renounce or revoke itself
   
    function renounceRole(bytes32 role, address account) public override(AccessControl) {
        require(account == _msgSender(), "AccessControl: can only renounce roles for self");
        require(hasRole(DEFAULT_ADMIN_ROLE, account) == false, "AccessControl: default admin cannot renounce role");
     
        _revokeRole(role, account);
    }
    
   function revokeRole(bytes32 role, address account) public override(AccessControl) onlyRole(getRoleAdmin(role)) {
        require(hasRole(DEFAULT_ADMIN_ROLE, account) == false, "AccessControl: default admin cannot renounce role");
        _revokeRole(role, account);
    }
}
