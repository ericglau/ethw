pragma solidity >= 0.5.5 < 0.6.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/token/ERC20/ERC20.sol";
contract Checkpoint {
    
    

    string public description;
    bool public completed;
    bool public accepted;
    bool public rejected;
    bool public cancelled;
    
    address public owner;
    address public freelancer;
    
    uint bounty;
    string public url;
    
    uint public balance;


    constructor(string memory _description, uint _bounty, IERC20 _token) public {
        owner = tx.origin;
        description = _description;
        bounty = _bounty;
        associatedToken = _token;
    }
    
    
    IERC20 public associatedToken;
    
    function fund(uint tokenAmount) public payable {

// TODO user needs to manually do this

        associatedToken.approve(msg.sender, tokenAmount);
        
        // transfer the tokens from the sender to this contract
        associatedToken.transferFrom(msg.sender, address(this), tokenAmount);

        // add the deposited tokens into existing balance 
        balance += tokenAmount;
    }
    
    function complete(string memory _url) public {
        require(
            balance >= bounty,
            "Contract not fully funded yet."
        );
        
        url = _url;
        freelancer = msg.sender;
        completed = true;
        rejected = false;
    }
    
    function approve() public payable
    {
        require(
            msg.sender == owner,
            "Sender not authorized."
        );
        
        require(
            balance >= bounty,
            "Contract not fully funded yet."
        );
        
        accepted = true;
        associatedToken.transfer(freelancer, balance);
        balance = 0;
    }
    
    function reject() public 
    {
        require(
            msg.sender == owner,
            "Sender not authorized."
        );
        
        require(
            balance >= bounty,
            "Contract not fully funded yet."
        );
        
        rejected = true;
        completed = false;
    }
    
    function cancel() public payable
    {
        require(
            msg.sender == owner,
            "Sender not authorized."
        );
        
        cancelled = true;
        associatedToken.transfer(owner, balance);
    }
    

    
    
}