// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.7;

import {Test, console} from "forge-std/Test.sol";
import {Myriad} from "src/core/Myriad.sol";
import {DataTypes} from "src/libraries/DataTypes.sol";
import {Events} from "src/libraries/Events.sol";

/* @note For Testing Purposes
 * Patient Address: starts from 1
 * Doctor Address: starts from 11
 * Hospital Address: starts from 21
 */

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

    // Add Doctor

    DataTypes.DoctorStruct sampleDoctor =
        DataTypes.DoctorStruct(
            address(0x11),
            "Dr. Edward Mark",
            "1235467809",
            block.timestamp,
            "Cardiologist",
            address(0x21)
        );

    function test_RevertDoctorCannotBeAdded() external {
        vm.expectEmit(true, true, true, true);

        emit Events.DoctorListed(sampleDoctor);

        myriad.addDoctorDetails(
            sampleDoctor.doctorAddress,
            sampleDoctor.name,
            sampleDoctor.doctorRegistrationId,
            sampleDoctor.specialization,
            sampleDoctor.hospitalAddress
        );
    }

    // Add Hospital

    DataTypes.HospitalStruct sampleHospital =
        DataTypes.HospitalStruct(
            "Apollo Hospital",
            address(0x21),
            block.timestamp,
            "9345673430",
            "contactus@apollo.com",
            "9876543210"
        );

    function test_RevertHospitalCannotBeAdded() external {
        vm.expectEmit(true, true, true, true);

        emit Events.HospitalListed(sampleHospital);

        myriad.addHospitalDetails(
            sampleHospital.hospitalAddress,
            sampleHospital.name,
            sampleHospital.hospitalRegistrationId,
            sampleHospital.email,
            sampleHospital.phoneNumber
        );
    }

    // Add DiagnosticLab

    DataTypes.DiagnosticLabStruct sampleDiagnosticLab =
        DataTypes.DiagnosticLabStruct(
            address(0x31),
            "Apollo Diagnostic Lab",
            "1235467809",
            block.timestamp,
            "cardiodiag@apollo.com",
            "9876543210"
        );

    function test_RevertDiagnosticLabCannotBeAdded() external {
        vm.expectEmit(true, true, true, true);

        emit Events.DiagnosticLabListed(sampleDiagnosticLab);

        myriad.addDiagnosticLabDetails(
            sampleDiagnosticLab.diagnosticLabAddress,
            sampleDiagnosticLab.name,
            sampleDiagnosticLab.diagnosticLabRegistrationId,
            sampleDiagnosticLab.email,
            sampleDiagnosticLab.phoneNumber
        );
    }

    // Add Clinic

    DataTypes.ClinicStruct sampleClinic =
        DataTypes.ClinicStruct(
            address(0x41),
            "Apollo Clinic",
            "1235467809",
            block.timestamp,
            "apolloclinic@apollo.com",
            "9876543210"
        );

    function test_RevertClinicCannotBeAdded() external {
        vm.expectEmit(true, true, true, true);

        emit Events.ClinicListed(sampleClinic);

        myriad.addClinicDetails(
            sampleClinic.clinicAddress,
            sampleClinic.name,
            sampleClinic.clinicRegistrationId,
            sampleClinic.email,
            sampleClinic.phoneNumber
        );
    }

    // Add Patient Details:
    address patientAddress = samplePatient.patientAddress;
    uint16 category = 0;
    string ipfsHash = "qmazkcwaekwedrtnvfhrxabyewtjdxhnjpl1uykybe5zab";

    // function test_RevertPatientDetailsCannotBeAdded() external {}
}
