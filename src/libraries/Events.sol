// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.0;

import {DataTypes} from "../libraries/DataTypes.sol";

library Events {
    event PatientListed(DataTypes.PatientStruct patient); //added or modified to the mapping

    event PublicKeyListed(address indexed patientAddress, string publicKey); //emitting when public key is added.

    event DoctorListed(DataTypes.DoctorStruct doctor); //added or modified to the mapping

    event HospitalListed(DataTypes.HospitalStruct hospital); //added or modified to the mapping

    event ClinicListed(DataTypes.ClinicStruct clinic); //added or modified to the mapping

    event DiagnosticLabListed(DataTypes.DiagnosticLabStruct clinic); //added or modified to the mapping
}
