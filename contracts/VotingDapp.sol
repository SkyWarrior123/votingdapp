//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract VotingDapp {

    struct Voter {
        uint256 weight; 
        bool voted;
        address delegate;
        uint vote;
    }

    struct Proposal{
        bytes32 name;
        uint256 voteCount;
    }

    address public chairperson;
    mapping( address => Voter) public voters;

    Proposal[] public proposals;

    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        for (uint i = 0; i < proposalNames.length; i++){
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    function giveRighttoVote(address voter) external {
        require(msg.sender == chairperson,"Only Chairperson allowed to asssign voting rights");
        require(!voters[voter].voted, "Voter already voted once");

        voters[voter].weight = 1;
    }

    function removeVotingRights(address voter) external {
        require(msg.sender == chairperson,"Only Chairperson allowed to asssign voting rights");
        require(!voters[voter].voted, "Voter already voted once");
        require(voters[voter].weight == 1);
        voters[voter].weight = 0;
    }

    function delegate(address to) external {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted,"You already voted once");
        require(to != msg.sender,"Self-delegation is not allowed");

        while (voters[to].delegate != address(0)){
            to = voters[to].delegate;
            require(to !=msg.sender, "Found loop during Delegation");
        }

        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
        if(delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            delegate_.weight += sender.weight;
        }
    }

    function vote(uint proposal) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "No right to vote");
        require(!sender.voted,"Already Voted");
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.weight;
    }

    function winningProposal() public view returns( uint _winningProposal){
        uint winningVoteCount = 0;
        for(uint p = 0; p < proposals.length; p++){
            if(proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                _winningProposal = p;
            }
        }
    }

    function winnerName() public view returns(bytes32 winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }
}
