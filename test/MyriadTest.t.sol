// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.7;

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Test, console} from "forge-std/Test.sol";
import {Myriad} from "src/core/Myriad.sol";
import {DataTypes} from "src/libraries/DataTypes.sol";
import {Events} from "src/libraries/Events.sol";
import {GovernanceToken} from "../src/governance/GovernanceToken.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

// import {IERC721} from "./IERC721.sol";

/* @note For Testing Purposes
 * Patient Address: starts from 1
 * Doctor Address: starts from 11
 * Hospital Address: starts from 21
 * Diagnostic Lab Address: starts from 31
 * Clinic Address: starts from 41
 */

contract MyriadTest is Test {
    // Myriad myriad;
    // ERC1967Proxy proxy;
    address proxy;

    address governanceTokenAddress =
        DevOpsTools.get_most_recent_deployment(
            "GovernanceToken",
            block.chainid
        );

    function setUp() external {
        Myriad myriad = new Myriad();
        proxy = address(new ERC1967Proxy(address(myriad), ""));
        Myriad(proxy).initialize(governanceTokenAddress);
    }

    // Patient Registration
    DataTypes.PatientStruct samplePatient =
        DataTypes.PatientStruct(
            address(0x1),
            "test-patient-ipfs-info",
            block.timestamp,
            true
        );

    // function test_RevertPatientCannotBeRegistered() external {
    //     vm.startPrank(address(0x1));

    //     vm.expectEmit(true, true, true, true);
    //     emit Events.PublicKeyListed(
    //         samplePatient.patientAddress,
    //         samplePatient.publicKey
    //     );
    //     vm.expectEmit(true, true, true, true);
    //     emit Events.PublicKeyListed(
    //         samplePatient.patientAddress,
    //         samplePatient.publicKey
    //     );

    //     vm.expectEmit(true, true, true, true);
    //     emit Events.PatientListed(samplePatient);
    //     vm.expectEmit(true, true, true, true);
    //     emit Events.PatientListed(samplePatient);

    //     vm.expectEmit();
    //     emit Transfer(address(0x1), address(0x1), 1);

    //     vm.expectEmit(true, true, true, true);
    //     emit Events.GovernanceTokenMinted(samplePatient.patientAddress, 1);

    //     Myriad(proxy).registerPatient(
    //         GovernanceToken(makeAddr("governanceToken")),
    //         samplePatient.patientAddress,
    //         samplePatient.name,
    //         samplePatient.dob,
    //         samplePatient.phoneNumber,
    //         samplePatient.bloodGroup,
    //         samplePatient.publicKey
    //     );
    //     vm.expectEmit();
    //     emit Transfer(address(0x1), address(0x1), 1);

    //     vm.expectEmit(true, true, true, true);
    //     emit Events.GovernanceTokenMinted(samplePatient.patientAddress, 1);

    //     Myriad(proxy).registerPatient(
    //         GovernanceToken(makeAddr("governanceToken")),
    //         samplePatient.patientAddress,
    //         samplePatient.name,
    //         samplePatient.dob,
    //         samplePatient.phoneNumber,
    //         samplePatient.bloodGroup,
    //         samplePatient.publicKey
    //     );

    //     vm.stopPrank();
    // }

    // Add Doctor

    DataTypes.DoctorStruct sampleDoctor =
        DataTypes.DoctorStruct(
            address(0x11),
            "test-doctor-ipfs-info",
            block.timestamp,
            true
        );

    // function test_RevertDoctorCannotBeAdded() external {
    //     vm.expectEmit(true, true, true, true);
    // function test_RevertDoctorCannotBeAdded() external {
    //     vm.expectEmit(true, true, true, true);

    //     emit Events.DoctorListed(sampleDoctor);
    //     emit Events.DoctorListed(sampleDoctor);

    //     Myriad(proxy).addDoctorDetails(
    //         GovernanceToken(makeAddr("governanceToken")),
    //         sampleDoctor.doctorAddress,
    //         sampleDoctor.name,
    //         sampleDoctor.doctorRegistrationId,
    //         sampleDoctor.specialization,
    //         sampleDoctor.hospitalAddress
    //     );
    // }
    //     Myriad(proxy).addDoctorDetails(
    //         GovernanceToken(makeAddr("governanceToken")),
    //         sampleDoctor.doctorAddress,
    //         sampleDoctor.name,
    //         sampleDoctor.doctorRegistrationId,
    //         sampleDoctor.specialization,
    //         sampleDoctor.hospitalAddress
    //     );
    // }

    // Add Hospital

    DataTypes.HospitalStruct sampleHospital =
        DataTypes.HospitalStruct(
            address(0x21),
            "test-hospital-ipfs-info",
            block.timestamp,
            true
        );

    // function test_RevertHospitalCannotBeAdded() external {
    //     vm.expectEmit(true, true, true, true);
    //     emit Events.HospitalListed(sampleHospital);
    // function test_RevertHospitalCannotBeAdded() external {
    //     vm.expectEmit(true, true, true, true);
    //     emit Events.HospitalListed(sampleHospital);

    //     Myriad(proxy).addHospitalDetails(
    //         GovernanceToken(makeAddr("governanceToken")),
    //         sampleHospital.hospitalAddress,
    //         sampleHospital.name,
    //         sampleHospital.hospitalRegistrationId,
    //         sampleHospital.email,
    //         sampleHospital.phoneNumber
    //     );
    // }
    //     Myriad(proxy).addHospitalDetails(
    //         GovernanceToken(makeAddr("governanceToken")),
    //         sampleHospital.hospitalAddress,
    //         sampleHospital.name,
    //         sampleHospital.hospitalRegistrationId,
    //         sampleHospital.email,
    //         sampleHospital.phoneNumber
    //     );
    // }

    // Add DiagnosticLab

    DataTypes.DiagnosticLabStruct sampleDiagnosticLab =
        DataTypes.DiagnosticLabStruct(
            address(0x31),
            "test-diagnostic-lab-ipfs-info",
            block.timestamp,
            true
        );

    // function test_RevertDiagnosticLabCannotBeAdded() external {
    //     vm.expectEmit(true, true, true, true);
    // function test_RevertDiagnosticLabCannotBeAdded() external {
    //     vm.expectEmit(true, true, true, true);

    //     emit Events.DiagnosticLabListed(sampleDiagnosticLab);
    //     emit Events.DiagnosticLabListed(sampleDiagnosticLab);

    //     Myriad(proxy).addDiagnosticLabDetails(
    //         GovernanceToken(makeAddr("governanceToken")),
    //         sampleDiagnosticLab.diagnosticLabAddress,
    //         sampleDiagnosticLab.name,
    //         sampleDiagnosticLab.diagnosticLabRegistrationId,
    //         sampleDiagnosticLab.email,
    //         sampleDiagnosticLab.phoneNumber
    //     );
    // }
    //     Myriad(proxy).addDiagnosticLabDetails(
    //         GovernanceToken(makeAddr("governanceToken")),
    //         sampleDiagnosticLab.diagnosticLabAddress,
    //         sampleDiagnosticLab.name,
    //         sampleDiagnosticLab.diagnosticLabRegistrationId,
    //         sampleDiagnosticLab.email,
    //         sampleDiagnosticLab.phoneNumber
    //     );
    // }

    // Add Clinic

    DataTypes.ClinicStruct sampleClinic =
        DataTypes.ClinicStruct(
            address(0x41),
            "test-clinic-ipfs-info",
            block.timestamp,
            true
        );

    // function test_RevertClinicCannotBeAdded() external {
    //     // vm.startPrank(address(0x0));
    //     vm.expectEmit(true, true, true, true);
    // function test_RevertClinicCannotBeAdded() external {
    //     // vm.startPrank(address(0x0));
    //     vm.expectEmit(true, true, true, true);

    //     emit Events.ClinicListed(sampleClinic);
    //     emit Events.ClinicListed(sampleClinic);

    //     Myriad(proxy).addClinicDetails(
    //         GovernanceToken(makeAddr("governanceToken")),
    //         sampleClinic.clinicAddress,
    //         sampleClinic.name,
    //         sampleClinic.clinicRegistrationId,
    //         sampleClinic.email,
    //         sampleClinic.phoneNumber
    //     );
    //     // vm.stopPrank();
    // }
    //     Myriad(proxy).addClinicDetails(
    //         GovernanceToken(makeAddr("governanceToken")),
    //         sampleClinic.clinicAddress,
    //         sampleClinic.name,
    //         sampleClinic.clinicRegistrationId,
    //         sampleClinic.email,
    //         sampleClinic.phoneNumber
    //     );
    //     // vm.stopPrank();
    // }

    // Add Patient Details: All the tests are independent and they should have no dependency on each other.
    address patientAddress = samplePatient.patientAddress;
    uint16 category = 0;
    string ipfsHash = "qmazkcwaekwedrtnvfhrxabyewtjdxhnjpl1uykybe5zab";

    // function test_RevertPatientDetailsCannotBeAdded() external {
    //     // Register Patient
    //     vm.startPrank(address(0x1));
    //     Myriad(proxy).registerPatient(
    //         GovernanceToken(makeAddr("governanceToken")),
    //         samplePatient.patientAddress,
    //         samplePatient.name,
    //         samplePatient.dob,
    //         samplePatient.phoneNumber,
    //         samplePatient.bloodGroup,
    //         samplePatient.publicKey
    //     );
    //     vm.stopPrank();
    // function test_RevertPatientDetailsCannotBeAdded() external {
    //     // Register Patient
    //     vm.startPrank(address(0x1));
    //     Myriad(proxy).registerPatient(
    //         GovernanceToken(makeAddr("governanceToken")),
    //         samplePatient.patientAddress,
    //         samplePatient.name,
    //         samplePatient.dob,
    //         samplePatient.phoneNumber,
    //         samplePatient.bloodGroup,
    //         samplePatient.publicKey
    //     );
    //     vm.stopPrank();

    //     // Register Doctor
    //     Myriad(proxy).addDoctorDetails(
    //         GovernanceToken(makeAddr("governanceToken")),
    //         sampleDoctor.doctorAddress,
    //         sampleDoctor.name,
    //         sampleDoctor.doctorRegistrationId,
    //         sampleDoctor.specialization,
    //         sampleDoctor.hospitalAddress
    //     );
    //     // Register Doctor
    //     Myriad(proxy).addDoctorDetails(
    //         GovernanceToken(makeAddr("governanceToken")),
    //         sampleDoctor.doctorAddress,
    //         sampleDoctor.name,
    //         sampleDoctor.doctorRegistrationId,
    //         sampleDoctor.specialization,
    //         sampleDoctor.hospitalAddress
    //     );

    //     samplePatient.vaccinationHash.push(ipfsHash); // storage variables can only be modified inside a function (as it costs gas and someone has to pay for it.)
    //     samplePatient.vaccinationHash.push(ipfsHash); // storage variables can only be modified inside a function (as it costs gas and someone has to pay for it.)

    //     // Doctor adding patient details
    //     vm.startPrank(address(0x11));
    //     // Doctor adding patient details
    //     vm.startPrank(address(0x11));

    //     vm.expectEmit(true, true, true, true);
    //     emit Events.PatientListed(samplePatient);
    //     vm.expectEmit(true, true, true, true);
    //     emit Events.PatientListed(samplePatient);

    //     Myriad(proxy).addPatientDetails(patientAddress, category, ipfsHash); // adding details to samplePatient
    //     Myriad(proxy).addPatientDetails(patientAddress, category, ipfsHash); // adding details to samplePatient

    //     vm.stopPrank();
    // }
    //     vm.stopPrank();
    // }

    function test_RevertIfCannotInitializeOwner() external view {
        if (Myriad(proxy).owner() != address(this)) {
            console.log(Myriad(proxy).owner(), address(this));
            revert("Owner initialization failed");
        }
    }
}
