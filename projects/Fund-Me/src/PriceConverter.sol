// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
import {
    AggregatorV3Interface
} from "@smartcontractkit/chainlink-evm/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(AggregatorV3Interface s_PriceFeed) internal view returns (uint256) {
        //Address:0x694AA1769357215DE4FAC081bf1f309aDC325306
        //ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(s_PriceFeed);
        (, int256 price,,,) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount, AggregatorV3Interface s_PriceFeed) internal view returns (uint256) {
        uint256 ethPrice = getPrice(s_PriceFeed);
        uint256 ethAmountInUsd = (ethAmount * ethPrice) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion(AggregatorV3Interface s_PriceFeed) internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(s_PriceFeed);
        return priceFeed.version();
    }
}
