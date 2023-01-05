solc = require("solc");                //for compiling .sol file
fs = require("fs");                    //for opening file
Web3 = require("web3");  

let web3 = new Web3(new Web3.providers.HttpProvider("Your Ganache server ID"));

let fileContent = fs.readFileSync("contracts/Polling.sol").toString();
// console.log(fileContent);

//giving input to solc compiler
var input = {
    language: "Solidity",
    sources: {
      "Polling.sol": {
        content: fileContent,
      },
    },
  
    settings: {
      outputSelection: {
        "*": {
          "*": ["*"],
        },
      },
    },
  };

var output = JSON.parse(solc.compile(JSON.stringify(input)));
console.log(output);
ABI = output.contracts["Polling.sol"]["Polling"].abi;
bytecode = output.contracts["Polling.sol"]["Polling"].evm.bytecode.object;
// console.log("ABI: ",ABI);
// console.log("Bytecode: ",bytecode);

contract = new web3.eth.Contract(ABI);
