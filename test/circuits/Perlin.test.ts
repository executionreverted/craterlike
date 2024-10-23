import { expect } from "chai";
import { exportCallDataGroth16 } from "../../utils/exportCallDataGroth16";
import { ethers } from "ethers";
import { MonsterListMock } from "../utils/MonkMonsterList";

describe("TinyWorld", function () {
  beforeEach(async function () {});

  it("should perlin work", async function () {
    let wasmCircuitPath = "./circuits/move/circuit_js/circuit.wasm";
    let zkeyCircuit = "./circuits/move/circuit.zkey";

    let catchWasmCircuitPath = "./circuits/catch/circuit_js/circuit.wasm";
    let catchZkeyCircuit = "./circuits/catch/circuit.zkey";

    let Grid = [];
    var startX = 0;
    var startY = 0;
    var endX = 20;
    var endY = 20;
    let nonce = 1;
    for (let x = startX; x < endX; x++) {
      let plots = ``;
      for (let y = startY; y < endY; y++) {
        let inputData = {
          playerId: 0,
          nonce,
          x1: x,
          y1: y,
          x2: x + 1,
          y2: y + 1,
          timestamp: Date.now(),
          r: 1,
          distMax: 1,
          chanceToFind: 10000,
          maxMonsterId: 100, // x/100.000
        };

        let movement = await exportCallDataGroth16(
          inputData,
          wasmCircuitPath,
          zkeyCircuit
        );

        const m = movement[3];
        const [
          hash1,
          hash2,
          time,
          newX,
          newY,
          playerId_,
          nonce_,
          encounterChance,
          is_encounter,
          roll,
          monsterRoll,
        ] = m;
        const modulo = BigInt(hash1) % BigInt(100000);
        // const hasValue = modulo <= BigInt(encounterChance);
        console.log(
          `Moved to ${newX},${newY}, ${new Date(time * 1).toUTCString()}`
        );
        if (parseInt(is_encounter) == 1) {
          console.log(
            `Player${playerId_} encountered a monster (${MonsterListMock[monsterRoll]}) on X: ${newX},${newY}`
          );

          let catchInput = {
            playerId: 0,
            nonce,
            hash1: hash1,
            hash2: hash2,
            timestamp: inputData.timestamp,
            maxMonsterId: inputData.maxMonsterId,
            monsterRoll, // x/100.000
            chanceToFind: inputData.chanceToFind,
            chanceToCatch: 500, // x1000
          };

          console.log(
            `Player${playerId_} attempts to catch...  -> ${MonsterListMock[monsterRoll]}`
          );
          let catch_ = await exportCallDataGroth16(
            catchInput,
            catchWasmCircuitPath,
            catchZkeyCircuit
          );

          const c = catch_[3];
          const [player, monsterId, hash1_, hash2_, catchHash, success] = c;
          if (parseInt(success) == 1) {
            console.log(
              `Player${player} catched ${MonsterListMock[monsterId]}!`
            );
          } else {
            console.log("Failed to catch... with 50% chance!");
          }
        }
        nonce++;

        // plots += `${plot} `;
        // let dataResult = await exportCallDataGroth16(input, wasmCircuitPath, zkeyCircuit)
        // let biomeInput = {
        //   x: x,
        //   y: y,
        //   PLANETHASH_KEY: 7,
        //   BIOMEBASE_KEY: 8,
        //   SCALE: 4096,
        //   xMirror: 0,
        //   yMirror: 0,
        // };

        // let revealInput = {
        //   x: x,
        //   y: y,
        //   PLANETHASH_KEY: 7,
        //   SPACETYPE_KEY: 7,
        //   SCALE: 4096,
        //   xMirror: 0,
        //   yMirror: 0,
        // };
      }

      // let biome = await exportCallDataGroth16(
      //   biomeInput,
      //   biomeWasm,
      //   biomeZkey
      // );

      // let reveal = await exportCallDataGroth16(
      //   revealInput,
      //   revealWasm,
      //   revealZkey
      // );
      // const b = biome[3];
      // const r = reveal[3];
      // console.log("reveal: ", r);

      Grid.push(plots);
    }
    // Grid.forEach((g) => console.log(g));
  });
});
