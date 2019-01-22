//
//  DestinationCell.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit
import Kingfisher

class DestinationCell: UICollectionViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var destinationBackgroundImage: UIImageView!
    
    @IBOutlet weak var destinationLabel: UILabel!
    
    @IBOutlet weak var blueGradientView: UIView!
    
    @IBOutlet weak var tickImage: UIImageView!
    
    // MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.blueGradientView.applyGradient(withColours: [ColorConstants.firstGradientColor, UIColor.clear], alpha: 0.8, angle: 90)
    }
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = 1.0
            self.layer.borderColor = isSelected ? ColorConstants.firstGradientColor.cgColor : UIColor.clear.cgColor
            self.blueGradientView.backgroundColor = isSelected ? ColorConstants.thirdGradientColor : UIColor.clear
            self.tickImage.image = isSelected ? UIImage(named: "Tick") : nil
        }
    }

    func configure(with userHistory: UserHistory) {
        
        self.destinationLabel.text = userHistory.name.capitalized
        self.destinationBackgroundImage.kf.indicatorType = .activity
        self.destinationBackgroundImage.kf.setImage(with: URL(string: userHistory.thumbnailUrl), options: [.transition(.fade(0.2))])
    }
}
