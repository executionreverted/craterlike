import { expect } from "chai";
import { initializeWorld, World$ } from "./utils/InitWorld.test";
import { TileStruct } from "../typechain-types/contracts/app/World";

describe("TinyWorld", function () {
  let world: World$;

  beforeEach(async function () {
    world = await initializeWorld();
  });

  it("should set admin address correctly", async function () {
    const deployerAddress = await world.deployer?.getAddress();
    const adminAddress = await world.contracts.core.owner();
    expect(deployerAddress).to.equal(adminAddress);
  });

  it("should render map", async function () {
    let Grid = [];
    var startX = 10;
    var startY = 10;
    var endX = 30;
    var endY = 30;
    for (let x = startX; x < endX; x++) {
      let plots = ``;
      for (let y = startY; y < endY; y++) {
        let plot = await world.contracts.core.generatePlotContent({ x, y });
        plots += `${plot[3]} `;
        // let dataResult = await exportCallDataGroth16(input, wasmCircuitPath, zkeyCircuit)
      }

      Grid.push(plots);
    }
    Grid.forEach((g) => console.log(g));
  });
});
