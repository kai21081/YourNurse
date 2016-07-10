//
//  Utility.swift
//  BMBuddy
//
//  Created by Jung Kim on 4/30/16.
//  Copyright © 2016 Jung Kim. All rights reserved.
//

import UIKit

class Utility {
    class func parseTimeLeft(timeLeft: Int) -> (hour:String, min:String){
        let hour: Int = timeLeft/60
        let minutes = timeLeft%60
        
        let hourStr = String(format: "%02d", hour)
        let minStr = String(format: "%02d", minutes)
        return (hourStr, minStr)
    }
    
    class func setLocalNotification(hoursFromNow: Int){
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let localNotification = UILocalNotification()
        var timeToFire : Double = Double(hoursFromNow * 60)
        if isTestMode {
            timeToFire = 10
        }
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        localNotification.fireDate = NSDate(timeIntervalSinceNow: timeToFire)
        localNotification.alertBody = "Do you need to use the toilet?"
        localNotification.alertAction = "Launch the app"
        //localNotification.timeZone = NSTimeZone.systemTimeZone()
        localNotification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        appDelegate.promptTime = localNotification.fireDate
        print("notification #0: \(localNotification.fireDate)")
        self.setBotheringLocalNotification()
    }
    
    class func setBotheringLocalNotification(withFirstPrompt: Bool = false){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let settings = Settings.sharedInstance
        if appDelegate.promptTime != nil {
            if withFirstPrompt == true {
                let localNotification = UILocalNotification()
                localNotification.fireDate = appDelegate.promptTime
                localNotification.alertBody = "Do you need to use the toilet?"
                localNotification.alertAction = "Launch the app"
                localNotification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                print("notification #0: \(localNotification.fireDate)")
            }
            
            var nextDay = appDelegate.promptTime!.addDays(1)
            var currentTime = appDelegate.promptTime!
            var currentAppMode = currentMode
            
            while currentTime.isLessThanDate(nextDay) {
                print("\(currentTime), \(nextDay)")
                var numOfNotification = Int(PROMPT_TIMEOUT_MAX/PROMPT_WAIT_INTERVAL)
                if currentTime.timeIntervalSinceNow <= 0 {
                    numOfNotification = Int((currentTime.timeIntervalSinceNow + PROMPT_TIMEOUT_MAX)/PROMPT_WAIT_INTERVAL)
                    if isTestMode {
                        numOfNotification = Int((currentTime.timeIntervalSinceNow + DEBUG_PROMPT_TIMEOUT_MAX)/DEBUG_PROMPT_WAIT_INTERVAL)
                    }
                }
                
                if numOfNotification > 0 {
                    print("Number of notification: \(numOfNotification)")
                    print("\(NSDate())")
                    print("prompt time: \(appDelegate.promptTime!)")
                    
                    for i in 0..<numOfNotification {
                        
                        let localNotification = UILocalNotification()
                        var timeToFire : Double = currentTime.timeIntervalSinceNow + Double(i+1)*PROMPT_WAIT_INTERVAL
                        if isTestMode {
                            timeToFire = currentTime.timeIntervalSinceNow + Double(i+1)*DEBUG_PROMPT_WAIT_INTERVAL
                        }
                        localNotification.category = "Bother"
                        localNotification.fireDate = NSDate(timeIntervalSinceNow: timeToFire)
                        localNotification.alertBody = "Please provide response"
                        localNotification.alertAction = "Launch the app";
                        localNotification.timeZone = NSTimeZone.systemTimeZone()
                        localNotification.soundName = UILocalNotificationDefaultSoundName
                        print("notification #\(i+1): \(localNotification.fireDate)")
                        if i == numOfNotification-1{
                            localNotification.userInfo = ["isLast":true]
                        }
                        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                    }
                    
                    print("\(currentMode.rawValue)\r")
                }
                if currentAppMode == .WA {
                    currentTime = currentTime.addHours(settings.waFreq)
                }else{
                    currentTime = currentTime.addHours(settings.hsFreq)
                }
                if currentTime.isLaterThanTime(settings.hoursOfSleepStartTime) {
                    if currentTime.isLaterThanTime(settings.whileAwakeStartTime) {
                        currentAppMode = .WA
                    }else{
                        currentAppMode = .HS
                    }
                }else{
                    currentAppMode = .WA
                }

            }
//            var numOfNotification = Int(PROMPT_TIMEOUT_MAX/PROMPT_WAIT_INTERVAL)
//            if appDelegate.promptTime!.timeIntervalSinceNow <= 0 {
//                numOfNotification = Int((appDelegate.promptTime!.timeIntervalSinceNow + PROMPT_TIMEOUT_MAX)/PROMPT_WAIT_INTERVAL)
//                if isTestMode {
//                    numOfNotification = Int((appDelegate.promptTime!.timeIntervalSinceNow + DEBUG_PROMPT_TIMEOUT_MAX)/DEBUG_PROMPT_WAIT_INTERVAL)
//                }
//            }
            
//            if numOfNotification > 0 {
//                print("Number of notification: \(numOfNotification)")
//                print("\(NSDate())")
//                print("prompt time: \(appDelegate.promptTime!)")
//                
//                for i in 0..<numOfNotification {
//                    
//                    let localNotification = UILocalNotification()
//                    var timeToFire : Double = appDelegate.promptTime!.timeIntervalSinceNow + Double(i+1)*PROMPT_WAIT_INTERVAL
//                    if isTestMode {
//                        timeToFire = appDelegate.promptTime!.timeIntervalSinceNow + Double(i+1)*DEBUG_PROMPT_WAIT_INTERVAL
//                    }
//                    localNotification.category = "Bother"
//                    localNotification.fireDate = NSDate(timeIntervalSinceNow: timeToFire)
//                    localNotification.alertBody = "Please provide response"
//                    localNotification.alertAction = "Launch the app";
//                    localNotification.timeZone = NSTimeZone.systemTimeZone()
//                    localNotification.soundName = UILocalNotificationDefaultSoundName
//                    print("notification #\(i+1): \(localNotification.fireDate)")
//                    if i == numOfNotification-1{
//                        localNotification.userInfo = ["isLast":true]
//                    }
//                    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
// 
//                }
//            }
        }
    }
    
    class func getTimeLeftUntilNextPrompt(freqVariable: Int) -> Int{
        var timeLeftUntilNextPrompt: Int!
        let timeSinceLastEpisode = ToiletEpisodeService.timeSinceLastEpisode()
        if timeSinceLastEpisode > 0 && Int(timeSinceLastEpisode) < freqVariable {
            timeLeftUntilNextPrompt = (freqVariable-Int(timeSinceLastEpisode))/60
        }else{
            timeLeftUntilNextPrompt = freqVariable/60
        }

        return timeLeftUntilNextPrompt
    }
}
