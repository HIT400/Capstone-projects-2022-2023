// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.9.0;

contract PractitionerContract {

struct MedicalPractitioner{
  string Name;
  string Institute; // queenmar clinic
  string Qualification; // MBChB
  string RegistrationNumber; // 123456789
  string HomeAddress;
  string NationalID;
  string WorkAddress;
  string WorkNumber;
  string WorkEmail;
  string Specialities;

}

mapping (address => MedicalPractitioner) public MedicalPractitioners; // {address=>MedicalPractitioner}
mapping (string => address) public NationalIDToAddressP;
address[] public RegisteredPrac;

function AddMedicalPractitioner(string memory _Name, string memory _Institute, string memory _Qualification, string memory _RegistrationNumber, string memory _HomeAddress, string memory _NationalID, string memory _WorkAddress, string memory _WorkNumber, string memory _WorkEmail, string memory _Specialities) public {
    MedicalPractitioners[msg.sender].Name = _Name;
    MedicalPractitioners[msg.sender].Institute = _Institute;
    MedicalPractitioners[msg.sender].Qualification = _Qualification;
    MedicalPractitioners[msg.sender].RegistrationNumber = _RegistrationNumber;
    MedicalPractitioners[msg.sender].HomeAddress = _HomeAddress;
    MedicalPractitioners[msg.sender].NationalID = _NationalID;
    MedicalPractitioners[msg.sender].WorkAddress = _WorkAddress;
    MedicalPractitioners[msg.sender].WorkNumber = _WorkNumber;
    MedicalPractitioners[msg.sender].WorkEmail = _WorkEmail;
    MedicalPractitioners[msg.sender].Specialities = _Specialities;
    NationalIDToAddressP[_NationalID] = msg.sender;
    RegisteredPrac.push(msg.sender);
}


function GetRegisteredUsers() public view returns (address[] memory) {
    return RegisteredPrac;
}

function GetMedicalPractitioner(address _Person) public view returns (MedicalPractitioner memory) {
    return MedicalPractitioners[_Person];
}

function GetAddressFromNationalIDP(string memory _NationalID) public view returns (address) {
    return NationalIDToAddressP[_NationalID];}


}