// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.0;

library Events {
    event PatientListed(
        address indexed patientAddress,
        string name,
        string[] chronicHash,
        uint256 indexed dob,
        string bloodGroup,
        uint256 indexed dateOfRegistration,
        string publicKey,
        string[] vaccinationHash,
        string phoneNumber,
        string[] accidentHash,
        string[] acuteHash
    ); //added or modified

    event PublicKeyListed(address indexed patientAddress, string publicKey); //emitting when public key is added.

    event DoctorListed(
        address indexed doctorAddress,
        string name,
        string doctorRegistrationId,
        uint256 indexed dateOfRegistration,
        string specialization,
        address indexed hospitalAddress
    ); //added or modified to the mapping
    event HospitalListed(
        address indexed hospitalAddress,
        string name,
        string hospitalRegistrationId,
        uint256 indexed dateOfRegistration,
        string email,
        string phoneNumber
    ); //added(mostly) or modified
}