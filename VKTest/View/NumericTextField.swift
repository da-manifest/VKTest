//
//  NumericTextField.swift
//  VKTest
//
//  Created by Maksim Khozyashev on 13/01/2019.
//  Copyright © 2019 Maksim Khozyashev. All rights reserved.
//

import UIKit

class NumericTextField: UITextField {

    // MARK: - Lifecycle
    override func awakeFromNib() {
        delegate = self
        keyboardType = .decimalPad
    }
}

// MARK: - UITextFieldDelegate
extension NumericTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newCharacters = CharacterSet(charactersIn: string)
        let isNumber = CharacterSet.decimalDigits.isSuperset(of: newCharacters)
        if isNumber == true {
            return true
        } else {
            if string == "." {
                let countdots = textField.text!.components(separatedBy: ".").count - 1
                if countdots == 0 {
                    return true
                } else {
                    if countdots > 0 && string == "." {
                        return false
                    } else {
                        return true
                    }
                }
            } else {
                return false
            }
        }
    }
}
