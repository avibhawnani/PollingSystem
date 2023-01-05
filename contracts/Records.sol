// SPDX-License-Identifier:MIT
pragma solidity ^0.8.9;
contract Records{
    address public pollCreator;
    // address[] public polls;
    mapping(address=>address[]) private records;

    modifier onlyCreator(){                        //Check for Poll Creator
        require(msg.sender == pollCreator,"You are not the Creator");
        _;
    } 

    constructor(address _pollAddress){
        pollCreator = msg.sender;
        require(_pollAddress != pollCreator,"Address belongs to Creator's EOA address.");
        records[pollCreator].push(_pollAddress);
    }

    function getPolls() onlyCreator external view returns(address[] memory ){
        return records[pollCreator];
    }

    function addPolls(address _pAddress) onlyCreator external {
        require(_pAddress != pollCreator,"Address belongs to Creator's EOA address.");
        records[pollCreator].push(_pAddress);
    }
    
}