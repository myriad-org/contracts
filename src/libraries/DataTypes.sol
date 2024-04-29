// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.0;

library DataTypes {
    //Type Declaration
    struct PatientStruct {
        address patientAddress;
        string patientInfo; // IFPS CID for patient's information
        uint256 timestamp;
        bool isValid;
    }

    struct HospitalStruct {
        address hospitalAddress; //account address of hospital
        string hospitalInfo; // IFPS CID for hospital's information
        uint256 timestamp;
        bool isValid;
    }

    struct DoctorStruct {
        address doctorAddress; //account address of doctor
        string doctorInfo; // IFPS CID for doctor's information
        uint256 timestamp;
        bool isValid;
    }

    struct DiagnosticLabStruct {
        address diagnosticLabAddress; //account address of diagnostic
        string diagnosticLabInfo; // IFPS CID for diagnostic lab's information
        uint256 timestamp;
        bool isValid;
    }

    struct ClinicStruct {
        address clinicAddress; //account address of clinic
        string clinicInfo; // IFPS CID for clinic's information
        uint256 timestamp;
        bool isValid;
    }
}
