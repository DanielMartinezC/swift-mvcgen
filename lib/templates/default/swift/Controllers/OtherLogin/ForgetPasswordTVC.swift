//
//  ForgetPasswordVC.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit

class ForgetPasswordTVC: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backgroundGradientView: UIView!
    
    @IBOutlet weak var sendLinkButton: LoadingButton!
    
    @IBOutlet weak var emailTextField: UnderlinedWithIconTextField!
    
    @IBOutlet weak var instructionsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        hideKeyboardWhenTappedAround()
    }
    
    func setupViews() {
        self.sendLinkButton.layoutIfNeeded()
        self.sendLinkButton.layer.cornerRadius = self.sendLinkButton.frame.height/7
        self.sendLinkButton.layer.masksToBounds = true
        self.sendLinkButton.activityIndicatorColor = UIColor.white
        
        self.emailTextField.underlined(color: UIColor.white, width: 1.0)
        self.emailTextField.addLeftIcon("envelope")

        self.instructionsLabel.textAlignment = NSTextAlignment.center
        
        self.emailTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.backgroundGradientView.applyGradient(withColours: [ColorConstants.firstGradientColor, ColorConstants.secondGradientColor, ColorConstants.thirdGradientColor], locations: [0, 0.2, 0.98])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 0 {
            textField.resignFirstResponder()
            forgetPasswordTapped()
            return true
        }
        
        let nextTage = textField.tag+1
        
        // Try to find next responder
        guard let nextResponder = textField.superview?.superview?.superview?.viewWithTag(nextTage) as UIResponder? else {
            textField.resignFirstResponder()
            return false
        }
        
        nextResponder.becomeFirstResponder()

        return false // We do not want UITextField to insert line-breaks.
    }
    
    private func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func sendLinkTapped(_ sender: LoadingButton) {
        forgetPasswordTapped()
    }
    
    private func forgetPasswordTapped(){
        if let email = self.emailTextField.text, isValidEmail(email){
            self.sendLinkButton.showLoading()
            // TODO:
//            RemoteUserRepository.sharedInstance.forgetPassword(email: email) { result in
//                self.sendLinkButton.hideLoading()
//                if result == .success{
//                    APIHelper.sharedInstance.showSuccesMessage(with: NSLocalizedString("Email sent!", comment: ""), and: "")
//                }
//            }
        } else {
            APIHelper.sharedInstance.showErrorMessage(with: NSLocalizedString("Invalid email", comment: ""), and: "")
        }
    }
    
    @IBAction func handleCloseButton(_ sender: UIButton) {
         dismiss(animated: true, completion: nil)
    }
}
