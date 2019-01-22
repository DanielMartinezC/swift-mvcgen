//
//  SelectLanguageVC.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit

class SelectLanguageVC: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var registerButton: LoadingButton!{
        didSet{
            self.registerButton.layoutIfNeeded()
            self.registerButton.layer.cornerRadius = self.registerButton.frame.height/2
            self.registerButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var gradientView: UITableView!
    
    // MARK: - Properties
    
    var signupInfo: [String:String]!
    var languagesShort = ["SP", "EN", "PT", "ZH", "FR"]
    var languagesFull = ["Spanish", "English", "Portuguese", "Chinese", "French"]
    var selected = [IndexPath]()
    var selectedLanguages = [String]()
    var fromFacebook = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gradientView.delegate = self
        self.gradientView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.gradientView.applyGradient(withColours: [ColorConstants.firstGradientColor, ColorConstants.secondGradientColor, ColorConstants.thirdGradientColor], locations: [0, 0.2, 0.98])
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        if selectedLanguages.count > 0 {
            if let email = self.signupInfo["email"], let firstname = self.signupInfo["firstname"], let lastname = self.signupInfo["lastname"], let phoneCountry = self.signupInfo["phoneCountry"], let phone = self.signupInfo["phone"], let password = self.signupInfo["password"]{
                // TODO:
//                UserRepository.sharedInstance.signup(
//                    email: email,
//                    password: password,
//                    name: firstname,
//                    lastname: lastname,
//                    phoneCountry: phoneCountry,
//                    phone: phone,
//                    languages: selectedLanguages
//                ) { result, message in
//
//                    if result == .success {
//                        self.performSegue(withIdentifier: "ShowHome", sender: self)
//                    } else {
//                        if let msg = message {
//                            APIHelper.sharedInstance.showErrorMessage(with: msg, and: "")
//                        } else {
//                            APIHelper.sharedInstance.showErrorMessage(with:  NSLocalizedString("Connection error with services.", comment: ""), and: "")
//                        }
//                    }
//                }
            }
        }
        else{
            APIHelper.sharedInstance.showErrorMessage(with:  NSLocalizedString("Please select at least one language", comment: "") , and: "")
        }
        
    }
    
    @IBAction func cancelRegisterTapped(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: false, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languagesShort.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLanguageCell", for: indexPath) as! SelectLanguageCell
        cell.laguangeSelectedImage.image = nil
        if self.selected.contains(indexPath){
            cell.laguangeSelectedImage.image = UIImage(named: "Tick")
        }
        cell.languageLabel.text = languagesFull[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectLanguageCell else { return }
        cell.laguangeSelectedImage.image = UIImage(named: "Tick")
        self.selected.append(indexPath)
        self.selectedLanguages.append(languagesShort[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectLanguageCell else { return }
        cell.laguangeSelectedImage.image = nil
        self.selected = self.selected.filter{ $0 != indexPath }
        if let index = selectedLanguages.index(of: self.languagesShort[indexPath.row]) {
            selectedLanguages.remove(at: index)
        }
    }
}
