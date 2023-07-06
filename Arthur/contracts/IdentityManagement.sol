// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.9.0;

contract IdentityManagement {


struct PersonalDetails {
    string Name;
    string Date_Of_Birth;
    string Email;
    string CellNumber;
    string PhoneNumber;
    string HomeAddress;
    string NationalID;
    string PassportNumber;
    string PassportExpiryDate;
    bool EmploymentStatus;
    string MaxEducation;
}

struct BloodType {
  string BloodType;
  address BloodTypeAdder;
}

struct Prescription {
  string Prescription;
  bool PrescriptionFilled;
  string PrescriptionDate;
  address PrescriptionAdder;
}

struct Diagnosis {
  string Diagnosis;
  string DiagnosisDate;
  address DiagnosisAdder;
}

struct MedicalTest {
  string MedicalTest;
  string MedicalTestDate;
  string MedicalTestResult;
  address MedicalTestAdder;
}

struct DocumentStruct{
    string DocumentHash;
    string DocumentFileType;
    string[] DocumentTags;
}

mapping (address => PersonalDetails) public userDetails;
mapping (address =>string[]) public Allergies;
mapping (address =>string[]) public RegiateredDocuments;
mapping (address =>string[]) public MedicalConditions;
mapping (address =>BloodType) public BloodTypes;
mapping (address =>Prescription[]) public Prescriptions;
mapping (address =>Diagnosis[]) public Diagnoses;
mapping (address =>MedicalTest[]) public MedicalTests;
mapping (address =>mapping(string=>DocumentStruct)) public Documents;//{address=>{documentType=>DocumentStruct}
mapping (string => address) public NationalIDToAddress;

address[] public RegisteredUsers;

function AddDocument(string memory _DocumentType, string memory _DocumentHash, address _Person, string memory _DocumentFileType) public {
    Documents[_Person][_DocumentType].DocumentHash = _DocumentHash;
    Documents[_Person][_DocumentType].DocumentFileType = _DocumentFileType;


    
    RegiateredDocuments[_Person].push(_DocumentType);
}



function AddPersonalDetails(string memory _Name, string memory _Date_Of_Birth, string memory _Email, string memory _CellNumber, string memory _PhoneNumber, string memory _HomeAddress, string memory _NationalID, string memory _PassportNumber, string memory _PassportExpiryDate, bool _EmploymentStatus, string memory _MaxEducation) public {
    userDetails[msg.sender].Name = _Name;
    userDetails[msg.sender].Date_Of_Birth = _Date_Of_Birth;
    userDetails[msg.sender].Email = _Email;
    userDetails[msg.sender].CellNumber = _CellNumber;
    userDetails[msg.sender].PhoneNumber = _PhoneNumber;
    userDetails[msg.sender].HomeAddress = _HomeAddress;
    userDetails[msg.sender].NationalID = _NationalID;
    userDetails[msg.sender].PassportNumber = _PassportNumber;
    userDetails[msg.sender].PassportExpiryDate = _PassportExpiryDate;
    userDetails[msg.sender].EmploymentStatus = _EmploymentStatus;
    userDetails[msg.sender].MaxEducation = _MaxEducation;
    NationalIDToAddress[_NationalID] = msg.sender;

    RegisteredUsers.push(msg.sender);
}


function GetRegisteredUsers() public view returns (address[] memory) {
    return RegisteredUsers;
}




function AddAllergies(string memory _Allergy, address _Person) public {
    Allergies[_Person].push(_Allergy);
}

function AddMedicalConditions(string memory _MedicalCondition, address _Person) public {
    MedicalConditions[_Person].push(_MedicalCondition);
}

function AddBloodType(string memory _BloodType, address _Person) public {
    BloodTypes[_Person].BloodType = _BloodType;
    BloodTypes[_Person].BloodTypeAdder = msg.sender;
}

function AddPrescription(string memory _Prescription, bool _Status , string memory _PrescriptionDate, address _Person) public {
    Prescriptions[_Person].push(Prescription(_Prescription,_Status, _PrescriptionDate, msg.sender));
}

function AddPrescriptionStatus(uint _PrescriptionIndex, bool _Status, address _Person) public {
    Prescriptions[_Person][_PrescriptionIndex].PrescriptionFilled = _Status;
}

function AddDiagnosis(string memory _Diagnosis, string memory _DiagnosisDate, address _Person) public {
    Diagnoses[_Person].push(Diagnosis(_Diagnosis, _DiagnosisDate, msg.sender));
}

function AddMedicalTest(string memory _MedicalTest, string memory _MedicalTestDate, string memory _MedicalTestResult, address _Person) public {
    MedicalTests[_Person].push(MedicalTest(_MedicalTest, _MedicalTestDate, _MedicalTestResult, msg.sender));
}

function UpdateMedicalTestResult(uint _MedicalTestIndex, string memory _MedicalTestResult, address _Person) public {
    MedicalTests[_Person][_MedicalTestIndex].MedicalTestResult = _MedicalTestResult;
}



function GetAddressFromNationalID(string memory _NationalID) public view returns (address) {
    return NationalIDToAddress[_NationalID];
}

function GetPersonalDetails(address _Person) public view returns (PersonalDetails memory) {
    return userDetails[_Person];

}


function GetAllergies(address _Person) public view returns (string[] memory) {
    return Allergies[_Person];
}

function GetMedicalConditions(address _Person) public view returns (string[] memory) {
    return MedicalConditions[_Person];
}

function GetBloodType(address _Person) public view returns (BloodType memory) {
    return BloodTypes[_Person];
}

function GetPrescriptions(address _Person) public view returns (Prescription[] memory) {
    return Prescriptions[_Person];
}

function GetDiagnoses(address _Person) public view returns (Diagnosis[] memory) {
    return Diagnoses[_Person];
}

function GetMedicalTests(address _Person) public view returns (MedicalTest[] memory) {
    return MedicalTests[_Person];
}

//get document function
function GetDocument(string memory _DocumentType, address _Person) public view returns (DocumentStruct memory) {
    return Documents[_Person][_DocumentType];
}

function GetRegisteredDocuments(address _Person) public view returns (string[] memory) {
    return RegiateredDocuments[_Person];
}




}