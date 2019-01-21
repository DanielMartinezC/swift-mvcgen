//
//  RegisterVC.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit
import Pastel

class RegisterVC: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Outlets

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var cellphoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createAccountButton: LoadingButton!{
        didSet{
            createAccountButton.addShadow()
        }
    }
    @IBOutlet weak var acceptTermsButton: UIButton!
    
    // MARK: - Properties

    private var pastelView: PastelView!
    
    private var termsAndConditionsAccepted: Bool = false
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFieldsDelegate()
        
        configureText()
        
        configureViews()
        
        hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.pastelView.startAnimation()
    }
    
    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTage = textField.tag+1
        
        // Try to find next responder
        guard let nextResponder = textField.superview?.superview?.superview?.viewWithTag(nextTage) as UIResponder? else {
            textField.resignFirstResponder()
            return false
        }
        
        nextResponder.becomeFirstResponder()
        
        return false // We do not want UITextField to insert line-breaks.
    }
    
    // MARK: - Actions
    
    @IBAction func createTapped(_ sender: UIButton) {

        if self.validateForm(){
            if let email = self.emailTextField.text, let password = self.passwordTextField.text, let name = self.nameTextField.text, let lastname = self.lastnameTextField.text, let cellphone = self.cellphoneTextField.text {
                self.createAccountButton.showLoading()
                APIManager.sharedInstance.signup(withParameters: APIRequestBody.getSignupBody(withEmail: email, withPassword: password, withFirstName: name, withLastname: lastname, withPhone: cellphone, withProfilePic: "", withStudies: "", withCertifications: "", withAbout: ""), completion: {
                    result, user in
                    if result == .success {
                        APIManager.sharedInstance.login(withParameters: APIRequestBody.getLoginBody(withEmail: email, withPassword: password), completion: {
                            result in
                            self.createAccountButton.hideLoading()
                            if result == .success {
                                self.performSegue(withIdentifier: "SuccesfullySignup", sender: nil)
                            }
                        })
                    } else {
                        self.createAccountButton.hideLoading()
                    }
                })
            }
        }
    }
    
    @IBAction func termsTapped(_ sender: UIButton) {

        if !termsAndConditionsAccepted {
            let tintedImage = Asset.tick.image.withRenderingMode(.alwaysTemplate)
            sender.setImage(tintedImage, for: .normal)
            sender.tintColor = UIColor.init(red: 51/255, green: 125/255, blue: 173/255, alpha: 1.0)
            if let image = sender.imageView {
                sender.bringSubview(toFront: image)
            }
            termsAndConditionsAccepted = true
        } else {
            sender.setImage(nil, for: .normal)
            termsAndConditionsAccepted = false
        }
    }
    
    @IBAction func termsAndConditionsTapped(_ sender: UIButton) {
        // TODO: URL
        if let url = URL(string: "/terms-and-conditions") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func alreadyHaveAccountTapped(_ sender: UIButton) {

        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private

    private func setupTextFieldsDelegate(){
        
        self.nameTextField.delegate = self
        self.lastnameTextField.delegate = self
        self.cellphoneTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
    }
    
    private func configureText(){
        
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                       attributes: [
                                                                           NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                                                                           NSAttributedStringKey.font: Fonts.roboto(type: 1, fontSize: 17)
                                                                           ])
        
        self.nameTextField.attributedPlaceholder = NSAttributedString(string: "Name",
                                                                          attributes: [
                                                                              NSAttributedStringKey.foregroundColor: UIColor.lightGray, 
                                                                              NSAttributedStringKey.font: Fonts.roboto(type: 1, fontSize: 17)
                                                                              ])
        
        self.lastnameTextField.attributedPlaceholder = NSAttributedString(string: "Lastname",
                                                                          attributes: [
                                                                              NSAttributedStringKey.foregroundColor: UIColor.lightGray, 
                                                                              NSAttributedStringKey.font: Fonts.roboto(type: 1, fontSize: 17)
                                                                              ])
        
        self.cellphoneTextField.attributedPlaceholder = NSAttributedString(string: "Cellphone (optional)",
                                                                          attributes: [
                                                                              NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                                                                              NSAttributedStringKey.font: Fonts.roboto(type: 1, fontSize: 17)
                                                                            ])
        
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                          attributes: [
                                                                              NSAttributedStringKey.foregroundColor: UIColor.lightGray, 
                                                                              NSAttributedStringKey.font: Fonts.roboto(type: 1, fontSize: 17)
                                                                              ])
        
        self.confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm password",
                                                                            attributes: [
                                                                                NSAttributedStringKey.foregroundColor: UIColor.lightGray, 
                                                                                NSAttributedStringKey.font: Fonts.roboto(type: 1, fontSize: 17)
                                                                                ])
    }
    
    private func configureViews(){

        self.pastelView = PastelView(frame: self.tableView.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors([Colors.firstGradientColor, Colors.textColor, Colors.secondGradientColor, Colors.thirdGradientColor])
        
        self.tableView.backgroundView = pastelView
        
    }
    
    private func validateForm() -> Bool {
        
        if let password = self.passwordTextField.text, let confirmPassword = self.confirmPasswordTextField.text {
            if password != confirmPassword {
                APIHelper.sharedInstance.showErrorMessage(with: "Passwords don't match", and: "")
                return false
            }
        }
        if !self.nameTextField.isName() {
            APIHelper.sharedInstance.showErrorMessage(with: "Check the entered data", and: "")
            return false
        }
        if !self.lastnameTextField.isName() {
            APIHelper.sharedInstance.showErrorMessage(with: "Check the entered data", and: "")
            return false
        }
        
        if !self.emailTextField.isEmail(){
            APIHelper.sharedInstance.showErrorMessage(with: "Invalid email", and: "")
            return false
        }
        if !termsAndConditionsAccepted{
            APIHelper.sharedInstance.showErrorMessage(with: "Check the entered data", and: "You have to accept terms & conditions")
            return false
        }
        return true
    }
    
}
