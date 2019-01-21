//
//  LoginVC.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit
import Pastel
import FacebookLogin

class LoginVC: UITableViewController, UITextFieldDelegate, ForgetPasswordVCDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgetPasswordLabel: UILabel!
    @IBOutlet weak var loginButton: LoadingButton!{
        didSet{
            loginButton.addShadow()
        }
    }
    
    @IBOutlet weak var registerButton: UIButton!{
        didSet{
            registerButton.addShadow()
        }
    }
    
    @IBOutlet weak var facebookLoginButton: LoadingButton!{
        didSet{
            facebookLoginButton.addShadow()
        }
    }
    
    // MARK: - Properties

    private static let homeStoryboard = UIStoryboard(name: "Home", bundle: Bundle.main)

    private var pastelView: PastelView!
    
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
    
    // MARK: - Actions
    
    @IBAction func loginTapped(_ sender: UIButton) {
        self.emailLoginTapped()
    }
    
    @IBAction func facebookLoginTapped(_ sender: UIButton) {
        self.facebookLoginButton.showLoading()
        let fbLoginManager = LoginManager()
        // TODO: Comment next line after logout is done
        fbLoginManager.logOut()
        fbLoginManager.logIn(readPermissions: [.email, .userBirthday, .publicProfile], viewController: self, completion: { loginResult in
            switch loginResult {
            case .failed(let error):
                self.facebookLoginButton.hideLoading()
                print(error)
                break
            case .cancelled:
                self.facebookLoginButton.hideLoading()
                print("User cancelled login.")
                break
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
//                let photoURL = URL(string: "https://graph.facebook.com/\(accessToken.userId ?? "")/picture?type=large&return_ssl_resources=1")
                APIManager.sharedInstance.loginfb(withParameters: APIRequestBody.getFbLoginBody(withAccesToken: accessToken.authenticationToken), completion: {
                    result in
                    self.facebookLoginButton.hideLoading()
                    if result == .success {
                        self.performSegue(withIdentifier: "GoHome", sender: nil)
                    }
                })
            }
        })
    }
    
    @IBAction func forgetPasswordTapped(_ sender: UIButton) {

        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        self.overlayBlurredBackgroundView()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "ShowForgetPassword" {
                if let viewController = segue.destination as? ForgetPasswordVC {
                    viewController.delegate = self
                    viewController.modalPresentationStyle = .overFullScreen
                }
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 1 {
            textField.resignFirstResponder()
            emailLoginTapped()
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
    
    // MARK: - Private
    
    private func setupTextFieldsDelegate(){

        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }

    private func configureText(){
        
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Email", comment: ""),
                                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: Fonts.roboto(type: 1, fontSize: 17)])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Password", comment: ""),
                                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: Fonts.roboto(type: 1, fontSize: 17)])
        
        let normalText = NSLocalizedString("Forget your password?", comment: "")
        let normalAttrs = [NSAttributedStringKey.font : Fonts.roboto(type: 0, fontSize: 15)]
        let normalString = NSMutableAttributedString(string:normalText,attributes: normalAttrs)
        
        let boldText  = NSLocalizedString(" Restore", comment: "")
        let attrs = [NSAttributedStringKey.font : Fonts.roboto(type: 4, fontSize: 15)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        
        normalString.append(attributedString)
        
        self.forgetPasswordLabel.attributedText = normalString
        
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
    
    private func emailLoginTapped(){
        if self.validateForm(){
            if let email = self.emailTextField.text, let password = self.passwordTextField.text{
                self.loginButton.showLoading()
                APIManager.sharedInstance.login(withParameters: APIRequestBody.getLoginBody(withEmail: email, withPassword: password), completion: {
                    result in
                    self.loginButton.hideLoading()
                    if result == .success {
                        let rootController = self.homeStoryboard.instantiateViewController(withIdentifier: "Home")
                        UIApplication.shared.keyWindow?.rootViewController = rootController
                        self.performSegue(withIdentifier: "GoHome", sender: nil)
                    }
                })
            }
        }
    }
    
    private func validateForm() -> Bool {
        
        if !self.emailTextField.isEmail() {
            errorOnLogin(causeOfFailure: "email")
            return false
        }
        
        if self.passwordTextField.text == "" {
            errorOnLogin(causeOfFailure: "password")
            return false
        }
        
        return true
    }
    
    private func errorOnLogin(causeOfFailure error: String){
        
        switch error {
        case "email":
            APIHelper.sharedInstance.showErrorMessage(with: "You must enter an email", and: "")
            break
        case "password":
            APIHelper.sharedInstance.showErrorMessage(with: "You must enter a password", and: "")
            break
        default:
            APIHelper.sharedInstance.showErrorMessage(with: "Check the entered data", and: "")
            break
        }
        
    }
    
    private func overlayBlurredBackgroundView() {
        
        let blurredBackgroundView = UIVisualEffectView()
        
        blurredBackgroundView.frame = self.tableView.bounds
        blurredBackgroundView.effect = UIBlurEffect(style: .dark)
        
        self.tableView.addSubview(blurredBackgroundView)
    }
    
    @objc func removeBlurredBackgroundView() {
        
        for subview in self.tableView.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }
}
