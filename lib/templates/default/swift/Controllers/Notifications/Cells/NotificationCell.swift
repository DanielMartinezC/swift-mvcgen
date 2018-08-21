//
//  NotificationCell.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var notificationImage: UIImageView!{
        didSet{
            self.notificationImage.layoutIfNeeded()
            self.notificationImage.layer.cornerRadius = self.notificationImage.frame.height/2
            self.notificationImage.layer.masksToBounds = true
            self.notificationImage.layer.borderColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0).cgColor
            self.notificationImage.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var notificationText: UILabel!
    @IBOutlet weak var notificationDate: UILabel!
    @IBOutlet weak var newNotificationView: UIView!{
        didSet{
            self.newNotificationView.layer.shadowColor = UIColor.black.cgColor
            self.newNotificationView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            self.newNotificationView.layer.shadowRadius = 1.0
            self.newNotificationView.layer.shadowOpacity = 0.5
            self.newNotificationView.layer.masksToBounds = false
            self.newNotificationView.layer.cornerRadius = self.newNotificationView.frame.height/2
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.newNotificationView.isHidden = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.notificationImage.image = UIImage(named: "notificaciones")
        
        self.newNotificationView.isHidden = true
    }
    
}
