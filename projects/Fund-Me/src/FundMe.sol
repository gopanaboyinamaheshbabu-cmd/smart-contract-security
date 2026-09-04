//SPDX-License-Identifier:MIT
pragma solidity ^0.8.30;
import {PriceConverter} from "./PriceConverter.sol";
import {
    AggregatorV3Interface
} from "@smartcontractkit/chainlink-evm/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error notOwner();

contract FundMe {
    address private immutable i_owner;
    AggregatorV3Interface private s_PriceFeed;

    constructor(address PriceFeed) {
        i_owner = msg.sender;
        s_PriceFeed = AggregatorV3Interface(PriceFeed);
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner,"must be owner");
        if (msg.sender != i_owner) revert notOwner();

        _;
    }

    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;

    address[] private s_funders;

    mapping(address => uint256) private s_addressToAmount;

    function fund() public payable {
        require(msg.value.getConversionRate(s_PriceFeed) >= MINIMUM_USD, "shouldn't send enough ETH");
        s_funders.push(msg.sender);
        s_addressToAmount[msg.sender] += msg.value;
    }

    function cheaperWithdraw() public onlyOwner {
        address[] memory funders = s_funders;
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            s_addressToAmount[funder] = 0;
        }
        s_funders = new address[](0);
        (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "Call failed");
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmount[funder] = 0;
        }
        s_funders = new address[](0);
        (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "Call failed");
    }

    function getVersion() public view returns (uint256) {
        return PriceConverter.getVersion(s_PriceFeed);
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function getaddressToAmountFunded(address fundingAddress) public view returns (uint256) {
        return s_addressToAmount[fundingAddress];
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }
}
