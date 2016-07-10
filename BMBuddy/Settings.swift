//
//  Settings.swift
//  BMBuddy
//
//  Created by Jung Kim on 1/20/16.
//  Copyright © 2016 Jung Kim. All rights reserved.
//

import Foundation

enum Prompts: Int {
    case Verbal = 0
    case VerbalVideo
    case Text
}

enum CommunicationCall: Int {
    case Family = 0
    case Friend
    case Nurse
    case Doctor
    case Dial911
}

enum CommunicationText: Int {
    case Family = 0
    case Friend
    case Doctor
}

enum ClockPreference: String {
    case US
    case EU
}

enum VOIDFriendlyName: Int {
    case VOID
    case Urinate
    case Pee
    case NumberOne
}

enum BMFriendlyName: Int {
    case BM
    case BowlMovement
    case Poop
    case NumberTwo
}

class Settings {
    
    var careGiverName: String!
    var careGiverNumber: String!
    var whileAwakeStartTime: NSDate! // AM
    var hoursOfSleepStartTime: NSDate! // AM
    var waFreq: Int = 2  // hours
    var hsFreq: Int = 4 // hours
    var waSnooze: Int = 15 // minutes
    var hsSnooze: Int = 1 // hour
    var prefPrompt: Prompts = .Text
    var prefCall: CommunicationCall = .Family
    var prefText: CommunicationText = .Family
    var clockPref: ClockPreference = .US {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("ClockPreferenceChangedNotification", object: nil)
        }
    }
    var usClockFormatter : NSDateFormatter = NSDateFormatter()
    var euClockFormatter : NSDateFormatter = NSDateFormatter()
    var voidFriendlyName : VOIDFriendlyName = .VOID
    var bmFriendlyName : BMFriendlyName = .BM
    
    static let sharedInstance = Settings()
    
    init(){
        usClockFormatter.dateFormat = "h:mm a"
        euClockFormatter.dateFormat = "H:mm"
    }
    
    func displayTime(time: NSDate) -> String{
        if self.clockPref == .EU {
            return euClockFormatter.stringFromDate(time)
        }else{
            return usClockFormatter.stringFromDate(time)
        }
    }
}