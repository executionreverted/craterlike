pragma solidity ^0.8.4;
import {Coords} from "./Coords.sol";
import {TileType} from "../enums/Biomes.sol";

struct Tile {
    Coords coords;
    uint256[2] perlin;
    uint temperature;
    uint radioactivity;
}
