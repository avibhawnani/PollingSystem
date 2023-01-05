// SPDX-License-Identifier:MIT
pragma solidity ^0.8.9;
contract Polling{

    struct Voter{                                   //Creating Voter Structure
        string voterName;                           //Voter{voterName: John, voted:true/false }
        bool voted;
    }

    struct Choice{                                  //Creating Voter's Choice
        string Name;                                //Choice{Name:Yes/No/Maybe/Never/OtherChoices, voteCount:0}
        uint voteCount; 
    }

    uint public totalVoter;                         //counting total no. of votes
    address public OfficialAddress;                //Poll Creator's Wallet Address
    string public statement;                       //Proposal Statment of the Poll

    mapping(address=>Voter) private voters;         //Mapping Voter's Address (0x012AB..) -> Voter{John,false}
    Choice[] private choices;                       //Choices Array : 0->Choice A , 1->Choice B
    mapping(string => uint) private choice_index;   //Mapping Choice with index: ChoiceNameA->0, ChoiceNameB->1

    enum States{Created,VotingStarted,VotingEnded}  //Enumeration for controlling Voting States
    States private state;

    modifier onlyOfficial(){                        //Check for Poll Creator
        require(msg.sender == OfficialAddress,"You are not the official");
        _;
    }

    modifier inState(States _st){                   //Check for the Specific Voting States
        require(state == _st,"Different State");
        _;
    }

    constructor(string[] memory choiceNames,string memory _st){  //Constructor for Initialization of choices,Proposal statement etc.
        OfficialAddress = msg.sender;   
        totalVoter = 0;
        statement = _st;
        state = States.Created;

        for(uint i=0; i<choiceNames.length;i++){
            choices.push(Choice({
                Name: choiceNames[i],
                voteCount:0
            }));
            choice_index[choiceNames[i]] = i;
        }
    }

    function startVote() onlyOfficial inState(States.Created) public {      //Switch state to Start Voting
        state = States.VotingStarted;
    }

    function endVote()public onlyOfficial inState(States.VotingStarted) {   //Switch state to End Voting
        state = States.VotingEnded;
    }

    function Vote(string memory _choice,string memory _vName) inState(States.VotingStarted) public{     //Vote Function
        require(msg.sender != OfficialAddress,"The official cannot vote.");
        Voter storage User = voters[msg.sender];
        require(User.voted == false,"Already Voted");
        User.voted = true;
        User.voterName = _vName;
        choices[choice_index[_choice]].voteCount += 1;
        totalVoter++;
    }   

    function CalcResultDeclare() inState(States.VotingEnded) onlyOfficial internal view returns (uint winningChoice){   //Internal Function for Calculating Result
        uint winningVoteCount = 0;
        for(uint p=0;p<choices.length;p++){
            if(choices[p].voteCount > winningVoteCount){
                winningVoteCount = choices[p].voteCount;
                winningChoice = p;
            }
        }

    }

    function ResultDeclare() onlyOfficial public view returns(string memory _WinnerChoice){     //Declaring Result
        uint winner = uint(CalcResultDeclare());
        _WinnerChoice =  choices[uint(winner)].Name;   
    }

    function VoteInfo() public view returns(uint[] memory){                                     //Real-Time Voting Information
        uint[] memory voteInf = new uint[](choices.length);
        for(uint x=0;x<choices.length;x++){
            voteInf[x] = choices[x].voteCount;
        }
        return voteInf;
    }
    function getState() public view returns(uint){  //returns the current state
        return uint(state);
    }

}