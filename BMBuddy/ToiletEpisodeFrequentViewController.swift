//
//  ToiletEpisodeFrequentViewController.swift
//  BMBuddy
//
//  Created by Jung Kim on 3/13/16.
//  Copyright © 2016 Jung Kim. All rights reserved.
//

import UIKit

class ToiletEpisodeFrequentViewController: UIViewController {
    
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var lastToiletingTimeVoid: UILabel!
    @IBOutlet weak var lastToiletingTimeBM: UILabel!
    
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var min: UILabel!
    
    var settings = Settings.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var lastToiletingTime = NSUserDefaults.standardUserDefaults().objectForKey("lastEpisodeTime") as? NSDate
        
        var freqVariable = settings.waFreq*3600
        var timeLeftUntilNextPrompt: Int!
        if currentMode == .HS {
            freqVariable = settings.hsFreq*3600
        }
        let timeSinceLastEpisode = ToiletEpisodeService.timeSinceLastEpisode()
        if timeSinceLastEpisode > 0 && Int(timeSinceLastEpisode) < freqVariable {
            timeLeftUntilNextPrompt = (freqVariable-Int(timeSinceLastEpisode))/60
        }else{
            timeLeftUntilNextPrompt = freqVariable/60
        }
        
        let time = Utility.parseTimeLeft(timeLeftUntilNextPrompt)
        self.hour.text = time.hour
        self.min.text = time.min
        
        let lastVoidTime = NSUserDefaults.standardUserDefaults().objectForKey("lastVoidEpisodeTime") as? NSDate
        let lastBmTime = NSUserDefaults.standardUserDefaults().objectForKey("lastBmEpisodeTime") as? NSDate
        
        if lastVoidTime != nil {
            lastToiletingTimeVoid.text = self.settings.displayTime(lastVoidTime!)
        }else {
            lastToiletingTimeVoid.text = "NA"
        }
        if lastBmTime != nil {
            lastToiletingTimeBM.text = self.settings.displayTime(lastBmTime!)
        }else {
            lastToiletingTimeBM.text = "NA"
        }

    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        let button = sender as! UIButton
        if button == yesButton {
            performSegueWithIdentifier("ShowToiletVC", sender: nil)
            
        }else{
             self.tabBarController!.selectedIndex = 0
        }
    }
    

}
