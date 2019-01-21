//
//  ProfileContainerVC.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit

class ProfileContainerVC: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var containerView: UIView!

    // MARK: - Properties
    
    private static let homeStoryboard = UIStoryboard(name: "Home", bundle: Bundle.main)

    private lazy var profileTVC: ProfileTVC = { 
        return self.homeStoryboard.instantiateViewController(withIdentifier: "ProfileTVC") as! ProfileTVC 
    }()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        self.add(asChildViewController: self.profileTVC)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                
        self.gradientView.applyGradient(withColours: [Colors.firstGradientColor, Colors.thirdGradientColor], locations: [0, 0.5])
    }

    // MARK: - Private
    
    private func setupNavigationBar() {

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {

        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
}
