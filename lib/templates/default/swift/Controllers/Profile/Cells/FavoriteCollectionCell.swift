//
//  FavoriteCollectionCell.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit

class FavoriteCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var favoriteBackgroundView: UIView! {
        didSet {
            favoriteBackgroundView.layer.cornerRadius = favoriteBackgroundView.frame.size.height/2
            favoriteBackgroundView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var destinationLabel: UILabel!
    
    @IBOutlet weak var removeButton: UIButton!
    
}
