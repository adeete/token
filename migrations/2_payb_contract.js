var jbkContract = artifacts.require("./JBK.sol");
var payBContract = artifacts.require("./payback.sol");
var contract_address = '0x00774c51076c865ec14191375a2070E4430C6a47';
module.exports = async function(deployer) {
  let ins = await jbkContract.at(contract_address);
  await deployer.deploy(payBContract,ins.address,{"from":"0x69A9CAEc73e4378801266dFc796d92aFC98013f6"});
};