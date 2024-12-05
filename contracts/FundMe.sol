
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import "./PriceConvertor.sol";

//get funds from users
//withdraw funds
//set a min funding value in USD

error NotOwner();

contract FundMe{
    using PriceConvertor for uint256;

    uint256 public constant MIN_USD= 50 *1e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;
    
    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }
    
    function fund() public payable {
        require(msg.value.getConversionRate() >= MIN_USD, "Didn't send enough");//1e18== 1 * 10 ** 18 == 1000000000000000000(wei)= 1 eth
        //reverting -> undo any action first and then send the remaining gas back
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value; 

    }
    
    function withdraw() public onlyOwner{

        for(uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //resetting the array
        funders = new address[](0);

        //withdrawing :transfer, send, call 

        //msg.sender -> address
        //payable(msg.sender) -> payable address

        //call: send/transfer native blockchain token???
        (bool callSucess, )=payable(msg.sender).call{value: address(this).balance}("");
        require(callSucess, "Call failed");

     }
    modifier onlyOwner {
        if(msg.sender != i_owner) {revert NotOwner();}
        _;
     }

    receive() external payable {
        fund();
      }
      
    fallback() external payable {
        fund();
     }  

}