pragma solidity ^0.5.0;

import "./JBK.sol";

contract payback{
    JBK public jbk ;
    struct customer{
        // string  MobileNo;
        address  CAccountID;
        uint256 tokenvalue; //token balance value
        string  Token;  //name of the token, JBK
        string  TokenValidity;  //token valid date
    }
    struct RetailCompany{
        string  Name;           //Name of the RetailCompany
        //string  RAccountID;
        string  IssuedToken; //Name of the token , here JBK
        uint256 IssuedTokenSupply;
        uint256 RTokenvalue;
    }
    // mapping (address => uint256) public balanceOf;
    mapping (string => customer) Cust;
    mapping (address => RetailCompany) retailcomp;
    function getbalanceJBK(address addr) public view returns (uint balance){
        // balance = balanceOf[_tokenaddr];
        // balance = address(_tokenaddr).balance;
        return jbk.balanceOf(addr);
    }
    constructor(JBK _jbkContract) public {
        jbk = _jbkContract;
     }
    function setCustomerJBK(string memory _MobileNo,address  _AccountID, uint256 _token,
                            string memory _tokenSymbol, string memory _tokenValidity)
                            public returns (bool success) {
        Cust[_MobileNo] = customer(_AccountID,_token,_tokenSymbol,_tokenValidity);
        return true;
    }
    function setRetailCompany(address _rAccountID,string memory name,
                            string memory _issuedToken,uint256 _issuedTokenSupply,uint256 _rTokenValue )
                         public returns (bool success){
        retailcomp[_rAccountID] = RetailCompany(name,_issuedToken,_issuedTokenSupply,_rTokenValue);
        return true;
    }
    function getCustTokenBal(string memory _mobileno)public view returns (uint256 balance){
        address addr = Cust[_mobileno].CAccountID;
        return jbk.balanceOf(addr);
    }
    function getRetaiCompBal(address _rAccountID )public view returns (uint _balance){
        return retailcomp[_rAccountID].IssuedTokenSupply;
    }
    function gettokensupply() public view returns (uint256 _token){
        uint256 _vol = jbk.totalSupply();
        return _vol;
    }
    function transferFromRetail2Cust(address _rAccountId,string memory mobile_no,uint256 _value)public returns(bool success){
        address custAddress = Cust[mobile_no].CAccountID;
        require(transferUsingJBK(_rAccountId,custAddress,_value),"Failed to transfer");
        Cust[mobile_no].tokenvalue += _value;
        retailcomp[_rAccountId].IssuedTokenSupply -= _value;
        return true;
    }
    function transferFromCust2Cust(string memory _senderMobileNo,string memory _receiverMobileNo,uint256 _value)public returns(bool success){
        address custAddress1 = Cust[_senderMobileNo].CAccountID;
        address custAddress2 = Cust[_receiverMobileNo].CAccountID;
        require(transferUsingJBK(custAddress1,custAddress2,_value),"Failed to transfer");
        Cust[_senderMobileNo].tokenvalue += _value;
        Cust[_receiverMobileNo].tokenvalue -= _value;
        return true;
    }
    function transferFromCust2Retail(address _rAccountId,string memory mobile_no,uint256 _value)public returns(bool success){
        address custAddress = Cust[mobile_no].CAccountID;
        require(transferUsingJBK(custAddress,_rAccountId,_value),"Failed to transfer");
        Cust[mobile_no].tokenvalue -= _value;
        retailcomp[_rAccountId].IssuedTokenSupply += _value;
        return true;
    }
    function transferFromOwnerToRetail(address _rAccountId,uint256 _value) public returns(bool success) {
        require(transferUsingJBK(msg.sender,_rAccountId,_value),"Failed to transfer");
        retailcomp[_rAccountId].IssuedTokenSupply += _value;
        return true;
    }
    function transferUsingJBK(address _from,address _to,uint256 _value) public payable returns (bool success) {
        jbk._transfer(_from,_to,_value);
        return true;
    }
}