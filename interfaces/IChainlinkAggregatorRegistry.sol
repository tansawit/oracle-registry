pragma solidity 0.8.2;

interface IChainlinkAggregatorRegistry {
    enum AggregatorType {
        Native,
        USD
    }

    function nativeType() external view returns (AggregatorType);

    function usdType() external view returns (AggregatorType);

    function getAggregator(AggregatorType aggregatorType, address tokenAddress)
        external
        view
        returns (address);
}
