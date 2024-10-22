// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

enum TileType {
    UNKNOWN,
    LAVA_A,
    LAVA_B,
    SAND,
    TREE,
    STUMP,
    CHEST,
    FARM,
    WINDMILL,
    GRASS,
    SNOW,
    STONE,
    ICE
}

enum TemperatureType {
    COLD,
    NORMAL,
    HOT
}

enum AltitudeType {
    SEA,
    BEACH,
    LAND,
    MOUNTAIN,
    MOUNTAINTOP
}
