// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.7;

/// @title A smart contract supporting the Decentralized Patient Medical Record System
/// @author Aditya Kumar Singh @ January 2024
/// @dev All function calls are currently implemented without side effects

//imports
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {DataTypes} from "../libraries/DataTypes.sol";
import {Errors} from "../libraries/Errors.sol";
import {Events} from "../libraries/Events.sol";

//custom errors

contract Myriad is ReentrancyGuard {
    //Storage Variables
    mapping(address => DataTypes.PatientStruct) private s_patients;
    mapping(address => DataTypes.DoctorStruct) private s_doctors;
    mapping(address => DataTypes.HospitalStruct) private s_hospitals;
    mapping(address => DataTypes.ClinicStruct) private s_clinic;
    mapping(address => DataTypes.DiagnosticLabStruct) private s_diagnosticLab;
    mapping(address => string) private s_addressToPublicKey;

    address private immutable i_owner;

    //modifiers
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert Errors.Myriad__NotOwner();
        }
        _;
    }

    modifier onlyDoctor(address senderAddress) {
        if (s_doctors[senderAddress].doctorAddress != senderAddress) {
            revert Errors.Myriad__NotDoctor();
        }
        _;
    }

    constructor() {
        i_owner = msg.sender;
    }

    //Functions
    //patients can themselves register to the system.
    function registerPatient(
        address _patientAddress,
        string memory _name,
        uint256 _dob,
        string memory _phoneNumber,
        string memory _bloodGroup,
        string memory _publicKey
    ) external nonReentrant {
        if (msg.sender != _patientAddress) {
            revert Errors.Myriad__NotPatient();
        }

        DataTypes.PatientStruct memory patient;
        patient = DataTypes.PatientStruct(
            _name,
            _patientAddress,
            _dob,
            _phoneNumber,
            _bloodGroup,
            _publicKey,
            block.timestamp, //date of registration
            new string[](0), //0
            new string[](0), // 1
            new string[](0), //2
            new string[](0) //3
        );

        s_patients[_patientAddress] = patient;
        s_addressToPublicKey[_patientAddress] = _publicKey;

        //emiting the events
        emit Events.PublicKeyListed(_patientAddress, _publicKey);
        emit Events.PatientListed(patient);
    }

    function addPatientDetails(
        address _patientAddress,
        uint16 _category,
        string memory _IpfsHash //This is the IPFS hash of the diagnostic report which contains an IPFS file hash (preferably PDF file)
    ) external onlyDoctor(msg.sender) nonReentrant {
        if (_category == 0) {
            s_patients[_patientAddress].vaccinationHash.push(_IpfsHash);
        } else if (_category == 1) {
            s_patients[_patientAddress].accidentHash.push(_IpfsHash);
        } else if (_category == 2) {
            s_patients[_patientAddress].chronicHash.push(_IpfsHash);
        } else if (_category == 3) {
            s_patients[_patientAddress].acuteHash.push(_IpfsHash);
        }

        //emitting the event.
        emit Events.PatientListed(s_patients[_patientAddress]);
    }

    //this will be done using script by the owner
    function addDoctorDetails(
        address _doctorAddress,
        string memory _name,
        string memory _doctorRegistrationId,
        uint256 _dateOfRegistration,
        string memory _specialization,
        address _hospitalAddress
    ) external onlyOwner nonReentrant {
        DataTypes.DoctorStruct memory doctor = s_doctors[_doctorAddress];
        doctor = DataTypes.DoctorStruct(
            _doctorAddress,
            _name,
            _doctorRegistrationId,
            _dateOfRegistration,
            _specialization,
            _hospitalAddress
        );

        s_doctors[_doctorAddress] = doctor;

        //emitting the event.
        emit Events.DoctorListed(doctor);
    }

    //this will be done using script by the owner
    function addHospitalDetails(
        address _hospitalAddress,
        string memory _name,
        string memory _hospitalRegistrationId,
        string memory _email,
        string memory _phoneNumber
    ) external onlyOwner nonReentrant {
        DataTypes.HospitalStruct memory hospital = s_hospitals[
            _hospitalAddress
        ];
        hospital = DataTypes.HospitalStruct(
            _name,
            _hospitalAddress,
            block.timestamp,
            _hospitalRegistrationId,
            _email,
            _phoneNumber
        );

        s_hospitals[_hospitalAddress] = hospital;

        //emitting the event.
        emit Events.HospitalListed(hospital);
    }

    //this will be done using script by the owner
    function addClinicDetails(
        address _clinicAddress,
        string memory _name,
        string memory _clinicRegistrationId,
        string memory _email,
        string memory _phoneNumber
    ) external onlyOwner nonReentrant {
        DataTypes.ClinicStruct memory clinic = s_clinic[_clinicAddress];
        clinic = DataTypes.ClinicStruct(
            _clinicAddress,
            _name,
            _clinicRegistrationId,
            block.timestamp,
            _email,
            _phoneNumber
        );

        s_clinic[_clinicAddress] = clinic;

        //emitting the event.
        emit Events.ClinicListed(clinic);
    }

    //this will be done using script by the owner
    function addDiagnosticLabDetails(
        address _diagnosticLabAddress,
        string memory _name,
        string memory _diagnosticLabRegistrationId,
        string memory _email,
        string memory _phoneNumber
    ) external onlyOwner nonReentrant {
        DataTypes.DiagnosticLabStruct memory diagnosticLab = s_diagnosticLab[
            _diagnosticLabAddress
        ];
        diagnosticLab = DataTypes.DiagnosticLabStruct(
            _diagnosticLabAddress,
            _name,
            _diagnosticLabRegistrationId,
            block.timestamp,
            _email,
            _phoneNumber
        );

        s_diagnosticLab[_diagnosticLabAddress] = diagnosticLab;

        //emitting the event.
        emit Events.DiagnosticLabListed(diagnosticLab);
    }

    function getMyDetails()
        external
        view
        returns (DataTypes.PatientStruct memory)
    {
        return s_patients[msg.sender];
    }

    //authorized doctor viewing patient's records
    function getPatientDetails(
        address _patientAddress
    ) external view returns (string memory, string memory, uint256) {
        return (
            s_patients[_patientAddress].name,
            s_patients[_patientAddress].publicKey,
            s_patients[_patientAddress].dateOfRegistration
        );
    }

    function getPublicKey(
        address _patientAddress
    ) public view returns (string memory) {
        return s_addressToPublicKey[_patientAddress];
    }

    function getDoctorDetails(
        address _doctorAddress
    )
        external
        view
        returns (string memory, string memory, string memory, address)
    {
        return (
            s_doctors[_doctorAddress].name,
            s_doctors[_doctorAddress].specialization,
            s_doctors[_doctorAddress].doctorRegistrationId,
            s_doctors[_doctorAddress].hospitalAddress
        );
    }

    function getHospitalDetails(
        address _hospitalAddress
    ) external view returns (string memory, string memory, string memory) {
        return (
            s_hospitals[_hospitalAddress].name,
            s_hospitals[_hospitalAddress].hospitalRegistrationId,
            s_hospitals[_hospitalAddress].email
        );
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
