// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier {
    // Scalar field size
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 19642524115522290447760970021746675789341356000653265441069630957431566301675;
    uint256 constant alphay  = 15809037446102219312954435152879098683824559980020626143453387822004586242317;
    uint256 constant betax1  = 6402738102853475583969787773506197858266321704623454181848954418090577674938;
    uint256 constant betax2  = 3306678135584565297353192801602995509515651571902196852074598261262327790404;
    uint256 constant betay1  = 15158588411628049902562758796812667714664232742372443470614751812018801551665;
    uint256 constant betay2  = 4983765881427969364617654516554524254158908221590807345159959200407712579883;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 15833082008092018860812256808996574049828823853955964024619891481277050836277;
    uint256 constant deltax2 = 8019111958197910464399656843223889716108660860382741221312429509481841654477;
    uint256 constant deltay1 = 14157151571750461522656021906828182768312640867018414314779169802572623657198;
    uint256 constant deltay2 = 13960010322484131141138686413485362303394421076493776526776955233791098986861;

    
    uint256 constant IC0x = 5744203484752763943569487741481555386999407655082093785851941988479497377154;
    uint256 constant IC0y = 20199936358423216071542944201123293265486853168240726948454945178515020486205;
    
    uint256 constant IC1x = 7580465920134936821543810474413028239746288237910453521793519623658533625615;
    uint256 constant IC1y = 15041856462705830796667360875086458408782862296959996817524721993184572003350;
    
    uint256 constant IC2x = 374299172432630074464024284824487215746009292467613232000184737779141808600;
    uint256 constant IC2y = 7887095359913846286623525407937955859488252479137096040159274898909269994494;
    
    uint256 constant IC3x = 2905267900295692797399505027896904134058336493058481903897546871604416234871;
    uint256 constant IC3y = 7773419696666735542927560961342456326029784842014959936219607705431333585905;
    
    uint256 constant IC4x = 16763036132884454150898077035665975323001631422734364242697626605862265783618;
    uint256 constant IC4y = 17825703693037057754623267555408871742638630180194340595225066502987619269649;
    
    uint256 constant IC5x = 4466249765068368213001139165333541366194509975091414013293887125950581990700;
    uint256 constant IC5y = 12815207904731188800329770044756136478049578187276184585815676338042379222211;
    
    uint256 constant IC6x = 3252384707827610987973825104252958670026226560272621430891313587475799922804;
    uint256 constant IC6y = 20682761915635402249445821723339047128185104611742788237709139302636777030188;
    
    uint256 constant IC7x = 17428875291644943548799377629406738525333655689326001600352747342597064649077;
    uint256 constant IC7y = 4059487221929148448489949294794527809058747605351539066605642342129207335687;
    
    uint256 constant IC8x = 7804132467223051338084204194135740853529731253358954448810338782804250706347;
    uint256 constant IC8y = 21191330855324836593601727070630471858771288278315208601101522089331763390980;
    
    uint256 constant IC9x = 20718525430722257688700682975400850332029511204541047393858635938552264090501;
    uint256 constant IC9y = 13326746536873204724783995465622847500136542235195996097320211772244887492636;
    
    uint256 constant IC10x = 3332767602729611286530353059684533107190216643503518620622591269438219603492;
    uint256 constant IC10y = 14950406375721168189692009956932459938364978304035619658488250765224534849661;
    
    uint256 constant IC11x = 20304355973563020848301618506302090201696924884105740714513027381587258706064;
    uint256 constant IC11y = 6899167967385452854737100319233131489916993247965448658706912540246768570686;
    
    uint256 constant IC12x = 9655152995055626987944552541311274861108529486308580552158667149837116284847;
    uint256 constant IC12y = 20364766397614558172907431510896481083285017453129569694341598453672453625910;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[12] calldata _pubSignals) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, r)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }
            
            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pPairing := add(pMem, pPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x
                
                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
                
                g1_mulAccC(_pVk, IC2x, IC2y, calldataload(add(pubSignals, 32)))
                
                g1_mulAccC(_pVk, IC3x, IC3y, calldataload(add(pubSignals, 64)))
                
                g1_mulAccC(_pVk, IC4x, IC4y, calldataload(add(pubSignals, 96)))
                
                g1_mulAccC(_pVk, IC5x, IC5y, calldataload(add(pubSignals, 128)))
                
                g1_mulAccC(_pVk, IC6x, IC6y, calldataload(add(pubSignals, 160)))
                
                g1_mulAccC(_pVk, IC7x, IC7y, calldataload(add(pubSignals, 192)))
                
                g1_mulAccC(_pVk, IC8x, IC8y, calldataload(add(pubSignals, 224)))
                
                g1_mulAccC(_pVk, IC9x, IC9y, calldataload(add(pubSignals, 256)))
                
                g1_mulAccC(_pVk, IC10x, IC10y, calldataload(add(pubSignals, 288)))
                
                g1_mulAccC(_pVk, IC11x, IC11y, calldataload(add(pubSignals, 320)))
                
                g1_mulAccC(_pVk, IC12x, IC12y, calldataload(add(pubSignals, 352)))
                

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

                // B
                mstore(add(_pPairing, 64), calldataload(pB))
                mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pPairing, 192), alphax)
                mstore(add(_pPairing, 224), alphay)

                // beta2
                mstore(add(_pPairing, 256), betax1)
                mstore(add(_pPairing, 288), betax2)
                mstore(add(_pPairing, 320), betay1)
                mstore(add(_pPairing, 352), betay2)

                // vk_x
                mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))


                // gamma2
                mstore(add(_pPairing, 448), gammax1)
                mstore(add(_pPairing, 480), gammax2)
                mstore(add(_pPairing, 512), gammay1)
                mstore(add(_pPairing, 544), gammay2)

                // C
                mstore(add(_pPairing, 576), calldataload(pC))
                mstore(add(_pPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pPairing, 640), deltax1)
                mstore(add(_pPairing, 672), deltax2)
                mstore(add(_pPairing, 704), deltay1)
                mstore(add(_pPairing, 736), deltay2)


                let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)

                isOk := and(success, mload(_pPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F
            
            checkField(calldataload(add(_pubSignals, 0)))
            
            checkField(calldataload(add(_pubSignals, 32)))
            
            checkField(calldataload(add(_pubSignals, 64)))
            
            checkField(calldataload(add(_pubSignals, 96)))
            
            checkField(calldataload(add(_pubSignals, 128)))
            
            checkField(calldataload(add(_pubSignals, 160)))
            
            checkField(calldataload(add(_pubSignals, 192)))
            
            checkField(calldataload(add(_pubSignals, 224)))
            
            checkField(calldataload(add(_pubSignals, 256)))
            
            checkField(calldataload(add(_pubSignals, 288)))
            
            checkField(calldataload(add(_pubSignals, 320)))
            
            checkField(calldataload(add(_pubSignals, 352)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
