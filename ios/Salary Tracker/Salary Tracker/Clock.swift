//
//  Clock.swift
//  Salary Tracker
//
//  Created by Guy Azran on 11/18/15.
//  Copyright © 2015 Guy Azran. All rights reserved.
//

import Foundation



class Clock : OverflowClock{
    
    
    override var hour:Int{
        get{
            return super.hour;
        } set{
            if newValue < 24 && newValue >= 0{
                super.hour = newValue;
            }
        }
    }
    
    override var minutes:Int{
        get{
            return super.minutes;
        } set{
            if newValue < 60 && newValue >= 0{
                super.minutes = newValue;
            }
        }
    }
    
    override init(var hour: Int,var minutes: Int) {
        if !(hour < 24 && hour >= 0){
            hour = 0;
        }
        if !(minutes < 60 && minutes >= 0){
            minutes = 0;
        }
        super.init(hour: hour, minutes: minutes);
    }
    
    
    
}



