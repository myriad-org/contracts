// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.0;

library DataTypes {
    //Type Declaration
    struct PatientStruct {
        string name; //
        address patientAddress;
        //account address of patient
        uint256 dob; //
        string phoneNumber;
        string bloodGroup; //
        string publicKey;
        //for storing public key for encrypting the data
        uint256 dateOfRegistration; //the date of registration of patient to the system. Tells which records are not in the system.
        //Medical Records
        string[] vaccinationHash; //0
        string[] accidentHash; // 1
        string[] chronicHash; //2
        string[] acuteHash; //3
    }

    struct HospitalStruct {
        string name;
        address hospitalAddress; //account address of hospital
        uint256 dateOfRegistration;
        string hospitalRegistrationId;
        string email;
        string phoneNumber;
    }

    struct DoctorStruct {
        address doctorAddress; //account address of doctor
        string name;
        string doctorRegistrationId; //NMC Regsitration Id
        uint256 dateOfRegistration;
        string specialization;
        address hospitalAddress;
    }

    struct DiagnosticLabStruct {
        address diagnosticLabAddress; //account address of diagnostic
        string name;
        string diagnosticLabRegistrationId; //NMC Regsitration Id
        uint256 dateOfRegistration;
        string email;
        string phoneNumber;
    }

    struct ClinicStruct {
        address clinicAddress; //account address of clinic
        string name;
        string clinicRegistrationId; //NMC Regsitration Id
        uint256 dateOfRegistration;
        string email;
        string phoneNumber;
    }
}
