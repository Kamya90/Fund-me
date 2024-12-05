// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {AggregatorV3Interface} from "@chainlink/contracts@1.2.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


library PriceConvertor{
    function getPrice() internal view returns(uint256){
        //ABI
        //address -> 0x694AA1769357215DE4FAC081bf1f309aDC325306
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,) = pricefeed.latestRoundData();//ETH in USD
        return uint256(price * 1e10);
    }
    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice= getPrice();
        uint256 ethAmountInUSD = (ethPrice * ethAmount)/ 1e18;
        return ethAmountInUSD;

    }
    function getVersion() internal view returns (uint256){
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return pricefeed.version();
    }
}