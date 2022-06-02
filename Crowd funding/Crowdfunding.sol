
// File: codeapachi.sol


pragma solidity ^0.8.7;
contract CrowdFunding{

//variables
mapping (address=>uint) public constributors;
address public Manger;
uint public Deadline;
uint public target;
uint public noofConstributors;
uint public MinumAmount;
uint public rasidAmount;

struct Request{
    string Desp;
    address payable recip;
    uint valueofamount;
    bool compeleted; //by defualt its false
    uint noofvoters;
    mapping(address=>bool) voters; 
}
mapping(uint=>Request) public requests;
uint public numofrequest;
constructor(uint _target, uint _Deadline){
    target =_target;
    Deadline =block.timestamp+_Deadline; // block time + deadline time in sec
    Manger = msg.sender;
    MinumAmount= 1 ether;
}

function Sendether() public payable {
    require(block.timestamp < Deadline,'the deadline time passed');
    require(msg.value <= MinumAmount ,'Not MinumAmount');
     
     if (constributors[msg.sender]==0){
         noofConstributors++;  // increament
     }
     constributors[msg.sender]+=msg.value;
     rasidAmount+=msg.value;
    
}

function refund() public payable {
    require(block.timestamp > Deadline && rasidAmount < target ,"not Refund");
    require(constributors[msg.sender]>0);
    address payable user = payable(msg.sender);
    user.transfer(constributors[msg.sender]);
    constributors[msg.sender]=0;
}

modifier onlymanger(){
    require(msg.sender==Manger,'this function only allowed Manger');
    _;
}

function createRequest(string memory _desp, address payable _recip, uint _valueofamount)public onlymanger{
   Request storage newrequest = requests[numofrequest];
   numofrequest++;
   newrequest.Desp=_desp;
   newrequest.recip=_recip;
   newrequest.valueofamount=_valueofamount;
   newrequest.compeleted=false;
   newrequest.noofvoters=0;
}
function voteRequest(uint _requestno) public{
    require(constributors[msg.sender]>0,"not constributer");
    Request storage thisrequest = requests[_requestno];
    require(thisrequest.voters[msg.sender]==false,"already voted");
    thisrequest.voters[msg.sender]==true;
    thisrequest.noofvoters++;

}

function MakePaymeant(uint _requestno) public{
    require(rasidAmount>target);
    Request storage thisrequest = requests[_requestno];
    require(thisrequest.compeleted==false,"you already requested");
    require(thisrequest.noofvoters> noofConstributors/2);
    thisrequest.recip.transfer(thisrequest.valueofamount);
    thisrequest.compeleted==true;
}

}

