// SPDX-License-Identifier: GPL3.0
pragma solidity 0.8.27;

import {Coords} from "../structs/Coords.sol";
import {Tile} from "../structs/Tile.sol";
import {LibPerlinBySeed} from "../lib/LibPerlin.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract World is OwnableUpgradeable {
    function initialize(address _owner) public initializer {
        __Ownable_init(_owner);
    }

    function getWorldSeed() public view returns (uint _seed) {
        _seed = block.timestamp % 1000;
    }

    function getWorldScale() internal pure returns (uint worldScale) {
        worldScale = 25;
    }

    function generatePlotContent(
        Coords memory coords
    ) public view returns (Tile memory _plot) {
        uint seed = getWorldSeed();
        uint ws = getWorldScale();

        uint256 perlin1 = LibPerlinBySeed.computePerlin(
            uint32(coords.x),
            uint32(coords.y),
            uint32(seed),
            uint32(ws)
        );

        uint256 perlin2 = LibPerlinBySeed.computePerlin(
            uint32(coords.x),
            uint32(coords.y),
            uint32(seed + 1),
            uint32(ws)
        );

        uint256 radioactivity = perlin1;
        uint256 temperature = perlin2;
        _plot.perlin[0] = perlin1;
        _plot.perlin[1] = perlin2;
        _plot.temperature = uint256(
            int256(temperature) + (int256(uint(coords.x)) - 25) / 2
        ); // uint256(int256(temperature) + (int256(uint(coords.x)) - 50) / 2);
        _plot.radioactivity = radioactivity;
    }

    // function generateNumberFromCoordsAndSeed(
    //     Coords memory coords
    // ) internal view returns (uint) {
    //     uint random = uint256(
    //         keccak256(
    //             abi.encodePacked(coords.x, coords.y, address(this), uint(1337))
    //         )
    //     );
    //     return random;
    // }

    // function useRandom(
    //     Coords memory coords,
    //     uint seed,
    //     uint modulus
    // ) internal view returns (uint) {
    //     return (generateNumberFromCoordsAndSeed(coords) % modulus) + 1;
    // }
}
