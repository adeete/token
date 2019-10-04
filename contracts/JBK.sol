pragma solidity ^0.5.0;


contract owner {
    address public owner_1;
        constructor() public {
        owner_1 = address(msg.sender);    }
    modifier onlyOwner {
        require (address(msg.sender) == owner_1,"The sender is not the owener");
        _;
    }
    function transferOwnership(address newOwner) public onlyOwner {
         owner_1 = newOwner;
    }
}
interface tokenRecipient { function receiveApproval (address _from, uint256  _value, address _token, bytes calldata) external; }

contract TokenERC20 {
    // Public variables of the token
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
// This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, uint256 value);
    // This generates a public event on the blockchain that will notify clients
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
// This notifies clients about the amount burnt
    event Burn(address indexed from, uint256 value);

    constructor(
        uint256 initialSupply,
        string  memory tokenName,
        string  memory tokenSymbol
    ) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
    }

    function transfer(address _from,address _to, uint256 _value) internal {
        // Check if the sender has enough
       // require(balanceOf[_from] >= _value);
        require(balanceOf[_from] >= _value,"Value greater than the sender's balance");
        // Check for overflows
        require(balanceOf[_to] + _value > balanceOf[_to],"overflow occured for the reciever");
        // Save this for an assertion in the future
        uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
        // Subtract from the sender
                //balanceOf[msg.sender] = address(_from).balance;
        balanceOf[_from] -= _value;
                // Add the same to the recipient
        //balanceOf[_to] = address(_to).balance;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
       // require(_value <= allowance[_from][msg.sender]);     // Check allowance
       // allowance[_from][msg.sender] -= _value;
       require(balanceOf[_from] >= _value,"Value greater than the sender's balance");
       require(_value <= allowance[_from][msg.sender],"Value is greater than allowed");
       balanceOf[_from] -= _value;
       balanceOf[_to] += _value;
       allowance[_from][msg.sender] -= _value;
       emit Transfer(_from, _to, _value);
        return true;
    }
    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
    //     public
    //     returns (bool success) {
    //      tokenRecipient spender = tokenRecipient(_spender);
    //     if (approve(_spender, _value)) {
    //         spender.receiveApproval(msg.sender, _value, this, _extraData);
    //         return true;
    //     }
    // }

    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value,"Value greater than the sender's balance");   // Check if the sender has enough
        balanceOf[msg.sender] -= _value;            // Subtract from the sender
        totalSupply -= _value;                      // Updates totalSupply
        emit Burn(msg.sender, _value);
        return true;
    }

    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value,"Value greater than the sender's balance");                // Check if the targeted balance is enough
        require(_value <= allowance[_from][msg.sender],"Overflow occured for the receiver");    // Check allowance
        balanceOf[_from] -= _value;                         // Subtract from the targeted balance
        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
        totalSupply -= _value;                              // Update totalSupply
        emit Burn(_from, _value);
        return true;
    }
}

contract JBK is owner, TokenERC20 {
    uint256 public sellPrice;
    uint256 public buyPrice;
    // uint256 public initialSupply = 10000000000;
     mapping (address => bool) public frozenAccount;
/* This generates a public event on the blockchain that will notify clients */
    event FrozenFunds(address target, bool frozen);
/* Initializes contract with initial supply tokens to the creator of the contract */
    constructor(
        uint256 initialSupply,
        string memory tokenName,
        string memory tokenSymbol
    ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
    }
    function getBalance(address addr) public view returns(uint256 balancen){
        return balanceOf[addr];
    }
        /* Internal transfer, only can be called by this contract */
    function _transfer(address _from,address  _to, uint256 _value) public {
        require(balanceOf[_from]>=_value,"Value greater than the sender's balance");
        require(balanceOf[_to] + _value>balanceOf[_to],"Overflow occured for the reciever");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from,_to,_value);
    }
    function getInitialSuuply() public view returns(uint256 supply){
        return totalSupply;
    }

    function mintToken(address target, uint256 mintedAmount) public onlyOwner{
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        //emit Transfer(0, this, mintedAmount);
        //emit Transfer(this, target, mintedAmount);
    }

    function freezeAccount(address target, bool freeze) public onlyOwner {
        frozenAccount[target] = freeze;
        emit FrozenFunds(target, freeze);
    }
    function balanceAddr(address _from)  public view returns(uint256 bal){
        return address(_from).balance;
    }
    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner {
        sellPrice = newSellPrice;
        buyPrice = newBuyPrice;
    }

    // function buy() payable public {
    //     uint amount = msg.value / buyPrice;               // calculates the amount
    //   // _transfer(this, msg.sender, amount);              // makes the transfers
    // }

    function sell(uint256 amount) public {
      // address myAddress = this;
      //  require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
     //   _transfer(msg.sender, this, amount);              // makes the transfers
        msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
    }
}
