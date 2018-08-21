//
//  TutorialVC.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit
import paper_onboarding

class TutorialVC: UIViewController {
    
    @IBOutlet weak var onboarding: PaperOnboarding!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skipButton.isHidden = true
        
        // Uncomment next line to setup `PaperOnboarding` from code
        setupPaperOnboardingView()
        
    }
    
    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.dataSource = self
        onboarding.delegate = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // Add constraints
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
        self.view.bringSubview(toFront: skipButton);
    }

}

// MARK: Actions

extension TutorialVC {
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        print(#function)
    }
    
}

// MARK: PaperOnboardingDelegate
extension TutorialVC: PaperOnboardingDelegate {
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        skipButton.isHidden = index == 3 ? false : true
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
        //    item.titleLabel?.backgroundColor = .redColor()
        //    item.descriptionLabel?.backgroundColor = .redColor()
        //    item.imageView = ...
    }
    
}

// MARK: PaperOnboardingDataSource
extension TutorialVC: PaperOnboardingDataSource {
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let titleFont = UIFont(name: "Quicksand-Bold", size: 30.0) ?? UIFont.boldSystemFont(ofSize: 30.0)
        let descriptionFont = UIFont(name: "Quicksand-Medium", size: 22.0) ?? UIFont.systemFont(ofSize: 22.0)
        let welcomeLabel = NSLocalizedString("WELCOME", comment: "")
        
        let list = [
            OnboardingItemInfo(informationImage: UIImage(named: "Welcome_001")!,
                               title: welcomeLabel,
                               description: NSLocalizedString("If you like to travel comfortably ...", comment: ""),
                               pageIcon: UIImage(named: "Tick")!,
                               color: Colors.firstGradientColor,
                               titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
            OnboardingItemInfo(informationImage: UIImage(named: "Welcome_002")!,
                               title: "",
                               description: NSLocalizedString("... with everything arranged ...", comment: ""),
                               pageIcon: UIImage(named: "Tick")!,
                               color: Colors.secondGradientColor,
                               titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
            OnboardingItemInfo(informationImage: UIImage(named: "Welcome_003")!,
                               title: "",
                               description: NSLocalizedString("... with everything planned ...", comment: ""),
                               pageIcon: UIImage(named: "Tick")!,
                               color: Colors.thirdGradientColor,
                               titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
            OnboardingItemInfo(informationImage: UIImage(named: "Welcome_004")!,
                               title: "",
                               description: NSLocalizedString("... then don't travel with us!", comment: ""),
                               pageIcon: UIImage(named: "Tick")!,
                               color: Colors.textColor,
                               titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        ]
        return list[index]
    }
    
    func onboardingItemsCount() -> Int {
        return 4
    }
    
}

