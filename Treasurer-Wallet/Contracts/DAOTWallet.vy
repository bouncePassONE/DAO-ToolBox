#@version ^0.2.0
#@author bP Labs
#@title DAO Treasurer Wallet
#@license MIT

interface Staking:
    def _delegate(validatorAddress:address,amount:uint256)    :  nonpayable
    def _undelegate(validatorAddress:address,amount:uint256)  :  nonpayable
    def _collectRewards()                                     :  nonpayable

multisigDAO       :  public(address)
treasurerAccount  :  public(address)

@external
@payable
def __default__():
    pass
    
@external
def setupWallet():
    assert self.multisigDAO  ==  ZERO_ADDRESS
    self.multisigDAO          =  msg.sender
    
@external
def appointTreasurer( _treasurerAccount : address ):
    assert self.multisigDAO  ==  msg.sender
    self.treasurerAccount     =  _treasurerAccount

@external
@payable
def DAOWithdraw( amount : uint256 ):
    assert self.treasurerAccount == msg.sender
    send( self.multisigDAO , amount )
    

@external
@nonpayable
def DAODelegate( validatorAddress : address , amount : uint256 ):
    assert self.treasurerAccount == msg.sender
    Staking(0xC7A73F71202d5b6204FBC46c22823Faa7D853645)._delegate( validatorAddress , amount )

@external
@nonpayable
def DAOUndelegate( validatorAddress : address , amount : uint256 ):
    assert self.treasurerAccount == msg.sender
    Staking(0xC7A73F71202d5b6204FBC46c22823Faa7D853645)._undelegate(  validatorAddress , amount )

@external
@nonpayable
def DAOCollectRewards():
    assert self.treasurerAccount == msg.sender
    Staking(0xC7A73F71202d5b6204FBC46c22823Faa7D853645)._collectRewards()
