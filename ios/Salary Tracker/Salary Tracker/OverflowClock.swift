//
//  OverflowClock.swift
//  Salary Tracker
//
//  Created by Guy Azran on 11/18/15.
//  Copyright © 2015 Guy Azran. All rights reserved.
//

import Foundation

class OverflowClock {
    private var _hour: Int;
    private var _minutes: Int;
    
    var hour:Int{
        get{
            return _hour;
        } set{
            if newValue < 0{
                _hour = 0
            } else{
                _hour = newValue;
            }
        }
    }
    
    var minutes:Int{
        get{
            return _minutes;
        } set{
            if (newValue > 59){
                hour += 1;
                self.minutes = newValue - 60;
            } else if (minutes < 0){
                hour--;
                self.minutes += 60;
            } else {
                _minutes = newValue;
            }
        }
    }
    
    convenience init(){
        self.init(hour: 0, minutes: 0);
    }
    
    init(var hour: Int, var minutes: Int){
        while minutes > 59{
            hour++;
            minutes -= 60;
        }
        while minutes < 0{
            hour--;
            minutes += 60;
        }
        self._minutes = minutes;
        self._hour = hour;
    }
    
    convenience init(newTime: OverflowClock){
        self.init(hour: newTime.hour, minutes: newTime.minutes);
    }
    
    func hourAndMinutesDifference(clock: OverflowClock?) -> OverflowClock?{
        return TimeMath.findHourAndMinutesDifference(self, endTime: clock)
    }
    
    static func getCurrentClock() -> Clock{
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Calendar, fromDate: date)
        return Clock(hour: components.hour, minutes: components.minute);
    }
    
    func description() -> String {
        var hourString: String;
        if hour < 10{
            hourString = "0\(hour)"
        } else{
            hourString = String(hour);
        }
        
        var minutesString:String;
        if minutes < 10{
            minutesString = "0\(minutes)";
        } else{
            minutesString = String(minutes);
        }
        
        return hourString + ":" + minutesString;
    }
    
    func getMinutesInHours() -> Double{
        return TimeMath.convertMinutesToHours(self.minutes);
    }
    
    func getDecimalValue() -> Double{
        return Double(hour) + getMinutesInHours();
    }
}