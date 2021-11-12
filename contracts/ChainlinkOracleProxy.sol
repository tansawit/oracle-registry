pragma solidity 0.8.2;

import "./library/Denominations.sol";
import "../interfaces/IBaseOracle.sol";
import "../interfaces/IFeedRegistryInterface.sol";
import "OpenZeppelin/openzeppelin-contracts@4.1.0/contracts/access/AccessControl.sol";

contract ChainlinkOracleProxy is IBaseOracle, AccessControl {
    IFeedRegistryInterface feedRegistry;

    bytes32 public constant MAPPER_ROLE = keccak256("MAPPER_ROLE");

    constructor(IFeedRegistryInterface _feedRegistry) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MAPPER_ROLE, msg.sender);

        feedRegistry = _feedRegistry;
    }

    function setFeedRegistry(IFeedRegistryInterface _feedRegistry) external {
        require(hasRole(MAPPER_ROLE, msg.sender), "NOT_A_MAPPER");
        feedRegistry = _feedRegistry;
    }

    function getPrice(address baseToken, address quoteToken)
        public
        view
        override
        returns (uint256)
    {
        (, int256 basePrice, , uint256 baseTimestamp, ) = feedRegistry
            .latestRoundData(baseToken, Denominations.USD);
        uint8 baseDecimals = feedRegistry.decimals(
            baseToken,
            Denominations.USD
        );

        (, int256 quotePrice, , uint256 quoteTimestamp, ) = feedRegistry
            .latestRoundData(quoteToken, Denominations.USD);
        uint8 quoteDecimals = feedRegistry.decimals(
            quoteToken,
            Denominations.USD
        );

        return
            ((uint256(basePrice) * 10**quoteDecimals) * 1e18) /
            (uint256(quotePrice) * 10**baseDecimals);
    }
}
