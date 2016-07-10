//
//  NSDateExtentions.swift
//  BMBuddy
//
//  Created by Jung Kim on 5/1/16.
//  Copyright © 2016 Jung Kim. All rights reserved.
//

import Foundation

extension NSDate {
    
    func isLaterThanTime(dateToCompare: NSDate) -> Bool {
        if self.hour() > dateToCompare.hour() {
            return true
        }else if self.hour() == dateToCompare.hour() {
            if self.minutes() >= dateToCompare.minutes() {
                return true
            }
        }
        return false
    }
    
    func hour()->Int{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour], fromDate: self)
        return components.hour
    }
    
    func minutes()->Int{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Minute], fromDate: self)
        return components.minute
    }
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}