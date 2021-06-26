pragma solidity 0.8.2;

import "../interfaces/IChainlinkAggregatorRegistry.sol";
import "../interfaces/IAggregatorV3Interface.sol";
import "../interfaces/IBaseOracle.sol";
import "OpenZeppelin/openzeppelin-contracts@4.1.0/contracts/access/AccessControl.sol";

contract ChainlinkOracleProxy is IBaseOracle, AccessControl {
    IChainlinkAggregatorRegistry aggregatorRegistry;

    bytes32 public constant MAPPER_ROLE = keccak256("MAPPER_ROLE");

    constructor(IChainlinkAggregatorRegistry _aggregatorRegistry) public {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MAPPER_ROLE, msg.sender);

        aggregatorRegistry = _aggregatorRegistry;
    }

    function setAggregatorRegistry(
        IChainlinkAggregatorRegistry _aggregatorRegistry
    ) external {
        require(hasRole(MAPPER_ROLE, msg.sender), "NOT_A_MAPPER");
        aggregatorRegistry = _aggregatorRegistry;
    }

    function getAggregatorAddress(address tokenAddress)
        public
        view
        returns (address aggregatorAddress)
    {
        (bool ok, bytes memory data) = address(aggregatorRegistry).staticcall(
            abi.encodeWithSignature(
                "getAggregator(address,uint8)",
                tokenAddress,
                aggregatorRegistry.usdType()
            )
        );
        aggregatorAddress = abi.decode(data, (address));
    }

    function getRawPriceData(address tokenAddress)
        public
        view
        returns (uint256, uint8)
    {
        if (tokenAddress == address(1)) {
            return (1e9, uint8(9));
        }

        IAggregatorV3Interface aggregator = IAggregatorV3Interface(
            getAggregatorAddress(tokenAddress)
        );
        (, int256 baseAnswer, , , ) = aggregator.latestRoundData();
        uint8 baseDecimals = aggregator.decimals();

        return (uint256(baseAnswer), baseDecimals);
    }

    function getPrice(address baseToken, address quoteToken)
        public
        view
        override
        returns (uint256)
    {
        (uint256 baseAnswer, uint8 baseDecimals) = getRawPriceData(baseToken);
        (uint256 quoteAnswer, uint8 quoteDecimals) = getRawPriceData(
            quoteToken
        );

        return
            ((uint256(baseAnswer) * 10**quoteDecimals) * 1e18) /
            (uint256(quoteAnswer) * 10**baseDecimals);
    }
}
