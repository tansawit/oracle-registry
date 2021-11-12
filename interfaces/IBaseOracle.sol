// SPDX-License-Identifier: MIT
pragma solidity 0.8.2;

interface IBaseOracle {
    function getPrice(address baseToken, address quoteToken)
        external
        view
        returns (uint256);
}
