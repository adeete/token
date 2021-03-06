const web3 = require('web3');
const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');
const contract = require('truffle-contract');
const balanceCheck = require('eth-balance-checker/lib/web3');
var urlEncodedParser = bodyParser.urlencoded({
    extended: true
});

var app = express();
const contractJson = require(path.join(__dirname,"build/contracts/payback.json"));
let web3Provider = new web3.providers.HttpProvider('http://localhost:7545');
let web3js = new web3(web3Provider);

const myContract = contract(contractJson);

myContract.setProvider(web3Provider);
let _instance;
myContract.deployed().then((instance) =>{
    _instance = instance;
});
app.use(urlEncodedParser);
app.use(bodyParser.json());


app.post("/setCustomer",(req,res) =>{
    var args = req.body.args;
    _instance.setCustomerJBK(args[0],args[1],args[2],args[3],args[4],{
        from: 'xxxxxxxxxxxxxxxxxxxxxxx'
    }).then((result)=>{
        res.send("successfully set the customer");
    });
});
app.post("/setRetail", (req,res) =>{
    var args = req.body.args;
    _instance.setRetailCompany(args[0],args[1],args[2],args[3],args[4],{
        from: 'xxxxxxxxxxxxxxxxxxxx'
    }).then((result)=>{
        console.log(result);
        res.send("Successfuly set the retail company");
    });
});
app.get("/customerAccountNo",(req,res)=>{
    var args = req.body.args;
    myContract.methods.Cust(args[0]).call((err,result)=>{
        res.send({"acc":result.toString()});
    })
});
app.post("/transferFromRetail2Cust", (req,res) =>{
    var args = req.body.args;
    _instance.transferFromRetail2Cust(args[0],args[1],args[2],{
        from: 'xxxxxxxxxxxxxxxxxxxxxx',
    }).then((result) =>{
        console.log(result);
        res.send("Successfully transferred tokens");
    })
});
app.post("/transferFromOwnerToRetail", (req,res) =>{
    var args = req.body.args;
    _instance.transferFromOwnerToRetail(args[0],args[1],{
        from: 'xxxxxxxxxxxxxxxxxxxxxxxx',
    }).then((result) =>{
        console.log(result);
        res.send("Successfully transferred tokens");
    })
});
app.post("/transferFromCust2Cust", (req,res) =>{
    var args = req.body.args;
    _instance.transferFromCust2Cust(args[0],args[1],args[2],{
        from: 'xxxxxxxxxxxxxxxxxxxxx',
    }).then((result) =>{
        console.log(result);
        res.send("Successfully transferred tokens");
    })
});
app.post("/transferFromCust2Retail", (req,res) =>{
    var args = req.body.args;
    _instance.transferFromCust2Retail(args[0],args[1],args[2],{
        from: 'xxxxxxxxxxxxxxxxxxxxxxx',
    }).then((result) =>{
        console.log(result);
        res.send("Successfully transferred tokens");
    })
});
app.get("/balance",(req,res) =>{
    var args = req.body.args;
    _instance.getbalanceJBK(args[0],{
        from: 'xxxxxxxxxxxxxxxxxxxxxxx'
    }).then((result)=>{
        console.log(result.toString());
        
        res.send({balance:result.toString()});
    });
});

app.get("/customer",(req,res)=>{
    var arg = req.body.args;
    _instance.getCustTokenBal(arg[0],{
        from: 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
    }).then((result)=>{
        res.send({res:result.toString()});
    });
});
app.get("/retail", (req,res)=>{
    var arg = req.body.args;
    _instance.getRetaiCompBal(arg[0],{
        from: 'xxxxxxxxxxxxxxxxxxxxxxxxxxx'
    }).then((result)=>{
        res.send({res:result.toString()});
    });
});
app.listen("5100",() =>{
    console.log("listening at port 5100"); 
});