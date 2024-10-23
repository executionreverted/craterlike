import { ethers, upgrades } from "hardhat";
import { World } from "../../typechain-types";
import {} from "@nomiclabs/hardhat-ethers/signers";
import { HardhatEthersSigner } from "@nomicfoundation/hardhat-ethers/signers";

export interface TestContracts {
  core: World;
}

export interface World$ {
  contracts: TestContracts;
  user1: HardhatEthersSigner;
  user2: HardhatEthersSigner;
  deployer: HardhatEthersSigner;
  user1Core: World;
  user2Core: World;
}

export async function initializeContracts(): Promise<TestContracts> {
  const CoreFactory = await ethers.getContractFactory("World");
  const [deployer, user1, user2] = await ethers.getSigners();
  const core: World = (await upgrades.deployProxy(CoreFactory, [
    await deployer.getAddress(),
  ])) as World;

  return {
    core,
  };
}

export async function initializeWorld(): Promise<World$> {
  const contracts = await initializeContracts();
  const [deployer, user1, user2] = await ethers.getSigners();

  return {
    contracts,
    user1,
    user2,
    deployer,
    user1Core: contracts.core.connect(user1),
    user2Core: contracts.core.connect(user2),
  };
}
