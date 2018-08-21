//
//  TableViewEmptyView.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit


extension UITableView {
    
    func setEmptyTableLabelView(message: String, emptyIcon: String) {
        
        let emptyTableLabelViewNib = UINib(nibName: "EmptyTableLabelView", bundle: nil)
        let emptyTableLabelView = emptyTableLabelViewNib.instantiate(withOwner: nil, options: nil)[0] as! EmptyTableLabelView
        emptyTableLabelView.label.text = message
        emptyTableLabelView.iconImageView.image = UIImage(named: emptyIcon)
        emptyTableLabelView.tag = 100
        self.backgroundView = emptyTableLabelView
        
    }
    
    func hideEmptyTableLabelView(){
        if let viewWithTag = self.viewWithTag(100) {
            viewWithTag.isHidden = true
        }
    }
}
