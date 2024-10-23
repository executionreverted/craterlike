// SPDX-License-Identifier: GPL3.0
pragma solidity 0.8.27;

import {Player} from "../structs/Player.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Trainers is OwnableUpgradeable {
    mapping(address => Player) public players;

    function initialize(address _owner) public initializer {
        __Ownable_init(_owner);
    }
}
