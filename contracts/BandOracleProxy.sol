pragma solidity 0.8.2;

import "../interfaces/ITokenRegistry.sol";
import "../interfaces/IStdReference.sol";
import "../interfaces/IBaseOracle.sol";
import "OpenZeppelin/openzeppelin-contracts@4.1.0/contracts/access/AccessControl.sol";

contract BandOracleProxy is IBaseOracle, AccessControl {
    ITokenRegistry public tokenRegistry;
    IStdReference public stdRef;

    bytes32 public constant MAPPER_ROLE = keccak256("MAPPER_ROLE");

    constructor(ITokenRegistry _tokenRegistry, IStdReference _stdRef) public {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MAPPER_ROLE, msg.sender);

        tokenRegistry = _tokenRegistry;
        stdRef = _stdRef;
    }

    function setTokenRegistry(ITokenRegistry _tokenRegistry) external {
        require(hasRole(MAPPER_ROLE, msg.sender), "NOT_A_MAPPER");
        tokenRegistry = _tokenRegistry;
    }

    function setRef(IStdReference _stdRef) external {
        require(hasRole(MAPPER_ROLE, msg.sender), "NOT_A_MAPPER");
        stdRef = _stdRef;
    }

    function getPrice(address baseToken, address quoteToken)
        public
        view
        override
        returns (uint256)
    {
        IStdReference.ReferenceData memory data = stdRef.getReferenceData(
            tokenRegistry.getSymbol(baseToken),
            tokenRegistry.getSymbol(quoteToken)
        );
        return data.rate;
    }
}
