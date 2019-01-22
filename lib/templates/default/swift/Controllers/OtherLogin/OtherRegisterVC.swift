//
//  OtherRegisterVC.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit
import TextFieldEffects
import ActionSheetPicker_3_0

class OtherRegisterVC: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet var gradientView: UITableView!
    @IBOutlet weak var emailTextField: UnderlinedWithIconTextField!
    @IBOutlet weak var nameTextField: UnderlinedWithIconTextField!
    @IBOutlet weak var lastnameTextField: UnderlinedWithIconTextField!
    @IBOutlet weak var passwordTextField: UnderlinedWithIconTextField!
    @IBOutlet weak var birthdateTextField: UnderlinedWithIconTextField!
    
    @IBOutlet weak var cellphoneTextField: UnderlinedWithIconTextField!
    
    
    @IBOutlet weak var acceptTermsAndConditionsButton: UIButton!{
        didSet {
            acceptTermsAndConditionsButton.layer.masksToBounds = true
            acceptTermsAndConditionsButton.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var termsAndConditionsButton: UIButton!
    @IBOutlet weak var registerButton: LoadingButton!
    
    @IBOutlet weak var phonePrefix: UILabel!
    @IBOutlet weak var phoneFlagImage: UIImageView!
    @IBOutlet weak var phoneFlagLabel: UILabel!
    
    // MARK: - Properties
    var termsAndConditionsAccepted = false
    var phoneCountry = "Uruguay" // ArrayConstants.countries[0]
    var dateFormate = Bool()
    
    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupViews()
        
        hideKeyboardWhenTappedAround()
        
//        fetchCountries()
    }
    
    func setupViews() {
        self.registerButton.layoutIfNeeded()
        self.registerButton.layer.cornerRadius = self.registerButton.frame.height/7
        self.registerButton.layer.masksToBounds = true
        self.registerButton.activityIndicatorColor = ColorConstants.firstGradientColor
        
        emailTextField.underlined(color: UIColor.white, width: 1.0)
        nameTextField.underlined(color: UIColor.white, width: 1.0)
        lastnameTextField.underlined(color: UIColor.white, width: 1.0)
        passwordTextField.underlined(color: UIColor.white, width: 1.0)
        cellphoneTextField.underlined(color: UIColor.white, width: 1.0)
        
        if let firstCountry = self.countries.first {
            self.phoneFlagLabel.text = firstCountry.flag
            self.phoneCountry = firstCountry.name
            self.phonePrefix.text = firstCountry.dial_code
        } else {
            self.phoneFlagLabel.text = "🇺🇾"
            self.phoneCountry = "Uruguay"
            self.phonePrefix.text = "+598"
        }
    
        self.emailTextField.delegate = self
        self.nameTextField.delegate = self
        self.lastnameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.cellphoneTextField.delegate = self
    }
    
    func fetchCountries(){
        // TODO
//        RemoteUserRepository.sharedInstance.getCountries() {
//            result, countries in
//            if result == .success {
//                self.countries = countries
//            }
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientView.applyGradient(withColours: [ColorConstants.firstGradientColor, ColorConstants.secondGradientColor, ColorConstants.thirdGradientColor], locations: [0, 0.2, 0.98])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTage = textField.tag+1
        
        // Try to find next responder
        guard let nextResponder = textField.superview?.superview?.superview?.viewWithTag(nextTage) as UIResponder? else{
            textField.resignFirstResponder()
            return false
        }
        
        nextResponder.becomeFirstResponder()
        
        return false
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        //Format Date of Birth dd-MM-yyyy
//        
//        //initially identify your textfield
//        if textField == birthdateTextField {
//            
//            // check the chars length dd -->2 at the same time calculate the dd-MM --> 5
//            if (birthdateTextField?.text?.count == 2) || (birthdateTextField?.text?.count == 5) {
//                //Handle backspace being pressed
//                if !(string == "") {
//                    // append the text
//                    birthdateTextField?.text = (birthdateTextField?.text)! + "-"
//                }
//            }
//            // check the condition not exceed 9 chars
//            return !(textField.text!.count > 9 && (string.count ) > range.length)
//        }
//        else {
//            return true
//        }
//    }
    
    @IBAction func acceptTermsTapped(_ sender: UIButton) {
        if !termsAndConditionsAccepted {
            sender.setImage(Asset.tick.image, for: .normal)
            sender.bringSubviewToFront(sender.imageView!)
            termsAndConditionsAccepted = true
            //registerButton.isEnabled = true
        } else {
            sender.setImage(nil, for: .normal)
            termsAndConditionsAccepted = false
            //registerButton.isEnabled = false
        }
    }
    
    @IBAction func termsAndConditionsTapped(_ sender: UIButton) {
        // TODO: View url
        if let url = URL(string: "http://notatourapp.com/terms-and-conditions") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
//    @IBAction func registerTapped(_ sender: UIButton) {
//        if self.validateFields() {
//
////            let dateFormatter = DateFormatter()
////            dateFormatter.dateFormat = "dd/MM/yyyy"
////            let birthdate = dateFormatter.date(from: birthdateTextField.text ?? "")
//
//            // birthday: (birthdate?.timeIntervalSince1970)!
//            UserRepository.sharedInstance.signup(
//                email: self.emailTextField.text ?? "",
//                password: self.passwordTextField.text ?? "",
//                name: self.nameTextField.text ?? "",
//                lastname: self.lastnameTextField.text ?? ""
//                ) { result, message in
//
//                    if result == .success {
//                        self.performSegue(withIdentifier: "ShowHome", sender: self)
//                    } else {
//                        if let msg = message {
//                            APIHelper.sharedInstance.showErrorMessage(with: msg, and: "")
//                        } else {
//                            APIHelper.sharedInstance.showErrorMessage(with: "Error de conexión con servicios.", and: "Por favor vuelva a intentarlo.")
//                        }
//                    }
//            }
//        }
//    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        if self.validateFields() {
            var signupInfo: [String : Any] = [:]
            
            signupInfo["firstname"] = self.nameTextField.text ?? ""
            signupInfo["lastname"] = self.lastnameTextField.text ?? ""
            signupInfo["email"] = self.emailTextField.text ?? ""
            signupInfo["password"] = self.passwordTextField.text
            
            if let _ = self.phonePrefix.text, let cellPhone = self.cellphoneTextField.text{
                if cellPhone != "" {
                    signupInfo["phoneCountry"] = self.phoneCountry
                    signupInfo["phone"] = cellPhone
                }
                else{
                    signupInfo["phoneCountry"] = ""
                    signupInfo["phone"] = ""
                }
            }
            
            self.performSegue(withIdentifier: "SelectLanguage", sender: signupInfo)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectLanguage"{
            if let signupContainer = segue.destination as? SelectLanguageVC{
                signupContainer.signupInfo = sender as? [String : String]
            }
        }
    }
    
    private func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    private func isValidName(_ testStr:String) -> Bool {
        let nameRegEx = "[A-Za-z\\s]+"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: testStr)
    }
    
    private func isValidPhone(_ testStr:String) -> Bool {
        let phoneRegEx = "[0-9]*"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: testStr)
    }
    
    private func validateFields() -> Bool{
        if let name = self.nameTextField.text {
            if !isValidName(name){
                APIHelper.sharedInstance.showErrorMessage(with: NSLocalizedString("Check the entered data", comment: ""), and: "")
                return false
            }
        }
        if let lastname = self.lastnameTextField.text {
            if !isValidName(lastname){
                APIHelper.sharedInstance.showErrorMessage(with: NSLocalizedString("Check the entered data", comment: ""), and: "")
                return false
            }
        }
        if let phone = self.cellphoneTextField.text{
            if !isValidPhone(phone.trimmingCharacters(in: .whitespacesAndNewlines)) {
                APIHelper.sharedInstance.showErrorMessage(with: NSLocalizedString("Invalid phone number", comment: ""), and: "")
                return false
            }
        }
        if let email = self.emailTextField.text{
            if !isValidEmail(email.trimmingCharacters(in: .whitespacesAndNewlines)) {
                APIHelper.sharedInstance.showErrorMessage(with: NSLocalizedString("Invalid email", comment: ""), and: "")
                return false
            }
        }
        if !termsAndConditionsAccepted{
            APIHelper.sharedInstance.showErrorMessage(with: NSLocalizedString("Check the entered data", comment: ""), and: NSLocalizedString("You have to accept terms & conditions", comment: ""))
            return false
        }
        return true
    }
    
    @IBAction func selectCountryTapped(_ sender: UIButton) {
        let prevCountryValue = self.phonePrefix.text
        let prevPhoneCountryValue = self.phoneCountry
        let acp = ActionSheetStringPicker(title: "", rows: self.countries.map{$0.name}, initialSelection: 0, doneBlock: {
            picker, values, indexes in
    
            self.phonePrefix.text = self.countries[values].dial_code
            self.phoneCountry = self.countries[values].name
            self.phoneFlagLabel.text = self.countries[values].flag // UIImage(named: self.countries[values].name)
            
            return
        }, cancel: {
            ActionStringCancelBlock in
            
            self.phonePrefix.text = prevCountryValue
            self.phoneCountry = prevPhoneCountryValue
            
            return
        }, origin: sender)
        
        acp?.setTextColor(ColorConstants.firstGradientColor)
        acp?.pickerBackgroundColor = UIColor.white
        acp?.toolbarBackgroundColor = UIColor.white
        acp?.toolbarButtonsColor = ColorConstants.firstGradientColor
        acp?.show()
    }
    
    @IBAction func cancelRegisterTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
