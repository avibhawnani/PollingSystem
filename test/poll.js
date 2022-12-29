const {expect} =  require("chai");
const { ethers } = require("hardhat");
const testCase = require('mocha').describe;

testCase("Deployment",function(){
    let Poll;
    let poll;
    let Official;
    let proposal="Should we have coffee shop in our office?";
    let choices;
    let v1;
    let v2;
    let v3;
    beforeEach(async function(){
        Poll = await ethers.getContractFactory("Polling");
        [Official,v1,v2,v3] = await ethers.getSigners();
        choices = ["Yes","No","Shouldbe","Never"];
        poll = await Poll.deploy(choices,proposal);
    });

    testCase("Polling Contract",function(){

        it("Official Check",async function(){
            console.log("Official Address : ",Official.address);
            const officialInfo = await poll.OfficialAddress();
            console.log("Code Official Address : ",officialInfo);
            expect(await Official.address).to.equal(officialInfo);
        });

        it("Proposal Check",async function(){
            console.log("Proposal Statement : ",proposal);
            const st = await poll.statement();
            console.log("Code Statement : ",st);
            expect(await st).to.equal(proposal);
        });

        it("Choices Check",async function(){
            console.log("Choices : ",choices);
            const ch = await poll.choices(0);
            console.log("Code Choices Array : ",ch);
            expect(await ch[0]).to.equal(choices[0]);  
        });

        it("States Check - Polling Started",async function(){
            const stat = await poll.state();
            console.log("State of the Poll : ",stat);
            expect(await stat).to.equal(0);
        });

        it("Check converted state - Voting Started",async function(){
            await poll.startVote();
            const stat = await poll.state();
            console.log("State of the Poll : ",stat);
            expect(await stat).to.equal(1);
        });
    });
});