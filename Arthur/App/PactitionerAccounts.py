from web3 import Web3
import json
import MyContract as TheCon


w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:7545"))

w3.eth.defaultAccount = w3.eth.accounts[0]

contract_address= Web3.toChecksumAddress("0x03DCaaFe7509ecC941A2DE136C7db8B103c010FD")

with open(r'C:/Users/tinob\Desktop/Presantation/Arthur/build/contracts/PractitionerContract.json') as file:
    contract_abi_1 = json.load(file)

    contract_abi = contract_abi_1['abi']


# Create the contract instance
contract = w3.eth.contract(address=contract_address, abi=contract_abi)




def AddMedicalPractitioner(_Name, _Institute, _Qualification, _RegistrationNumber, _HomeAddress, _NationalID, _WorkAddress, _WorkNumber, _WorkEmail, _Specialities):
    for a in w3.eth.accounts:
        if TheCon.GetPersonalDetails(a, a)[0]=="" and GetMedicalPractitioner(a)[0]=='':
            contract.functions.AddMedicalPractitioner(_Name, _Institute, _Qualification, _RegistrationNumber, _HomeAddress, _NationalID, _WorkAddress, _WorkNumber, _WorkEmail, _Specialities).transact({'from':a})
            return a

def GetMedicalPractitioner(_Person):
    return contract.functions.GetMedicalPractitioner(_Person).call()


def GetAllPractitioners():
    return contract.functions.GetRegisteredUsers().call()


def GetAddressFromNationalID(_NationalID):
    return contract.functions.GetAddressFromNationalID(_NationalID).call()


if __name__=='__main__':
    print("Hello World")
    contract.functions.AddMedicalPractitioner('Dr Ali', 'Parerenyatwa', 'MBChB', '123456', 'Somewhere far', '43-4806396U62', 'Somewhere far', '0212345678', 'ali@pare.com', 'Cardiologist').transact({'from':w3.eth.accounts[1]})

     