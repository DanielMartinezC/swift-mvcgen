//
//  DestinationCell.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit

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
        self.blueGradientView.applyGradient(withColours: [Colors.firstGradientColor, UIColor.clear], alpha: 0.8, angle: 90)
    }
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = 1.0
            self.layer.borderColor = isSelected ? Colors.firstGradientColor.cgColor : UIColor.clear.cgColor
            self.blueGradientView.backgroundColor = isSelected ? Colors.thirdGradientColor : UIColor.clear
            self.tickImage.image = isSelected ? UIImage(named: "Tick") : nil
        }
    }
}
