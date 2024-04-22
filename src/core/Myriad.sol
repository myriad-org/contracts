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
import {Errors} from "../libraries/Errors.sol";
import {Events} from "../libraries/Events.sol";
import {GovernanceToken} from "../governance/GovernanceToken.sol";

contract Myriad is ReentrancyGuard, Initializable, OwnableUpgradeable, UUPSUpgradeable {
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

    function initialize(address _governanceTokenAddress) public reinitializer(version) {
        governanceTokenAddress = _governanceTokenAddress;
        __Ownable_init(msg.sender); //sets owner to msg.sender
        __UUPSUpgradeable_init();
    }

    // necessary overridden check before upgrade
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function mintAndDelegateTokens(address delegatee, uint256 amount) internal {
        GovernanceToken governanceToken = GovernanceToken(payable(governanceTokenAddress));
        governanceToken.mint(delegatee, amount); // every patient will get exactly one token.
        governanceToken.delegate(delegatee, delegatee); // delegate voting power.
        emit Events.GovernanceTokenMintedAndDelegated(delegatee, amount);
    }

    // Functions
    function registerPatient(
        GovernanceToken _governanceToken,
        address _patientAddress,
        string calldata _patientInfo,
        bool _isUpdate
    ) external nonReentrant {
        // patients can themselves register to the system.
        if (msg.sender != _patientAddress) {
            revert Errors.Myriad__NotPatient();
        }
        DataTypes.PatientStruct memory patient = s_patients[_patientAddress];

        // revert if patient already exists, unless it's update transaction
        if (patient.isValid == true && _isUpdate == false) {
            revert Errors.Myriad__PatientAlreadyRegistered();
        }
        patient = DataTypes.PatientStruct(_patientAddress, _patientInfo, true);

        s_patients[_patientAddress] = patient;

        // minting and delegating voting power to the patient.
        mintAndDelegateTokens(_patientAddress, 1); // every patient will get exactly one token.

        // emitting the event.
        emit Events.PatientListed(_patientAddress, _patientInfo, block.timestamp);
    }

    /// @dev This updates the patient information and intended to be called by doctors.
    /// @dev It is protected by {{onlyDoctor}} modifier.
    /// @dev If _isUpdate is false, then it will revert if patient already exists.
    function addPatientDetails(address _patientAddress, string calldata _patientInfo, bool _isUpdate)
        external
        onlyDoctor(msg.sender)
        nonReentrant
    {
        DataTypes.PatientStruct memory patient = s_patients[_patientAddress];
        if (patient.isValid == true && _isUpdate == false) {
            revert Errors.Myriad__PatientAlreadyRegistered();
        }

        patient = DataTypes.PatientStruct(_patientAddress, _patientInfo, true);

        //emitting the event.
        emit Events.PatientListed(_patientAddress, _patientInfo, block.timestamp);
    }

    /// @dev This is protected by {{onlyOwner}} modifier
    function registerDoctor(address _doctorAddress, string calldata _doctorInfo, bool _isUpdate)
        external
        onlyOwner
        nonReentrant
    {
        DataTypes.DoctorStruct memory doctor = s_doctors[_doctorAddress];

        // revert if doctor already exists, unless it's update transaction
        if (doctor.isValid == true && _isUpdate == false) {
            revert Errors.Myriad__DoctorAlreadyRegistered();
        }
        doctor = DataTypes.DoctorStruct(_doctorAddress, _doctorInfo, true);

        s_doctors[_doctorAddress] = doctor;

        mintAndDelegateTokens(_doctorAddress, 2); // every doctor will get exactly 2 tokens.

        //emitting the event.
        emit Events.DoctorListed(_doctorAddress, _doctorInfo, block.timestamp);
    }

    /// @dev This is protected by {{onlyOwner}} modifier
    function registerHospital(address _hospitalAddress, string calldata _hospitalInfo, bool _isUpdate)
        external
        onlyOwner
        nonReentrant
    {
        DataTypes.HospitalStruct memory hospital = s_hospitals[_hospitalAddress];
        if (hospital.isValid == true && _isUpdate == false) {
            revert Errors.Myriad__HospitalAlreadyRegistered();
        }

        hospital = DataTypes.HospitalStruct(_hospitalAddress, _hospitalInfo, true);

        s_hospitals[_hospitalAddress] = hospital;

        // minting and delegating voting power to the hospital.
        mintAndDelegateTokens(_hospitalAddress, 4); // every hospital will get exactly 4 tokens.

        //emitting the event.
        emit Events.HospitalListed(_hospitalAddress, _hospitalInfo, block.timestamp);
    }

    /// @dev This is protected by {{onlyOwner}} modifier
    function registerClinic(address _clinicAddress, string calldata _clinciInfo, bool _isUpdate)
        external
        onlyOwner
        nonReentrant
    {
        DataTypes.ClinicStruct memory clinic = s_clinic[_clinicAddress];
        if (clinic.isValid == true && _isUpdate == false) {
            revert Errors.Myriad__ClinicAlreadyRegistered();
        }

        clinic = DataTypes.ClinicStruct(_clinicAddress, _clinciInfo, true);

        s_clinic[_clinicAddress] = clinic;

        // minting and delegating voting power to the clinic.
        mintAndDelegateTokens(_clinicAddress, 3); // every clinic will get exactly 3 tokens.

        //emitting the event.
        emit Events.ClinicListed(_clinicAddress, _clinciInfo, block.timestamp);
    }

    /// @dev This is protected by {{onlyOwner}} modifier.
    function registerDiagnosticLab(address _diagnosticLabAddress, string calldata _diagnosticLabInfo, bool _isUpdate)
        external
        onlyOwner
        nonReentrant
    {
        DataTypes.DiagnosticLabStruct memory diagnosticLab = s_diagnosticLab[_diagnosticLabAddress];

        if (diagnosticLab.isValid == true && _isUpdate == false) {
            revert Errors.Myriad__DiagnosticLabAlreadyRegistered();
        }

        diagnosticLab = DataTypes.DiagnosticLabStruct(_diagnosticLabAddress, _diagnosticLabInfo, true);

        s_diagnosticLab[_diagnosticLabAddress] = diagnosticLab;

        // minting and delegating voting power to the diagnostic lab.
        mintAndDelegateTokens(_diagnosticLabAddress, 3); // every diagnostic lab will get exactly 3 tokens.

        //emitting the event.
        emit Events.DiagnosticLabListed(_diagnosticLabAddress, _diagnosticLabInfo, block.timestamp);
    }

    /// @dev Returns the details of the patient. The sensitive medical files itself are encrypted.
    function getPatientDetails(address _patientAddress) external view returns (address, string memory, bool) {
        DataTypes.PatientStruct memory patient = s_patients[_patientAddress];
        return (patient.patientAddress, patient.patientInfo, patient.isValid);
    }

    /// @dev Returns the details of the doctor
    function getDoctorDetails(address _doctorAddress) external view returns (address, string memory, bool) {
        DataTypes.DoctorStruct memory doctor = s_doctors[_doctorAddress];
        return (doctor.doctorAddress, doctor.doctorInfo, doctor.isValid);
    }

    /// @dev Returns the details of the hospital
    function getHospitalDetails(address _hospitalAddress) external view returns (address, string memory, bool) {
        DataTypes.HospitalStruct memory hospital = s_hospitals[_hospitalAddress];
        return (hospital.hospitalAddress, hospital.hospitalInfo, hospital.isValid);
    }

    /// @dev Returns the details of the clinic
    function getClinicDetails(address _clinicAddress) external view returns (address, string memory, bool) {
        DataTypes.ClinicStruct memory clinic = s_clinic[_clinicAddress];
        return (clinic.clinicAddress, clinic.clinicInfo, clinic.isValid);
    }

    /// @dev Returns the details of the diagnostic lab
    function getDiagnosticLabDetails(address _diagnosticLabAddress)
        external
        view
        returns (address, string memory, bool)
    {
        DataTypes.DiagnosticLabStruct memory diagnosticLab = s_diagnosticLab[_diagnosticLabAddress];
        return (diagnosticLab.diagnosticLabAddress, diagnosticLab.diagnosticLabInfo, diagnosticLab.isValid);
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
