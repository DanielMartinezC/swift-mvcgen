//
//  TermsAndConditionsVC.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit

class TermsAndConditionsVC: UIViewController {

    @IBOutlet weak var registerButtonOutlet: LoadingButton!{
        didSet{
            self.registerButtonOutlet.layer.cornerRadius = self.registerButtonOutlet.frame.height/7
            self.registerButtonOutlet.layer.masksToBounds = true
            self.registerButtonOutlet.activityIndicatorColor = ColorConstants.firstGradientColor
        }
    }
    @IBOutlet weak var termsAndConditions: UIButton!{
        didSet {
            self.termsAndConditions.layer.masksToBounds = true
            self.termsAndConditions.layer.cornerRadius = 5
        }
    }
    
    var acceptTermsAndConditions : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.applyGradient(withColours: [ColorConstants.firstGradientColor, ColorConstants.secondGradientColor, ColorConstants.thirdGradientColor], locations: [0, 0.2, 0.98])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptTermsTapped(_ sender: UIButton) {
        if !acceptTermsAndConditions {
            sender.setImage(Asset.tick.image, for: .normal)
            sender.bringSubviewToFront(sender.imageView!)
            self.acceptTermsAndConditions = true
            //registerButton.isEnabled = true
        } else {
            sender.setImage(nil, for: .normal)
            self.acceptTermsAndConditions = false
            //registerButton.isEnabled = false
        }
    }

    @IBAction func viewTermsAndConditions(_ sender: Any) {
        // TODO: View url
        if let url = URL(string: "http://notatourapp.com/terms-and-conditions") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        if self.acceptTermsAndConditions{
//            UserRepository.sharedInstance.acceptTermsAndConditions(){ result in
//                if result == .success{
//                    self.performSegue(withIdentifier: "registerToHome", sender: self)
//                }
//            }
        } else {
            APIHelper.sharedInstance.showErrorMessage(with: NSLocalizedString("You have to accept terms & conditions", comment: ""), and: "")
        }
    }
    
    @IBAction func alreadyHaveAnAccountTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

