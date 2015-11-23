//
//  InputFilterDecimal.swift
//  Salary Tracker
//
//  Created by Guy Azran on 11/20/15.
//  Copyright © 2015 Guy Azran. All rights reserved.
//

import UIKit

class DecimalInputFilter : NSObject, UITextFieldDelegate {
    
    var hasDecimalPoint:Bool = false;
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString;
        let newText = oldText.stringByReplacingCharactersInRange(range, withString: string) as NSString;
        hasDecimalPoint = false;
        
        for i in 0..<newText.length{
            let charByte = newText.characterAtIndex(i);
            
            if i == 0 && charByte == 48 && newText.length>1{
                if newText.characterAtIndex(1) == 46{
                    
                }else{
                    return false;
                }
            }
            
            if charByte == 46{
                if hasDecimalPoint || i == 0{
                    return false
                }
                hasDecimalPoint = true;
                continue;
            }
            
            if !(charByte >= 48 && charByte <= 57){
                return false;
            }
        }
        
        return true;
    }
}