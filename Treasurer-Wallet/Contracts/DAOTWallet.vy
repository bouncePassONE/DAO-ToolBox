#@version ^0.2.0
#@author bP Labs
#@title DAO Treasurer Wallet
#@license MIT

interface Staking:
    def _delegate(validatorAddress:address,amount:uint256): nonpayable
    def _undelegate(validatorAddress:address,amount:uint256): nonpayable
    def _collectRewards(): nonpayable

multisigDAO         :  public(address)
treasurerAccount    :  public(address)


@external
def __init__():
    self.multisigDAO = msg.sender

@external
@payable
def __default__():
    pass
    
@external
def setupWallet():
    assert self.multisigDAO == ZERO_ADDRESS
    self.multisigDAO = msg.sender

@external
@payable
def DAOWithdraw( amount : uint256 ):
    assert self.treasurerAccount == msg.sender
    send( self.multisigDAO , amount )

@external
@nonpayable
def DAODelegate( validatorAddress : address , amount : uint256 ):
    assert self.treasurerAccount == msg.sender
    Staking(0x21Bb4A65a7b5e817EAc48a6F2aa714d83253dd35)._delegate( validatorAddress , amount )

@external
@nonpayable
def DAOUndelegate( validatorAddress : address , amount : uint256 ):
    assert self.treasurerAccount == msg.sender
    Staking(0x21Bb4A65a7b5e817EAc48a6F2aa714d83253dd35)._undelegate(  validatorAddress , amount )

@external
@nonpayable
def DAOCollectRewards():
    assert self.treasurerAccount == msg.sender
    Staking(0x21Bb4A65a7b5e817EAc48a6F2aa714d83253dd35)._collectRewards()


@external
def appointTreasurer( _treasurerAccount : address ):
    assert self.multisigDAO == msg.sender
    self.treasurerAccount = _treasurerAccount
