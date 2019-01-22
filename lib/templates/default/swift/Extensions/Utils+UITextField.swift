//
//  Utils+UITextField.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//
import UIKit

extension UITextField {
    
    func isEmail() -> Bool {
        return self.text?.isEmail() ?? false
    }

    func isName() -> Bool {
        return self.text?.isName() ?? false
    }

    func isPhone() -> Bool {
        return self.text?.isPhone() ?? false
    }
}
