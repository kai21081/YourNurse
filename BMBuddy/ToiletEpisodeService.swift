//
//  ToiletEpisodeService.swift
//  BMBuddy
//
//  Created by Jung Kim on 3/30/16.
//  Copyright © 2016 Jung Kim. All rights reserved.
//

import Foundation

class ToiletEpisodeService {
    
    static var lastVoidEpisodeTime : NSDate?
    static var lastBmEpisodeTime : NSDate?
    static var lastEpisodeTime : NSDate?
    static var allEpisodes : [[String:AnyObject]]?
    static var lastEpisodeType: EpisodeType?
    
    class func initialize(){
        lastEpisodeTime = NSUserDefaults.standardUserDefaults().objectForKey("lastEpisodeTime") as? NSDate
        lastVoidEpisodeTime = NSUserDefaults.standardUserDefaults().objectForKey("lastVoidEpisodeTime") as? NSDate
        lastBmEpisodeTime = NSUserDefaults.standardUserDefaults().objectForKey("lastBmEpisodeTime") as? NSDate
        allEpisodes = NSUserDefaults.standardUserDefaults().objectForKey("allEpisodes") as? [[String:AnyObject]]
    }
    
    class func saveEpisode(time: NSDate, episodeType: EpisodeType?, isAccident: Bool = false, isDryRun: Bool = false){
        let defaults = NSUserDefaults.standardUserDefaults()
        if allEpisodes == nil {
            allEpisodes = [[String:AnyObject]]()
        }
        var newEpisode : [String:AnyObject]!
        if episodeType == nil {
            if isDryRun {
                //should I record episode time???
                newEpisode = ["episodeTime":time, "isVoid":false, "isBm":false, "isAccident":isAccident, "isSkipped":false, "isDryRun":true]
            }else{
                newEpisode = ["episodeTime":time, "isVoid":false, "isBm":false, "isAccident":isAccident, "isSkipped":true, "isDryRun":isDryRun]
            }
            
        }else{
            lastEpisodeType = episodeType!
            if episodeType == .VOID {
                newEpisode = ["episodeTime":time, "isVoid":true, "isBm":false, "isAccident":isAccident, "isSkipped":false, "isDryRun":isDryRun]
                //save lastVoidEpisodeTime
                if lastVoidEpisodeTime == nil{
                    lastVoidEpisodeTime = time
                    defaults.setObject(lastVoidEpisodeTime, forKey: "lastVoidEpisodeTime")
                }else {
                    if time.timeIntervalSince1970 - lastVoidEpisodeTime!.timeIntervalSince1970 > 0 {
                        lastVoidEpisodeTime = time
                        defaults.setObject(lastVoidEpisodeTime, forKey: "lastVoidEpisodeTime")
                    }
                }
            }else if episodeType == .BM {
                newEpisode = ["episodeTime":time, "isVoid":false, "isBm":true, "isAccident":isAccident, "isSkipped":false, "isDryRun":isDryRun]
                //save lastBmEpisodeTime
                if lastBmEpisodeTime == nil{
                    lastBmEpisodeTime = time
                    defaults.setObject(lastBmEpisodeTime, forKey: "lastBmEpisodeTime")
                }else {
                    if time.timeIntervalSince1970 - lastBmEpisodeTime!.timeIntervalSince1970 > 0 {
                        lastBmEpisodeTime = time
                        defaults.setObject(lastBmEpisodeTime, forKey: "lastBmEpisodeTime")
                    }
                }
            }
            if episodeType == .VOIDBM {
                newEpisode = ["episodeTime":time, "isVoid":true, "isBm":true, "isAccident":isAccident, "isSkipped":false, "isDryRun":isDryRun]
                //save lastVoidEpisodeTime
                if lastVoidEpisodeTime == nil{
                    lastVoidEpisodeTime = time
                    defaults.setObject(lastVoidEpisodeTime, forKey: "lastVoidEpisodeTime")
                }else {
                    if time.timeIntervalSince1970 - lastVoidEpisodeTime!.timeIntervalSince1970 > 0 {
                        lastVoidEpisodeTime = time
                        defaults.setObject(lastVoidEpisodeTime, forKey: "lastVoidEpisodeTime")
                    }
                }
                //save lastBmEpisodeTime
                if lastBmEpisodeTime == nil{
                    lastBmEpisodeTime = time
                    defaults.setObject(lastBmEpisodeTime, forKey: "lastBmEpisodeTime")
                }else {
                    if time.timeIntervalSince1970 - lastBmEpisodeTime!.timeIntervalSince1970 > 0 {
                        lastBmEpisodeTime = time
                        defaults.setObject(lastBmEpisodeTime, forKey: "lastBmEpisodeTime")
                    }
                }
            }
        }
        //save lastEpisodeTime
        if lastEpisodeTime == nil{
            lastEpisodeTime = time
            defaults.setObject(lastEpisodeTime, forKey: "lastEpisodeTime")
        }else {
            if time.timeIntervalSince1970 - lastEpisodeTime!.timeIntervalSince1970 > 0 {
                lastEpisodeTime = time
//                if episodeType != nil && isDryRun == false {
//                    // Void, BM, Both or Accident
                    defaults.setObject(lastEpisodeTime, forKey: "lastEpisodeTime")
//                }
            }
        }
        allEpisodes!.insert(newEpisode, atIndex: 0)
        defaults.setObject(allEpisodes, forKey: "allEpisodes")
        defaults.synchronize()

        
    }
    
    class func timeSinceLastEpisode() -> NSTimeInterval {
        if lastEpisodeTime != nil {
            return NSDate().timeIntervalSinceDate(lastEpisodeTime!)
        }else{
            return 0
        }
    }
}