//
//  PromptTimerViewController.swift
//  BMBuddy
//
//  Created by Jung Kim on 1/31/16.
//  Copyright © 2016 Jung Kim. All rights reserved.
//

import UIKit

class PromptTimerViewController: UIViewController {

    @IBOutlet weak var promptText: UILabel!
    var timeLeftUntilNextPrompt: Int!
    var freqVariable : Int!
    var timer: NSTimer?
    var localLastToiletingTimeForTimer: NSDate?
    
    @IBOutlet weak var hourText: UILabel!
    @IBOutlet weak var minText: UILabel!
    var settings = Settings.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        if NSUserDefaults.standardUserDefaults().objectForKey("CareGiverName") == nil {
            let onBoardNav = self.storyboard?.instantiateViewControllerWithIdentifier("OnBoardNav") as! UINavigationController
            let onBoardVC = onBoardNav.topViewController as! OnBoardViewController
            self.presentViewController(onBoardNav, animated: true, completion: nil)
        }
        var lastToiletingTime = NSUserDefaults.standardUserDefaults().objectForKey("lastEpisodeTime") as? NSDate
        if currentMode == .WA {
            freqVariable = settings.waFreq*3600
        }else{
            freqVariable = settings.hsFreq*3600
        }
        let timeSinceLastEpisode = ToiletEpisodeService.timeSinceLastEpisode()
        localLastToiletingTimeForTimer = ToiletEpisodeService.lastEpisodeTime
        if timeSinceLastEpisode > 0 && Int(timeSinceLastEpisode) < freqVariable {
            timeLeftUntilNextPrompt = (freqVariable-Int(timeSinceLastEpisode))/60
        }else{
            timeLeftUntilNextPrompt = freqVariable/60
        }
        Utility.setLocalNotification(timeLeftUntilNextPrompt)
        parseTimeLeft(Utility.getTimeLeftUntilNextPrompt(freqVariable))
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "promptUser", userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.topVC = nil
        if currentMode == .WA {
            freqVariable = settings.waFreq*3600
        }else{
            freqVariable = settings.hsFreq*3600
        }

        self.timer?.invalidate()
        self.timer = nil
        let timeSinceLastEpisode = ToiletEpisodeService.timeSinceLastEpisode()
        localLastToiletingTimeForTimer = ToiletEpisodeService.lastEpisodeTime
        if Int(timeSinceLastEpisode) < freqVariable {
            timeLeftUntilNextPrompt = (freqVariable - Int(timeSinceLastEpisode))/60
        }else{
            timeLeftUntilNextPrompt = freqVariable/60
        }
        if isTestMode{
                Utility.setLocalNotification(0)
        }else{
            Utility.setLocalNotification(timeLeftUntilNextPrompt)
        }
        parseTimeLeft(Utility.getTimeLeftUntilNextPrompt(freqVariable))
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "promptUser", userInfo: nil, repeats: true)
    }
    
    func parseTimeLeft(timeLeft: Int){
        
        let hour: Int = timeLeft/60
        let minutes = timeLeft%60

        self.hourText.text = String(format: "%02d", hour)
        self.minText.text = String(format: "%02d", minutes)
    }
    
    func promptUser(){
        timeLeftUntilNextPrompt = timeLeftUntilNextPrompt - 1
        if timeLeftUntilNextPrompt == 0 {
            self.timer?.invalidate()
            self.timer = nil
            self.tabBarController?.selectedIndex = 3
            
        }else{
            parseTimeLeft(timeLeftUntilNextPrompt)
        }
        
    }

}
