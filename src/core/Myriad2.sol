// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.20;

/// @title A smart contract supporting the Decentralized Patient Medical Record System
/// @author Aditya Kumar Singh @ 2024
/// @dev All function calls are currently implemented without side effects

//imports
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {DataTypes} from "../libraries/DataTypes.sol";
import {Errors} from "../libraries/Errors.sol";
import {Events} from "../libraries/Events.sol";
import {Script, console} from "forge-std/Script.sol";

contract Myriad is
    ReentrancyGuard,
    Initializable,
    OwnableUpgradeable,
    UUPSUpgradeable,
    Script
{
    //Storage Variables
    mapping(address => DataTypes.PatientStruct) private s_patients;
    mapping(address => DataTypes.DoctorStruct) private s_doctors;
    mapping(address => DataTypes.HospitalStruct) private s_hospitals;
    mapping(address => DataTypes.ClinicStruct) private s_clinic;
    mapping(address => DataTypes.DiagnosticLabStruct) private s_diagnosticLab;
    mapping(address => string) private s_addressToPublicKey;

    uint64 public constant version = 2;

    //modifiers
    modifier onlyDoctor(address senderAddress) {
        if (s_doctors[senderAddress].doctorAddress != senderAddress) {
            revert Errors.Myriad__NotDoctor();
        }
        _;
    }

    // constructor
    // proxies don't use constructors,
    // hence an external initialize function is used
    // initialize keyword ensures that the contract gets initialized only once.

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public reinitializer(version) {
        __Ownable_init(msg.sender); //sets owner to msg.sender
        __UUPSUpgradeable_init();
    }

    // necessary overridden check before upgrade
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    //Functions
    function registerPatient(
        address _patientAddress,
        string memory _name,
        uint256 _dob,
        string memory _phoneNumber,
        string memory _bloodGroup,
        string memory _publicKey
    ) external nonReentrant {
        //patients can themselves register to the system.
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

        console.log("The Patient is registered successfully: ", patient.name);

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
        string memory _specialization,
        address _hospitalAddress
    ) external onlyOwner nonReentrant {
        DataTypes.DoctorStruct memory doctor = s_doctors[_doctorAddress];
        doctor = DataTypes.DoctorStruct(
            _doctorAddress,
            _name,
            _doctorRegistrationId,
            block.timestamp,
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
        console.log(msg.sender);

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

    function getClinicDetails(
        address _clinicAddress
    ) external view returns (string memory, string memory, string memory) {
        return (
            s_clinic[_clinicAddress].name,
            s_clinic[_clinicAddress].clinicRegistrationId,
            s_clinic[_clinicAddress].email
        );
    }

    function getDiagnosticLabDetails(
        address _diagnosticLabAddress
    ) external view returns (string memory, string memory, string memory) {
        return (
            s_diagnosticLab[_diagnosticLabAddress].name,
            s_diagnosticLab[_diagnosticLabAddress].diagnosticLabRegistrationId,
            s_diagnosticLab[_diagnosticLabAddress].email
        );
    }

    /// @dev The address of the current implementation
    function getImplementation() public view returns (address) {
        address implementation = ERC1967Utils.getImplementation();
        return implementation;
    }
}
