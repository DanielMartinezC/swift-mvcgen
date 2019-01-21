//
//  ImagesCollectionViewCell.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit
import Kingfisher

class ImagesCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet weak var imageOutlet: UIImageView!

    // MARK: - Life cycle

    func configure(with picture: Pic) {

        self.imageOutlet.kf.indicatorType = .activity
        self.imageOutlet.kf.setImage(with: URL(string : picture.url))
    }
    
}

