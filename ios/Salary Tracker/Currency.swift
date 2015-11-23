//
//  Currency.swift
//  Salary Tracker
//
//  Created by Guy Azran on 11/21/15.
//  Copyright © 2015 Guy Azran. All rights reserved.
//

import Foundation

enum Currency : String{
    case USD = "USD";
    case EUR = "EUR";
    case ILS = "ILS";
    
    func description() ->String{
        switch self{
        case .USD:
            return "$";
        case .EUR:
            return "€";
        case .ILS:
            return "₪";
        }
    }
    
    static func values() -> [Currency]{
        var currencies = [Currency]();
        currencies.append(.USD);
        currencies.append(.EUR);
        currencies.append(.ILS);
        
        return currencies;
    }
}