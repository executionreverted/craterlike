import { expect } from "chai";
import { exportCallDataGroth16 } from "../../utils/exportCallDataGroth16";

describe("TinyWorld", function () {
  beforeEach(async function () {});

  it("should perlin work", async function () {
    let wasmCircuitPath = "./circuits/move/circuit_js/circuit.wasm";
    let zkeyCircuit = "./circuits/move/circuit.zkey";

    let biomeWasm = "./circuits/biomebase/circuit_js/circuit.wasm";
    let biomeZkey = "./circuits/biomebase/circuit.zkey";

    let revealWasm = "./circuits/reveal/circuit_js/circuit.wasm";
    let revealZkey = "./circuits/reveal/circuit.zkey";

    // let dataResult = await exportCallDataGroth16(
    //   inputData,
    //   wasmCircuitPath,
    //   zkeyCircuit
    // );

    let Grid = [];
    var startX = 0;
    var startY = 0;
    var endX = 5;
    var endY = 5;
    for (let x = startX; x < endX; x++) {
      let plots = ``;
      for (let y = startY; y < endY; y++) {
        // let inputData = {
        //   x: "1764",
        //   y: "21888242871839275222246405745257275088548364400416034343698204186575808492485",
        //   PLANETHASH_KEY: 7,
        //   BIOMEBASE_KEY: 8,
        //   SCALE: 4096,
        //   xMirror: 0,
        //   yMirror: 0,
        // };

        // let inputData = {
        //   p: [x, y],
        //   KEY: 9,
        //   SCALE: 4096,
        //   xMirror: 0,
        //   yMirror: 0,
        // };
        let inputData = {
          x1: x,
          y1: y,
          x2: x + 1,
          y2: y + 1,
          r: 5000,
          distMax: 2,
          PLANETHASH_KEY: 7,
          SPACETYPE_KEY: 7,
          SCALE: 4096,
          xMirror: 0,
          yMirror: 0,
        };

        let biomeInput = {
          x: x,
          y: y,
          PLANETHASH_KEY: 7,
          BIOMEBASE_KEY: 8,
          SCALE: 4096,
          xMirror: 0,
          yMirror: 0,
        };

        let revealInput = {
          x: x,
          y: y,
          PLANETHASH_KEY: 7,
          SPACETYPE_KEY: 7,
          SCALE: 4096,
          xMirror: 0,
          yMirror: 0,
        };

        let movePerlin = await exportCallDataGroth16(
          inputData,
          wasmCircuitPath,
          zkeyCircuit
        );
        let biome = await exportCallDataGroth16(
          biomeInput,
          biomeWasm,
          biomeZkey
        );

        let reveal = await exportCallDataGroth16(
          revealInput,
          revealWasm,
          revealZkey
        );

        const m = movePerlin[3];
        const modulo = Math.floor(m[2] % 1000);
        console.log("move perlin: ", m[2], m[2] % 1000);
        const hasPlanet = modulo <= 20;
        if (hasPlanet) {
          console.log("PLANET FOUND");
        }
        const b = biome[3];
        console.log("biome hash: ", b[0]);
        console.log("biome base: ", b[1]);
        const r = reveal[3];
        console.log("reveal: ", r);

        // plots += `${plot} `;
        // let dataResult = await exportCallDataGroth16(input, wasmCircuitPath, zkeyCircuit)
      }

      Grid.push(plots);
    }
    // Grid.forEach((g) => console.log(g));
  });
});
