//
//  RoundTextField.swift
//  DevChat
//
//  Created by the Luckiest on 7/4/17.
//  Copyright © 2017 the Luckiest. All rights reserved.
//

import UIKit

@IBDesignable
class RoundTextField: UITextField {
    @IBInspectable var cornerRedius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRedius
            layer.masksToBounds = cornerRedius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var bgColor: UIColor? {
        didSet {
            backgroundColor = bgColor
        }
    }
    
    @IBInspectable var placeholderColor: UIColor? {
        didSet {
            let rawString = attributedPlaceholder?.string != nil ? attributedPlaceholder!.string : ""
            let str = NSAttributedString(string: rawString, attributes: [NSForegroundColorAttributeName: placeholderColor!])
            attributedPlaceholder = str
        }
    }
}
