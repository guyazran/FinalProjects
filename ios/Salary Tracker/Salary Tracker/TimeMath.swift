//
//  TimeMath.swift
//  Salary Tracker
//
//  Created by Guy Azran on 11/18/15.
//  Copyright © 2015 Guy Azran. All rights reserved.
//

import Foundation

class TimeMath{
    
}

func + (left: OverflowClock?, right: OverflowClock?) -> OverflowClock?{
    if left == nil && right == nil{
        return nil;
    }
    if left == nil{
        return OverflowClock(newTime: right!);
    }
    if right == nil{
        return OverflowClock(newTime: left!);
    }
    
    var sumOfHours = left!.hour + right!.hour;
    var sumOfMinutes = left!.minutes + right!.minutes;
    
    if sumOfMinutes > 59{
        sumOfHours++;
        sumOfMinutes -= 60;
    }
    
    return OverflowClock(hour: sumOfHours, minutes: sumOfMinutes);
}

func += (inout left: OverflowClock?, right: OverflowClock?){
    left = left! + right!
}

func == (left: OverflowClock?, right: OverflowClock?) -> Bool{
    if let theLeft = left{
        if let theRight = right{
            if theLeft.hour == theRight.hour && theLeft.minutes == theRight.minutes{
                return true;
            }
        }
    }
    return false;
}

func > (left: OverflowClock?, right: OverflowClock?) -> Bool{
    if let theLeft = left{
        if let theRight = right{
            if theLeft.hour > theRight.hour{
                return true;
            } else if theLeft.hour == theRight.hour{
                if theLeft.minutes > theRight.minutes{
                    return true;
                }
            }
        }
    }
    return false;
}


func < (left: OverflowClock?, right: OverflowClock?) -> Bool{
    if let theLeft = left{
        if let theRight = right{
            if theLeft.hour < theRight.hour{
                return true;
            } else if theLeft.hour == theRight.hour{
                if theLeft.minutes < theRight.minutes{
                    return true;
                }
            }
        }
    }
    return false;
}

func >= (left: OverflowClock?, right: OverflowClock?) -> Bool{
    return left > right || left == right;
}

func <= (left: OverflowClock?, right: OverflowClock?) -> Bool{
    return left < right || left == right;
}

extension TimeMath{
    
    static func findHourAndMinutesDifference(startTime: OverflowClock?, endTime: OverflowClock?) -> OverflowClock?{
        if startTime == nil || endTime == nil{
            return nil;
        }
        
        let theStartTime = startTime!;
        let theEndTime = endTime!;
        
        let startHour = theStartTime.hour;
        let endHour = theEndTime.hour;
        
        var hourDifference: Int;
        if (startHour <= endHour) {
            hourDifference = endHour - startHour;
        } else {
            hourDifference = (24 - startHour) + endHour;
        }
        
        let startMinute = theStartTime.minutes;
        let endMinute = theEndTime.minutes;
        
        var minuteDifference: Int;
        if (startMinute <= endMinute) {
            minuteDifference = endMinute - startMinute;
        } else {
            minuteDifference = (60 - startMinute) + endMinute;
            hourDifference--;
        }
        
        return OverflowClock(hour: hourDifference, minutes: minuteDifference);
    }
    
    static func convertMinutesToHours(minutes: Int) -> Double {
        return Double(minutes) / Double(60.0);
    }
    
    
}