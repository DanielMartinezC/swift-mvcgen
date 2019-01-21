//
//  DescriptionCell.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit
import Kingfisher

class DescriptionCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var descriptionTextView: UITextView!

    func configure(with userHistory: UserHistory) {

        self.destinationLabel.text = userHistory.name.capitalized
        self.destinationBackgroundImage.kf.indicatorType = .activity
        self.destinationBackgroundImage.kf.setImage(with: URL(string: history.thumbnailUrl), options: [.transition(.fade(0.2))])
    }
    
}

