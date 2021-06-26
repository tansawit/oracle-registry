pragma solidity 0.8.2;

import "../interfaces/IBaseOracle.sol";

contract OracleRegistryBase {
    enum OracleType {
        Band,
        Chainlink
    }

    OracleType public bandOracleType = OracleType.Band;
    OracleType public chainlinkOracleType = OracleType.Chainlink;

    IBaseOracle bandOracle;
    IBaseOracle chainlinkOracle;

    constructor(IBaseOracle _bandOracle, IBaseOracle _chainlinkOracle) public {
        bandOracle = _bandOracle;
        chainlinkOracle = _chainlinkOracle;
    }

    function getOraclePrice(
        address baseToken,
        address quoteToken,
        OracleType oracleType
    ) external view returns (uint256) {
        if (oracleType == bandOracleType) {
            return bandOracle.getPrice(baseToken, quoteToken);
        } else if (oracleType == chainlinkOracleType) {
            return chainlinkOracle.getPrice(baseToken, quoteToken);
        }
    }
}
