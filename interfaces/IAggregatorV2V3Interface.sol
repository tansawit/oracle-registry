// SPDX-License-Identifier: MIT
// Source: https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV2V3Interface.sol
pragma solidity 0.8.2;

import "./IAggregatorInterface.sol";
import "./IAggregatorV3Interface.sol";

interface IAggregatorV2V3Interface is
    IAggregatorInterface,
    IAggregatorV3Interface
{}
