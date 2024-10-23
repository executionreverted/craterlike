include "../../node_modules/circomlib/circuits/mimcsponge.circom";
include "../../node_modules/circomlib/circuits/comparators.circom";
include "../modulo/modulo.circom";

template Main() {
    signal input playerId;
    signal input nonce;
    signal input hash1;
    signal input hash2;
    signal input timestamp;
    signal input maxMonsterId;
    signal input monsterRoll;
    signal input chanceToFind;
    signal input chanceToCatch;

    signal output player;
    signal output monsterId;
    signal output hash1_;
    signal output hash2_;
    signal output catchHash;
    signal output success;

    hash1_<==hash1;
    hash2_<==hash2;
    player <== playerId;

    signal roll;
    component rng = Modulo();
    rng.in <== hash1;
    rng.divider <== 100000;
    roll <== rng.out;

    component monsterMimc = MiMCSponge(4, 100, 1);
    monsterMimc.ins[0] <== chanceToFind;
    monsterMimc.ins[1] <== hash1;
    monsterMimc.ins[2] <== hash2;
    monsterMimc.ins[3] <== rng.out;
    monsterMimc.k <== hash1+timestamp;

    component rng2 = Modulo();
    rng2.in <== monsterMimc.outs[0];
    rng2.divider <== maxMonsterId;
    monsterRoll === rng2.out;
    monsterId <== monsterRoll;


    // catch rng
    component monsterCatchMimc = MiMCSponge(4, 100, 1);
    monsterCatchMimc.ins[0] <== hash2;
    monsterCatchMimc.ins[1] <== monsterId + maxMonsterId;
    monsterCatchMimc.ins[2] <== hash1;
    monsterCatchMimc.ins[3] <== rng.out;
    monsterCatchMimc.k <== hash2+timestamp;
    catchHash <== monsterCatchMimc.outs[0];

    signal roll2;
    component rng3 = Modulo();
    rng3.in <== monsterCatchMimc.outs[0];
    rng3.divider <== 1000;
    roll2 <== rng3.out;

    component rollLt = LessThan(64);
    rollLt.in[0] <== roll2;
    rollLt.in[1] <== chanceToCatch;
    success <== rollLt.out;
}

component main = Main();
