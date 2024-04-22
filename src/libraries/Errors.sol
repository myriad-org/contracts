// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.0;

library Errors {
    //custom errors
    error Myriad__NotOwner();
    error Myriad__NotDoctor();
    error Myriad__NotApproved();
    error Myriad__NotPatient();
    error Myriad__PatientAlreadyRegistered();
    error Myriad__DoctorAlreadyRegistered();
    error Myriad__HospitalAlreadyRegistered();
    error Myriad__ClinicAlreadyRegistered();
    error Myriad__DiagnosticLabAlreadyRegistered();
}
