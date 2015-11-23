//
//  Salary.swift
//  Salary Tracker
//
//  Created by Guy Azran on 11/21/15.
//  Copyright © 2015 Guy Azran. All rights reserved.
//

import Foundation

public class Salary {
    private var _payRate, _overtimePayRate : Money!;
    private var _finalPay : Money?;
    private var _timeWorked, _overtimeWorked : OverflowClock!;
    private var finalPayCreated = false;
    
    var payRate:Money!{
        get{
            return _payRate;
        } set{
            _payRate = newValue;
            finalPayCreated = false;
        }
    }
    
    var overtimePayRate:Money!{
        get{
            return _overtimePayRate;
        } set{
            _overtimePayRate = newValue;
            finalPayCreated = false;
        }
    }
    
    var timeWorked:OverflowClock!{
        get{
            return _timeWorked;
        } set{
            _timeWorked = newValue;
            finalPayCreated = false;
        }
    }

    var overtimeWorked:OverflowClock!{
        get{
            return _overtimeWorked;
        } set{
            _overtimeWorked = newValue;
            finalPayCreated = false
        }
    }
    var finalPay:Money?{
        get{
            if !finalPayCreated{
                var hoursWorked:Double = 0;
                if timeWorked != nil{
                    hoursWorked = Double(timeWorked.hour) + timeWorked.getMinutesInHours()
                }
                if let theFinalPay = _finalPay{
                    theFinalPay.amount = payRate.amount * hoursWorked;
                }else {
                    _finalPay = Money(amount: payRate.amount * hoursWorked, currency: payRate.currency);
                }
                if overtimeWorked != nil && overtimePayRate != nil {
                    let overtimeHoursWorked:Double = Double(overtimeWorked.hour) + overtimeWorked.getMinutesInHours();
                    _finalPay!.amount = _finalPay!.amount + overtimePayRate.amount * overtimeHoursWorked;
                }
                finalPayCreated = true;
            }
            return _finalPay;
        }
    }
    
    init(payRate:Money?, timeWorked:OverflowClock?, overtimePayRate:Money?, overtimeWorked:OverflowClock?) {
        self._payRate = payRate;
        self._timeWorked = timeWorked;
        self._overtimePayRate = overtimePayRate;
        self._overtimeWorked = overtimeWorked;
    }
    
}
