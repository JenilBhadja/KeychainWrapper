//pod 'SwiftKeychainWrapper'

import SwiftKeychainWrapper

//KEYCHAIN Login
let KEYCHAIN_MyLoginEmail = "myLoginEmail"
let KEYCHAIN_MyLoginPassword = "myLoginPassword"

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    //Retreive From Keychain
    let _ = self.retrieveDataFromKeychain(isFromLogin: false)
}

@IBAction func btnRememberme_clk(_ sender: UIButton) {    
    if isValidated {
        self.txtUsername.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
        
        self.btnRememberMe.isSelected = !self.btnRememberMe.isSelected
        
        if !self.btnRememberMe.isSelected {
            //Remove from keychain
            self.removeDataFromKeychain()
        }
    }
}

//AFTER LOGIN RESPONSE use set this

//Retreive From Keychain
let isRetrieved = self.retrieveDataFromKeychain(isFromLogin: true)

if isRetrieved.0 == self.txtUsername.text,
   isRetrieved.1 == self.txtPassword.text {
    if self.btnRememberMe.isSelected {
        //Save to keychain
        self.saveDataToKeychain()

    } else {
        //Remove from keychain
        self.removeDataFromKeychain()
    }
} else {
    //Remove from keychain
    self.removeDataFromKeychain()

    if self.btnRememberMe.isSelected {
        //Save to keychain
        self.saveDataToKeychain()
    }
}



//MARK: - Save/Retreive/Remove data Keychain Methods
func saveDataToKeychain() {
    let saveEmailSuccessful: Bool = KeychainWrapper.standard.set(self.txtUsername.text ?? "", forKey: KEYCHAIN_MyLoginEmail)
    let savePasswordSuccessful: Bool = KeychainWrapper.standard.set(self.txtPassword.text ?? "", forKey: KEYCHAIN_MyLoginPassword)
    printMsg(val: "saveEmailSuccessful : \(saveEmailSuccessful)")
    printMsg(val: "savePasswordSuccessful : \(savePasswordSuccessful)")
}

func removeDataFromKeychain() {
    let removeEmailSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEYCHAIN_MyLoginEmail)
    let removePasswordSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEYCHAIN_MyLoginPassword)
    printMsg(val: "removeEmailSuccessful : \(removeEmailSuccessful)")
    printMsg(val: "removePasswordSuccessful : \(removePasswordSuccessful)")
    if removeEmailSuccessful &&
        removePasswordSuccessful {
        printMsg(val: "Removed from keychain")
    }
}

func retrieveDataFromKeychain(isFromLogin: Bool) -> (String, String) {
    if let retrievedEmail = KeychainWrapper.standard.string(forKey: KEYCHAIN_MyLoginEmail) {
//            printMsg(val: "retrievedEmail : \(retrievedEmail)")
        if let retrievedPassword = KeychainWrapper.standard.string(forKey: KEYCHAIN_MyLoginPassword) {
//                printMsg(val: "retrievedPassword : \(retrievedPassword)")
            if !isFromLogin {
                self.txtUsername.text = retrievedEmail
                self.txtPassword.text = retrievedPassword
                self.btnRememberMe.isSelected = true
            }
            return (retrievedEmail, retrievedPassword)
        }
    }
    return ("", "")
}


