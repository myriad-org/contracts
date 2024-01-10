// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.7;

import {Test, console} from "forge-std/Test.sol";
import {Myriad} from "src/core/Myriad.sol";
import {DataTypes} from "src/libraries/DataTypes.sol";
import {Events} from "src/libraries/Events.sol";

contract MyriadTest is Test {
    Myriad myriad;

    function setUp() external {
        myriad = new Myriad();
    }

    // Patient Registration
    DataTypes.PatientStruct samplePatient =
        DataTypes.PatientStruct(
            "Edward Mark",
            address(0x1),
            1031561212, // dob
            "1235467809", //
            "O+",
            "0x1234567890", // public key
            block.timestamp,
            new string[](0),
            new string[](0),
            new string[](0),
            new string[](0)
        );

    function test_RevertPatientCannotBeRegistered() external {
        vm.startPrank(address(0x1));

        vm.expectEmit(true, true, true, true);

        emit Events.PublicKeyListed(
            samplePatient.patientAddress,
            samplePatient.publicKey
        );

        vm.expectEmit(true, true, true, true);

        emit Events.PatientListed(samplePatient);

        myriad.registerPatient(
            samplePatient.patientAddress,
            samplePatient.name,
            samplePatient.dob,
            samplePatient.phoneNumber,
            samplePatient.bloodGroup,
            samplePatient.publicKey
        );

        vm.stopPrank();
    }
}
