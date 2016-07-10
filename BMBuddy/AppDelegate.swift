//
//  AppDelegate.swift
//  BMBuddy
//
//  Created by Jung Kim on 12/31/15.
//  Copyright © 2015 Jung Kim. All rights reserved.
//

import UIKit
import AVFoundation

var currentMode: AppMode!
var lastToiletingTime: NSDate?
var lastToiletingType: EpisodeType?
var isTestMode = false

let PROMPT_TIMEOUT_MAX : NSTimeInterval = 1500.0
let PROMPT_WAIT_INTERVAL : NSTimeInterval = 300

let DEBUG_PROMPT_TIMEOUT_MAX : NSTimeInterval = 100.0
let DEBUG_PROMPT_WAIT_INTERVAL : NSTimeInterval = 20.0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var settings = Settings.sharedInstance
    var globalTimer: NSTimer?
    var globalTimerCount = 0
    var audioPlayer = AVAudioPlayer()
    var promptTime: NSDate?
    var topVC : FlowChartViewController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.registerUserNotificationSettings(
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
        lastToiletingTime = NSUserDefaults.standardUserDefaults().objectForKey("lastEpisodeTime") as? NSDate
        ToiletEpisodeService.initialize()
        self.loadSettings()
        if NSDate().isLaterThanTime(settings.hoursOfSleepStartTime) {
            if NSDate().isLaterThanTime(settings.whileAwakeStartTime) {
                currentMode = .WA
            }else{
                currentMode = .HS
            }
        }else{
            currentMode = .WA
        }
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        let applicationState = application.applicationState
        print("recieved a notification")
            if applicationState == .Inactive || applicationState == .Active {
                if notification.category == "Bother"{
                    if let userInfo = notification.userInfo as? [String:AnyObject],
                        let isLast = userInfo["isLast"] as? Bool{
                        if isLast == true {
                            var toiletLogTime = NSDate().timeIntervalSince1970 - PROMPT_TIMEOUT_MAX
                            self.promptTime = nil
                            if isTestMode {
                                toiletLogTime = NSDate().timeIntervalSince1970
                            }
                            ToiletEpisodeService.saveEpisode(NSDate(timeIntervalSince1970: toiletLogTime), episodeType: nil, isAccident: false, isDryRun: false)
                            if topVC != nil {
                                topVC!.navigationController!.dismissViewControllerAnimated(true, completion: {
                                    self.topVC = nil
                                    let viewController = self.window!.rootViewController as! BMTabBarController
                                    viewController.selectedIndex = 0
                                })
                            }
                        }
                    }else{
                        self.showPrompt()
                    }
                }else{
                    self.showPrompt()
                }
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        if promptTime?.timeIntervalSinceNow <= -300 {
            Utility.setBotheringLocalNotification()
        }else{
            Utility.setBotheringLocalNotification(true)
        }
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        var freqVariable = settings.waFreq*3600
        if currentMode == .HS {
            freqVariable = settings.hsFreq*3600
        }
        
        let timeSinceLastEpisode = ToiletEpisodeService.timeSinceLastEpisode()
        if isTestMode {
            freqVariable = 0
        }
        if Int(timeSinceLastEpisode) >= freqVariable {
            self.showPrompt()
        }
        
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func showPrompt(){
        if topVC != nil {
            let topVCMirror = Mirror(reflecting: topVC)
            if topVCMirror.subjectType == FlowChartViewController?.self {
                self.playAlertSound()
            }
        }else{
            let flowChartNav = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("FlowChartNav") as! UINavigationController
            let flowChartVC = flowChartNav.topViewController as! FlowChartViewController
            flowChartVC.flowChartID = "P-1"
            self.topVC = flowChartVC
            self.window?.rootViewController?.presentViewController(flowChartNav, animated: true, completion: {
                self.playAlertSound()
            })
        }
    }
    
    func playAlertSound(){
        let soundFilePath = NSBundle.mainBundle().pathForResource("Alert", ofType: "mp3")
        let fileURL = NSURL(fileURLWithPath: soundFilePath!)
        do{
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: fileURL)
            self.audioPlayer.play()
        }catch{
            print("something wrong with file path")
        }

    }
    
    func loadSettings(){
        let settingsCheck = NSUserDefaults.standardUserDefaults().objectForKey("WAFreq") as? Int
        var voidFriendlyNameVal : Int!
        var bmFriendlyNameVal: Int!
        var isUSClock: Bool!
        if settingsCheck == nil{
            let path = NSBundle.mainBundle().pathForResource("DefaultSettings", ofType: "plist")
            let defaultSettings = NSDictionary(contentsOfFile: path!)
            settings.hoursOfSleepStartTime = defaultSettings!.objectForKey("TimeToGoToSleep") as! NSDate
            settings.whileAwakeStartTime = defaultSettings!.objectForKey("TimeToWakeUp") as! NSDate
            settings.waFreq = defaultSettings!.objectForKey("WAFreq") as! Int
            settings.hsFreq = defaultSettings!.objectForKey("HSFreq") as! Int
            isUSClock = defaultSettings!.objectForKey("IsUSClock") as! Bool
            voidFriendlyNameVal = defaultSettings!.objectForKey("VOIDFriendlyName") as! Int
            bmFriendlyNameVal = defaultSettings!.objectForKey("BMFriendlyName") as! Int
        }else{
            settings.hoursOfSleepStartTime = NSUserDefaults.standardUserDefaults().objectForKey("TimeToGoToSleep") as! NSDate
            settings.whileAwakeStartTime = NSUserDefaults.standardUserDefaults().objectForKey("TimeToWakeUp") as! NSDate
            settings.waFreq = NSUserDefaults.standardUserDefaults().objectForKey("WAFreq") as! Int
            settings.hsFreq = NSUserDefaults.standardUserDefaults().objectForKey("HSFreq") as! Int
            isUSClock = NSUserDefaults.standardUserDefaults().objectForKey("IsUSClock") as! Bool
            voidFriendlyNameVal = NSUserDefaults.standardUserDefaults().objectForKey("VOIDFriendlyName") as! Int
            bmFriendlyNameVal = NSUserDefaults.standardUserDefaults().objectForKey("BMFriendlyName") as! Int
        }
        
        if let careGiverName = NSUserDefaults.standardUserDefaults().objectForKey("CareGiverName") as? String {
            settings.careGiverName = careGiverName
            settings.careGiverNumber = NSUserDefaults.standardUserDefaults().objectForKey("CareGiverNumber") as! String
        }
            
        if isUSClock == true {
            settings.clockPref = .US
        }else{
            settings.clockPref = .EU
        }
        switch voidFriendlyNameVal {
        case 0:
            settings.voidFriendlyName = .VOID
        case 1:
            settings.voidFriendlyName = .Urinate
        case 2:
            settings.voidFriendlyName = .Pee
        case 3:
            settings.voidFriendlyName = .NumberOne
        default:
            settings.voidFriendlyName = .VOID
        }
        switch bmFriendlyNameVal {
        case 0:
            settings.bmFriendlyName = .BM
        case 1:
            settings.bmFriendlyName = .BowlMovement
        case 2:
            settings.bmFriendlyName = .Poop
        case 3:
            settings.bmFriendlyName = .NumberTwo
        default:
            settings.bmFriendlyName = .BM
        }
    }
}

