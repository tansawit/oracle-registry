pragma solidity 0.8.2;

interface ITokenRegistry {
    function getSymbol(address tokenAddress)
        external
        view
        returns (string memory);

    function getAddress(string memory tokenSymbol)
        external
        view
        returns (address);
}
