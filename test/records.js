const {expect} =  require("chai");
const { ethers } = require("hardhat");
const testCase = require('mocha').describe;

testCase("Deployment",function(){
    let Rec;
    let rec;
    let Creator;
    let p1;
    let p2;
    let p3;
    beforeEach(async function(){
        Rec = await ethers.getContractFactory("Records");
        [Creator,p1,p2,p3] = await ethers.getSigners();
        rec = await Rec.deploy(p1.address);
    });

    testCase("Records Contract",function(){

        it("Creator Check",async function(){
            console.log("Creator Address : ",Creator.address);
            const creatorInfo = await rec.pollCreator();
            console.log("Code Creator Address : ",creatorInfo);
            expect(await Creator.address).to.equal(creatorInfo);
        });

        it("Add Polls",async function(){
            console.log("Get list : ",await rec.getPolls());
            await rec.addPolls(p2.address);
            console.log("Get list : ",await rec.getPolls());
            await rec.addPolls(p3.address);
            console.log("Get list : ",await rec.getPolls());
            // await rec.addPolls(Creator.address);
        });
    });
});