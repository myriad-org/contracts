// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.0;

import {DataTypes} from "../libraries/DataTypes.sol";

library Events {
    event PatientListed(address indexed patientAddress, string patientInfo, uint256 timestamp); //added or modified to the mapping

    event DoctorListed(address indexed doctorAddress, string doctorInfo, uint256 timestamp); //added or modified to the mapping

    event HospitalListed(address indexed hospitalAddress, string hospitalInfo, uint256 timestamp); //added or modified to the mapping

    event ClinicListed(address indexed clinicAddress, string clinicInfo, uint256 timestamp); //added or modified to the mapping

    event DiagnosticLabListed(address indexed diagnosticLabAddress, string diagnosticLabInfo, uint256 timestamp); //added or modified to the mapping

    event GovernanceTokenMintedAndDelegated(address delegatee, uint256 amount);
}
