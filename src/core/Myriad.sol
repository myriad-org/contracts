// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.20;

/// @title A smart contract supporting the Decentralized Patient Medical Record System
/// @author Aditya Kumar Singh @ 2024
/// @dev Token Distribution at the time of registration: Patient: 1 token, Doctor: 2 tokens, Clinic: 3 tokens, Diagnostic Lab: 3 tokens, Hospital: 4 tokens

//imports
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {DataTypes} from "../libraries/DataTypes.sol";
import {Error} from "../libraries/Errors.sol";
import {Events} from "../libraries/Events.sol";
import {GovernanceToken} from "../governance/GovernanceToken.sol";

contract Myriad is
    ReentrancyGuard,
    Initializable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    uint64 public constant version = 1;
    //Storage Variables
    mapping(address => DataTypes.PatientStruct) private s_patients;
    mapping(address => DataTypes.DoctorStruct) private s_doctors;
    mapping(address => DataTypes.HospitalStruct) private s_hospitals;
    mapping(address => DataTypes.ClinicStruct) private s_clinic;
    mapping(address => DataTypes.DiagnosticLabStruct) private s_diagnosticLab;
    // mapping(address => string) private s_addressToPublicKey;

    // For debugging purposes
    int256 public num;

    function store(int256 _num) public onlyOwner {
        num = _num;
    }

    function retrieve() public view returns (int256) {
        return num;
    }

    // Governance Token Address for Decentralized Voting
    address private governanceTokenAddress;

    //modifiers
    modifier onlyDoctor(address senderAddress) {
        if (s_doctors[senderAddress].doctorAddress != senderAddress) {
            revert Error.Myriad__NotDoctor();
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

    function initialize(
        address _governanceTokenAddress
    ) public reinitializer(version) {
        governanceTokenAddress = _governanceTokenAddress;
        __Ownable_init(msg.sender); //sets owner to msg.sender
        __UUPSUpgradeable_init();
    }

    // necessary overridden check before upgrade
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    function mintAndDelegateTokens(address delegatee, uint256 amount) internal {
        GovernanceToken governanceToken = GovernanceToken(
            payable(governanceTokenAddress)
        );
        governanceToken.mint(delegatee, amount); // every patient will get exactly one token.
        governanceToken.delegate(delegatee, delegatee); // delegate voting power.
        emit Events.GovernanceTokenMintedAndDelegated(delegatee, amount);
    }

    // Functions
    function registerPatient(
        address _patientAddress,
        string calldata _patientInfo,
        bool _isUpdate
    ) external nonReentrant {
        // patients can themselves register to the system.
        if (msg.sender != _patientAddress) {
            revert Error.Myriad__NotPatient();
        }
        DataTypes.PatientStruct memory patient = s_patients[_patientAddress];

        // revert if patient already exists, unless it's update transaction
        if (patient.isValid == true && _isUpdate == false) {
            revert Error.Myriad__PatientAlreadyRegistered();
        }

        // minting new tokens when patient is not registered.
        if (!patient.isValid) {
            mintAndDelegateTokens(_patientAddress, 1); // every patient will get exactly one token.
        }

        uint256 timestamp = block.timestamp;
        patient = DataTypes.PatientStruct(
            _patientAddress,
            _patientInfo,
            timestamp,
            true
        );
        s_patients[_patientAddress] = patient;

        // emitting the event.
        emit Events.PatientListed(_patientAddress, _patientInfo, timestamp);
    }

    /// @dev This updates the patient information and intended to be called by doctors.
    /// @dev It is protected by {{onlyDoctor}} modifier.
    /// @dev If _isUpdate is false, then it will revert if patient already exists.
    /// @dev Though similar to registerPatient, it is kept separate as it's protected by {{ onlyDoctor }}
    function addPatientDetails(
        address _patientAddress,
        string calldata _patientInfo,
        bool _isUpdate
    ) external onlyDoctor(msg.sender) nonReentrant {
        DataTypes.PatientStruct memory patient = s_patients[_patientAddress];
        if (patient.isValid == true && _isUpdate == false) {
            revert Error.Myriad__PatientAlreadyRegistered();
        }
        uint256 timestamp = block.timestamp;
        patient = DataTypes.PatientStruct(
            _patientAddress,
            _patientInfo,
            patient.timestamp, // not updating the patient registration timestamp.
            true
        );
        s_patients[_patientAddress] = patient;

        //emitting the event.
        emit Events.PatientListed(_patientAddress, _patientInfo, timestamp);
    }

    /// @dev This is protected by {{onlyOwner}} modifier
    function registerDoctor(
        address _doctorAddress,
        string calldata _doctorInfo,
        bool _isUpdate
    ) external onlyOwner nonReentrant {
        DataTypes.DoctorStruct memory doctor = s_doctors[_doctorAddress];

        // revert if doctor already exists, unless it's update transaction
        if (doctor.isValid == true && _isUpdate == false) {
            revert Error.Myriad__DoctorAlreadyRegistered();
        }

        // minting new tokens when doctor is not registered.
        if (!doctor.isValid) {
            mintAndDelegateTokens(_doctorAddress, 2); // every doctor will get exactly 2 tokens.
        }

        uint256 timestamp = block.timestamp;
        doctor = DataTypes.DoctorStruct(
            _doctorAddress,
            _doctorInfo,
            timestamp,
            true
        );
        s_doctors[_doctorAddress] = doctor;

        //emitting the event.
        emit Events.DoctorListed(_doctorAddress, _doctorInfo, timestamp);
    }

    /// @dev This is protected by {{onlyOwner}} modifier
    function registerHospital(
        address _hospitalAddress,
        string calldata _hospitalInfo,
        bool _isUpdate
    ) external onlyOwner nonReentrant {
        DataTypes.HospitalStruct memory hospital = s_hospitals[
            _hospitalAddress
        ];
        if (hospital.isValid == true && _isUpdate == false) {
            revert Error.Myriad__HospitalAlreadyRegistered();
        }

        // minting new tokens when hospital is not registered.
        if (!hospital.isValid) {
            mintAndDelegateTokens(_hospitalAddress, 4); // every hospital will get exactly 4 tokens.
        }

        uint256 timestamp = block.timestamp;
        hospital = DataTypes.HospitalStruct(
            _hospitalAddress,
            _hospitalInfo,
            timestamp,
            true
        );
        s_hospitals[_hospitalAddress] = hospital;

        //emitting the event.
        emit Events.HospitalListed(_hospitalAddress, _hospitalInfo, timestamp);
    }

    /// @dev This is protected by {{onlyOwner}} modifier
    function registerClinic(
        address _clinicAddress,
        string calldata _clinciInfo,
        bool _isUpdate
    ) external onlyOwner nonReentrant {
        DataTypes.ClinicStruct memory clinic = s_clinic[_clinicAddress];
        if (clinic.isValid == true && _isUpdate == false) {
            revert Error.Myriad__ClinicAlreadyRegistered();
        }

        // minting new tokens when clinic is not registered.
        if (!clinic.isValid) {
            mintAndDelegateTokens(_clinicAddress, 3); // every clinic will get exactly 3 tokens. (same as diagnostic lab}
        }

        uint256 timestamp = block.timestamp;
        clinic = DataTypes.ClinicStruct(
            _clinicAddress,
            _clinciInfo,
            timestamp,
            true
        );
        s_clinic[_clinicAddress] = clinic;

        //emitting the event.
        emit Events.ClinicListed(_clinicAddress, _clinciInfo, timestamp);
    }

    /// @dev This is protected by {{onlyOwner}} modifier.
    function registerDiagnosticLab(
        address _diagnosticLabAddress,
        string calldata _diagnosticLabInfo,
        bool _isUpdate
    ) external onlyOwner nonReentrant {
        DataTypes.DiagnosticLabStruct memory diagnosticLab = s_diagnosticLab[
            _diagnosticLabAddress
        ];

        if (diagnosticLab.isValid == true && _isUpdate == false) {
            revert Error.Myriad__DiagnosticLabAlreadyRegistered();
        }

        // minting new tokens when diagnostic lab is not registered.
        if (!diagnosticLab.isValid) {
            mintAndDelegateTokens(_diagnosticLabAddress, 3); // every diagnostic lab will get exactly 3 tokens.
        }

        uint256 timestamp = block.timestamp;
        diagnosticLab = DataTypes.DiagnosticLabStruct(
            _diagnosticLabAddress,
            _diagnosticLabInfo,
            timestamp,
            true
        );
        s_diagnosticLab[_diagnosticLabAddress] = diagnosticLab;

        //emitting the event.
        emit Events.DiagnosticLabListed(
            _diagnosticLabAddress,
            _diagnosticLabInfo,
            timestamp
        );
    }

    /// @dev Returns the details of the patient. The sensitive medical files itself are encrypted.
    function getPatientDetails(
        address _patientAddress
    ) external view returns (address, string memory, uint256, bool) {
        DataTypes.PatientStruct memory patient = s_patients[_patientAddress];
        return (
            patient.patientAddress,
            patient.patientInfo,
            patient.timestamp,
            patient.isValid
        );
    }

    /// @dev Returns the details of the doctor
    function getDoctorDetails(
        address _doctorAddress
    ) external view returns (address, string memory, uint256, bool) {
        DataTypes.DoctorStruct memory doctor = s_doctors[_doctorAddress];
        return (
            doctor.doctorAddress,
            doctor.doctorInfo,
            doctor.timestamp,
            doctor.isValid
        );
    }

    /// @dev Returns the details of the hospital
    function getHospitalDetails(
        address _hospitalAddress
    ) external view returns (address, string memory, uint256, bool) {
        DataTypes.HospitalStruct memory hospital = s_hospitals[
            _hospitalAddress
        ];
        return (
            hospital.hospitalAddress,
            hospital.hospitalInfo,
            hospital.timestamp,
            hospital.isValid
        );
    }

    /// @dev Returns the details of the clinic
    function getClinicDetails(
        address _clinicAddress
    ) external view returns (address, string memory, uint256, bool) {
        DataTypes.ClinicStruct memory clinic = s_clinic[_clinicAddress];
        return (
            clinic.clinicAddress,
            clinic.clinicInfo,
            clinic.timestamp,
            clinic.isValid
        );
    }

    /// @dev Returns the details of the diagnostic lab
    function getDiagnosticLabDetails(
        address _diagnosticLabAddress
    ) external view returns (address, string memory, uint256, bool) {
        DataTypes.DiagnosticLabStruct memory diagnosticLab = s_diagnosticLab[
            _diagnosticLabAddress
        ];
        return (
            diagnosticLab.diagnosticLabAddress,
            diagnosticLab.diagnosticLabInfo,
            diagnosticLab.timestamp,
            diagnosticLab.isValid
        );
    }

    /// @dev The address of the current implementation
    function getImplementation() public view returns (address) {
        address implementation = ERC1967Utils.getImplementation();
        return implementation;
    }

    /// @dev Returns the address of the governance token
    function getGovernanceToken() public view returns (address) {
        return governanceTokenAddress;
    }
}
