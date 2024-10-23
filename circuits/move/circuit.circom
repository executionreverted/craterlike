include "../../node_modules/circomlib/circuits/mimcsponge.circom";
include "../../node_modules/circomlib/circuits/comparators.circom";
include "../modulo/modulo.circom";

template Main() {
    signal input playerId;
    signal input nonce;
    signal input x1;
    signal input y1;
    signal input x2;
    signal input y2;
    signal input timestamp;
    signal input r;
    signal input distMax;
    signal input chanceToFind;
    signal input maxMonsterId;

    signal output hash1;
    signal output hash2;
    signal output time;
    signal output newX;
    signal output newY;
    signal output playerId_;
    signal output nonce_;
    signal output encounterChance;
    signal output isEncounter;
    signal output roll;
    signal output monsterRoll;
    time <== timestamp;
    encounterChance<== chanceToFind;


    component isZero = IsZero();
    isZero.in <== distMax;
    isZero.out === 0;

    /* check (x2-x1)^2 + (y2-y1)^2 <= distMax^2 */

    signal diffX;
    diffX <== x2 - x1;
    signal diffY;
    diffY <== y2 - y1;

    component ltDist = LessEqThan(64);
    signal firstDistSquare;
    signal secondDistSquare;
    firstDistSquare <== diffX * diffX;
    secondDistSquare <== diffY * diffY;
    ltDist.in[0] <== firstDistSquare + secondDistSquare;
    ltDist.in[1] <== distMax * distMax + 1;
    ltDist.out === 1;

    // generate hashes for psuedo rng
    component mimc1 = MiMCSponge(3, 100, 1);
    component mimc2 = MiMCSponge(3, 100, 1);

    mimc1.ins[0] <== x1;
    mimc1.ins[1] <== y1;
    mimc1.ins[2] <== timestamp;
    mimc1.k <== timestamp;
    mimc2.ins[0] <== x2;
    mimc2.ins[1] <== y2;
    mimc2.ins[2] <== timestamp;
    mimc2.k <== timestamp;

    hash1 <== mimc1.outs[0];
    hash2 <== mimc2.outs[0];
    newX <== x2;
    newY <== y2;

    // is encounter
    component rng = Modulo();
    rng.in <== hash1;
    rng.divider <== 100000;
    roll <== rng.out;

    component rollLt = LessThan(64);
    rollLt.in[0] <== roll;
    rollLt.in[1] <== chanceToFind;
    isEncounter <== rollLt.out;

    // pick monster

    component monsterMimc = MiMCSponge(4, 100, 1);
    monsterMimc.ins[0] <== chanceToFind;
    monsterMimc.ins[1] <== hash1;
    monsterMimc.ins[2] <== hash2;
    monsterMimc.ins[3] <== rng.out;
    monsterMimc.k <== hash1+timestamp;

    component rng2 = Modulo();
    rng2.in <== monsterMimc.outs[0];
    rng2.divider <== maxMonsterId;
    monsterRoll <== rng2.out;
}

component main = Main();
