// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.0;

library DataTypes {
    //Type Declaration
    struct PatientStruct {
        address patientAddress;
        // string name; //
        // //account address of patient
        // uint256 dob; //
        // string bloodGroup; // coded blood group to save on gas
        // string publicKey; // CID for public key stored on IFPS
        // //for storing public key for encrypting the data
        // uint256 dateOfRegistration; //the date of registration of patient to the system. Tells which records are not in the system.
        // //Medical Records
        // string[] vaccinationHash; //0
        // string[] accidentHash; // 1
        // string[] chronicHash; //2
        // string[] acuteHash; //3
        string patientInfo; // IFPS CID for patient's information
        bool isValid;
    }

    struct HospitalStruct {
        address hospitalAddress; //account address of hospital
        // string name;
        // uint256 dateOfRegistration;
        // uint256 hospitalRegistrationId;
        // string website;
        string hospitalInfo; // IFPS CID for hospital's information
        bool isValid;
    }

    struct DoctorStruct {
        address doctorAddress; //account address of doctor
        // string name;
        // uint256 doctorRegistrationId; //NMC Regsitration Id
        // uint256 dateOfRegistration;
        // string specialization;
        // address hospitalAddress;
        string doctorInfo; // IFPS CID for doctor's information
        bool isValid;
    }

    struct DiagnosticLabStruct {
        address diagnosticLabAddress; //account address of diagnostic
        // string name;
        // string diagnosticLabRegistrationId; //NMC Regsitration Id
        // uint256 dateOfRegistration;
        // string email;
        // string phoneNumber;
        string diagnosticLabInfo; // IFPS CID for diagnostic lab's information
        bool isValid;
    }

    struct ClinicStruct {
        address clinicAddress; //account address of clinic
        // string name;
        // string clinicRegistrationId; //NMC Regsitration Id
        // uint256 dateOfRegistration;
        // string email;
        // string phoneNumber;
        string clinicInfo; // IFPS CID for clinic's information
        bool isValid;
    }
}
