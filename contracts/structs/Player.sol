pragma solidity ^0.8.4;
import {Coords} from "./Coords.sol";
struct Player {
    uint level;
    uint exp;
    uint map;
    Coords coords;
    uint encounterChanceBoost;
    uint captureChanceBoost;
}
