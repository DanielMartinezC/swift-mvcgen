//
//  ForgetPasswordVC.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import Foundation

import UIKit

protocol ForgetPasswordVCDelegate: class {
    func removeBlurredBackgroundView()
}
class ForgetPasswordVC: UIViewController, UIGestureRecognizerDelegate {
    
    weak var delegate: ForgetPasswordVCDelegate?
    private var keybaordIsShowing: Bool = false
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var recoverView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: LoadingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        
        tap.delegate = self
        
        self.backgroundView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: .UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasHidden), name: .UIKeyboardWillHide, object: nil);
        
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if keybaordIsShowing {
            return false
        }
        if touch.view?.restorationIdentifier == "backViewID" {
            return true
        }
        return false
    }
    
    @objc func dismissView(){
        dismiss(animated: true, completion: nil)
        delegate?.removeBlurredBackgroundView()
    }
    
    
    @objc func keyboardWasShown(notification: NSNotification) {
        
        self.keybaordIsShowing = true
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.bottomConstraint.constant = 287
            self.topConstraint.constant = 10
        })
    }
    
    @objc func keyboardWasHidden(notification: NSNotification) {
        
        self.keybaordIsShowing = false
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.topConstraint.constant = 148.5
            self.bottomConstraint.constant = 148.5
        })
    }
    
    override func viewDidLayoutSubviews() {
        view.backgroundColor = UIColor.clear
        
        //ensure that the icon embeded in the cancel button fits in nicely
        cancelButton.imageView?.contentMode = .scaleAspectFit
        
        //add a white tint color for the Cancel button image
//        let cancelImage = UIImage(named: "Cancel")
        
//        let tintedCancelImage = cancelImage?.withRenderingMode(.alwaysTemplate)
//        cancelButton.setImage(tintedCancelImage, for: .normal)
//        cancelButton.tintColor = .white
    }
    
    // MARK: - Actions
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.dismissView()
    }
    
    @IBAction func sendTapped(_ sender: UIButton) {
        if let email = self.emailTextField.text, isValidEmail(email) {
            self.sendButton.showLoading()
            APIManager.sharedInstance.forgotPwd(withParameters: APIRequestBody.forgotPwd(withEmail: email), completion: {
                result in
                self.sendButton.hideLoading()
                if result == .success {
                    APIHelper.sharedInstance.showSuccesMessage(with: NSLocalizedString("Email sent!", comment: ""), and: "")
                }
            })
        } else {
            APIHelper.sharedInstance.showErrorMessage(with: NSLocalizedString("Invalid email", comment: ""), and: "")
        }
    }
    
    // MARK: - Private
    
    private func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
}
