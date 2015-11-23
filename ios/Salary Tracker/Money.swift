//
//  Moenh.swift
//  Salary Tracker
//
//  Created by Guy Azran on 11/21/15.
//  Copyright © 2015 Guy Azran. All rights reserved.
//

import Foundation

class Money {
    private var _amount:Double;
    private var _currency:Currency;
    
    var amount:Double{
        get{
            return _amount;
        } set{
            _amount = newValue
        }
    }
    
    var currency:Currency{
        get{
            return _currency;
        }set{
            _currency = currency;
        }
    }
    
    init(amount: Double, currency:Currency){
        self._amount = amount;
        self._currency = currency;
    }
    
    convenience init(){
        self.init(amount: 0, currency: .USD);
    }
    
    func description() ->String{
        let roundedAmount = Double(round(100.0 * amount) / 100.0);
        let stringAmount = NSString(format: "%.2f", roundedAmount);
        return "\(stringAmount)\(currency.description())";
    }
}