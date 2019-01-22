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
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
        self.view.bringSubviewToFront(skipButton);
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
        let welcomeLabel = "WELCOME"
        
        let list = [
            OnboardingItemInfo(informationImage: Asset.welcome_01.image,
                               title: welcomeLabel,
                               description: "First tutorial message!",
                               pageIcon: UIImage(named: "Tick")!,
                               color: ColorConstants.firstGradientColor,
                               titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
            OnboardingItemInfo(informationImage: Asset.welcome_02.image,
                               title: "",
                               description: "Second tutorial message!",
                               pageIcon: UIImage(named: "Tick")!,
                               color: ColorConstants.secondGradientColor,
                               titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
            OnboardingItemInfo(informationImage: Asset.welcome_03.image,
                               title: "",
                               description: "Third tutorial message!",
                               pageIcon: UIImage(named: "Tick")!,
                               color: ColorConstants.thirdGradientColor,
                               titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
            OnboardingItemInfo(informationImage: Asset.welcome_04.image,
                               title: "",
                               description: "Final tutorial message!",
                               pageIcon: UIImage(named: "Tick")!,
                               color: ColorConstants.textColor,
                               titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        ]
        return list[index]
    }
    
    func onboardingItemsCount() -> Int {
        return 4
    }
    
}

