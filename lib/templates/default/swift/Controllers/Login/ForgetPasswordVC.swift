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
    
    // MARK: - Outlets

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var recoverView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: LoadingButton!

    // MARK: - Properties

    weak var delegate: ForgetPasswordVCDelegate?
    private var keyboardIsShowing: Bool = false
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        
        tap.delegate = self
        
        self.backgroundView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasHidden), name: UIResponder.keyboardWillHideNotification, object: nil);

    }

    override func viewDidLayoutSubviews() {
        view.backgroundColor = UIColor.clear
        
        //ensure that the icon embeded in the cancel button fits in nicely
        cancelButton.imageView?.contentMode = .scaleAspectFit
    }
    
    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
       
       let result = (keyboardIsShowing || touch.view?.restorationIdentifier != "backViewID") ? false : true
       return result
    }
    
    @objc func dismissView(){

        dismiss(animated: true, completion: nil)
        delegate?.removeBlurredBackgroundView()
    }
    
    
    @objc func keyboardWasShown(notification: NSNotification) {
        
        self.keyboardIsShowing = true
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.bottomConstraint.constant = 287
            self.topConstraint.constant = 10
        })
    }
    
    @objc func keyboardWasHidden(notification: NSNotification) {
        
        self.keyboardIsShowing = false
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.topConstraint.constant = 148.5
            self.bottomConstraint.constant = 148.5
        })
    }
    
    // MARK: - Actions

    @IBAction func cancelTapped(_ sender: UIButton) {

        self.dismissView()
    }
    
    @IBAction func sendTapped(_ sender: UIButton) {
        
        if self.emailTextField.isEmail() {
            if let email = self.emailTextField.text {
            self.sendButton.showLoading()
            APIManager.sharedInstance.forgotPwd(withParameters: APIRequestBody.forgotPwd(withEmail: email), completion: {
                result in
                self.sendButton.hideLoading()
                if result == .success {
                    APIHelper.sharedInstance.showSuccesMessage(with: "Email sent!", and: "")
                }
            })
            } else {
                APIHelper.sharedInstance.showErrorMessage(with: "Invalid email", and: "")
            }
        }
    }
    
}
