#!/bin/bash

# Print the current directory
echo "Current directory: $(pwd)"

# Loop through each subdirectory
for dir in */; do
    # Check if the directory actually exists
    if [ -d "$dir" ]; then
        echo "Found directory: $dir"

        # Change to the subdirectory
        cd "$dir" || { echo "Failed to enter directory $dir"; continue; }

        # Check for the presence of the required file
        if [ -f "circuit.circom" ]; then
            echo "Running commands in $dir"

            if circom circuit.circom --r1cs --wasm --sym && \
               npx snarkjs r1cs info circuit.r1cs && \
               npx snarkjs zkey new circuit.r1cs ../pot15_final.ptau circuit_init.zkey && \
               npx snarkjs zkey contribute circuit_init.zkey circuit.zkey -e="$(date)" && \
               npx snarkjs zkey export verificationkey circuit.zkey verification_key.json && \
               npx snarkjs zkey export solidityverifier circuit.zkey verifier.sol; then
                echo "Commands executed successfully in $dir"
            else
                echo "Error running commands in $dir"
            fi
        else
            echo "No circuit.circom file in $dir, skipping."
        fi

        # Change back to the parent directory
        cd .. || { echo "Failed to return to parent directory"; exit 1; }
    else
        echo "$dir is not a valid directory."
    fi
done
