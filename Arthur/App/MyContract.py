from web3 import Web3
import json
import PactitionerAccounts as ThePrac


w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:7545"))

w3.eth.defaultAccount = w3.eth.accounts[0]

contract_address= Web3.toChecksumAddress("0xf486eb56871767f059d698b36e516FbBD04524ef")

with open(r'C:/Users/tinob\Desktop/Presantation/Arthur/build/contracts/IdentityManagement.json') as file:
    contract_abi_1 = json.load(file)

    contract_abi = contract_abi_1['abi']


# Create the contract instance
contract = w3.eth.contract(address=contract_address, abi=contract_abi)


def AddAPersonalDetails(_Name, _Date_Of_Birth, _Email, _CellNumber, _PhoneNumber, _HomeAddress, _NationalID, _PassportNumber, _PassportExpiryDate, _EmploymentStatus, _MaxEducation):
    for a in w3.eth.accounts:
        if GetPersonalDetails(a, a)[0]=="" and ThePrac.GetMedicalPractitioner(a)[0]=='':
            contract.functions.AddPersonalDetails(_Name, _Date_Of_Birth, _Email, _CellNumber, _PhoneNumber, _HomeAddress, _NationalID, _PassportNumber, _PassportExpiryDate, _EmploymentStatus, _MaxEducation).transact({'from':a})
            return a


def AddAAllergies(_Allergy, _Person, adder):
    contract.functions.AddAllergies(_Allergy, _Person).transact({'from':adder})
    return 'Success'

def AddAMedicalConditions(_MedicalCondition, _Person, adder):
    contract.functions.AddMedicalConditions(_MedicalCondition, _Person).transact({'from':adder})
    return 'Success'


def AddABloodType(_BloodType, _Person, adder):
    contract.functions.AddBloodType(_BloodType, _Person).transact({'from':adder})
    return 'Success' 


def AddAPrescription(_Prescription,_Status , _PrescriptionDate,_Person, adder):
    contract.functions.AddPrescription(_Prescription,_Status , _PrescriptionDate,_Person).transact({'from':adder})
    return 'Success'


def UpadatePrescriptionStatus(_PrescriptionIndex,  _Status, _Person, adder):
    contract.functions.AddPrescriptionStatus(_PrescriptionIndex,  _Status, _Person).transact({'from':adder})
    return 'Success'


def AddDiagnosis(_Diagnosis, _DiagnosisDate, _Person, adder):
    contract.functions.AddDiagnosis(_Diagnosis, _DiagnosisDate, _Person).transact({'from':adder})
    return 'Success'

def AddMedicalTest(_MedicalTest, _MedicalTestDate,  _Person, adder):
    contract.functions.AddMedicalTest(_MedicalTest, _MedicalTestDate, "NA",  _Person).transact({'from':adder})
    return 'Success'


def UpdateMedicalTestResult(_MedicalTestIndex, _MedicalTestResult, _Person, adder):
    contract.functions.UpdateMedicalTestResult(_MedicalTestIndex, _MedicalTestResult, _Person).transact({'from':adder})
    return 'Success'


def AddDocument(_DocumentType,_DocumentHash, _Person, _DocumentFileType):
    contract.functions.AddDocument(_DocumentType,_DocumentHash, _Person, _DocumentFileType).transact({'from':_Person})
    return 'Success'

def GetAddressFromNationalID(_NationalID, adder):
    return contract.functions.GetAddressFromNationalID(_NationalID).call({'from':adder})


def  GetPersonalDetails(_Person, adder):
    return contract.functions.GetPersonalDetails(_Person).call({'from':adder})


def GetAllergies(_Person, adder):
    return contract.functions.GetAllergies(_Person).call({'from':adder})

def GetMedicalConditions(_Person, adder):
    return contract.functions.GetMedicalConditions(_Person).call({'from':adder})


def GetBloodType(_Person, adder):
    return contract.functions.GetBloodType(_Person).call({'from':adder})

def GetPrescriptions(_Person, adder):
    return contract.functions.GetPrescriptions(_Person).call({'from':adder})

def GetDiagnoses(_Person, adder):
    return contract.functions.GetDiagnoses(_Person).call({'from':adder})

def GetMedicalTests(_Person, adder):
    return contract.functions.GetMedicalTests(_Person).call({'from':adder})

def GetDocument(_Person, _DocumentType, adder):
    return contract.functions.GetDocument( _DocumentType,_Person).call({'from':adder})

def GetRegisteredDocuments(_Person):
    return contract.functions.GetRegisteredDocuments(_Person).call()

def GetAllUsers():
    return contract.functions.GetRegisteredUsers().call()


if __name__=='__main__':
    print("Hello World")
    contract.functions.AddPersonalDetails("Arthur Bunya", "01/01/2000", "aturo@gmail.com", "0712345678", "0212345678", "Somewhere far", "43-4806396U62", "6396U62", "01/01/2030", True, "Degree").transact({'from':w3.eth.accounts[0]})
    