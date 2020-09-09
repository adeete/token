var jbkContract = artifacts.require("./JBK.sol");
var payBContract = artifacts.require("./payback.sol");
var contract_address = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
module.exports = async function(deployer) {
  let ins = await jbkContract.at(contract_address);
  await deployer.deploy(payBContract,ins.address,{"from":"xxxxxxxxxxxxxxxxxxxxxx"});
};