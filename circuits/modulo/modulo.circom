include "../../node_modules/circomlib/circuits/comparators.circom";

template Modulo (n) {
    signal input in;
    signal input divider;
    signal output out;
    signal output quot;
    signal quotient <-- in\divider;
    quot <== quotient;
    out <-- in%divider;

    in === quotient*divider + out;

    component lessThan = LessThan(n);
    lessThan.in[0] <== out;
    lessThan.in[1] <== divider;
    lessThan.out === 1;
}
