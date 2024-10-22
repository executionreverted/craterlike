import { extendEnvironment, HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";
import "@nomicfoundation/hardhat-chai-matchers";
import "hardhat-contract-sizer";
import "@nomicfoundation/hardhat-ethers";
import "hardhat-circom";
import "hardhat-abi-exporter";
import "hardhat-diamond-abi";
import "@typechain/hardhat";

require("dotenv").config();

const { DEPLOYER_MNEMONIC, DEPLOYER_PK, ADMIN_PUBLIC_ADDRESS } = process.env;
import * as diamondUtils from "./utils/diamond";

const config: HardhatUserConfig = {
  solidity: "0.8.27",
  contractSizer: {
    alphaSort: true,
    runOnCompile: false,
    disambiguatePaths: false,
  },
  networks: {
    local: {
      url: "http://127.0.0.1:8545/",
      accounts: {
        // Same mnemonic used in the .env.example
        mnemonic: "test test test test test test test test test test test junk",
      },
      chainId: 31337,
    },
  },
  typechain: {
    target: "ethers-v6",
    dontOverrideCompile: false, // defaults to false
  },
  diamondAbi: {
    // This plugin will combine all ABIs from any Smart Contract with `Facet` in the name or path and output it as `DarkForest.json`
    name: "DiamondApp",
    include: ["Facet"],
    // We explicitly set `strict` to `true` because we want to validate our facets don't accidentally provide overlapping functions
    strict: true,
    // We use our diamond utils to filter some functions we ignore from the combined ABI
    filter(
      abiElement: unknown,
      index: number,
      abi: unknown[],
      fullyQualifiedName: string
    ) {
      const signature = diamondUtils.toSignature(abiElement);
      return diamondUtils.isIncluded(fullyQualifiedName, signature);
    },
  },
  circom: {
    inputBasePath: "../circuits/",
    ptau: "pot15_final.ptau",
    circuits: [
      {
        name: "move",
        circuit: "move/circuit.circom",
        input: "move/input.json",
        beacon:
          "0000000005060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f",
      },
      {
        name: "biomebase",
        circuit: "biomebase/circuit.circom",
        input: "biomebase/input.json",
        beacon:
          "0000000005060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f",
      },
    ],
  },
};

export default config;
