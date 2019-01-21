//
//  Utils+UITextField.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

extension UITextField {
    
    func isEmail() -> Bool {
        return self.text.isEmail()
    }

    func isName() -> Bool {
        return self.text.isName()
    }

    func isPhone() -> Bool {
        return self.text.isPhone()
    }
}
