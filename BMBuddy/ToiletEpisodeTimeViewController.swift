//
//  ToiletEpisodeTimeViewController.swift
//  BMBuddy
//
//  Created by Jung Kim on 3/6/16.
//  Copyright © 2016 Jung Kim. All rights reserved.
//

import UIKit

class ToiletEpisodeTimeViewController: UIViewController {
    
    var episodeType: EpisodeType?
    var episodeTime: NSDate!
    
    @IBOutlet weak var epTimeJustNow: UIButton!
    
    @IBOutlet weak var epTimeFifteenMin: UIButton!
    @IBOutlet weak var epTimeThirtyMin: UIButton!
    @IBOutlet weak var epTimeFortyFiveMin: UIButton!
    @IBOutlet weak var epTimeOneHour: UIButton!
    @IBOutlet weak var epTimeOneHrThirtyMin: UIButton!
    @IBOutlet weak var epTimeTwoHours: UIButton!
    @IBOutlet weak var epTimeDontKnow: UIButton!
    @IBOutlet weak var epTimeFiveHours: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func timeButtonPressed(sender: AnyObject) {
        var selectedButton = sender as! UIButton
        var epTime = NSDate().timeIntervalSince1970
        if selectedButton == epTimeFifteenMin {
            epTime = epTime - (15*60)
        }else if selectedButton == epTimeThirtyMin{
            epTime = epTime - (30*60)
        }else if selectedButton == epTimeFortyFiveMin{
            epTime = epTime - (45*60)
        }else if selectedButton == epTimeOneHour{
            epTime = epTime - (60*60)
        }else if selectedButton == epTimeOneHrThirtyMin{
            epTime = epTime - (90*60)
        }else if selectedButton == epTimeTwoHours {
            epTime = epTime - (120*60)
        }else if selectedButton == epTimeFiveHours {
            epTime = epTime - (300*60)
        }
        episodeTime = NSDate(timeIntervalSince1970: epTime)
        if episodeType == nil {
            ToiletEpisodeService.saveEpisode(episodeTime, episodeType: nil, isAccident: false, isDryRun: true)
            self.tabBarController?.selectedIndex = 0
        }else{
            performSegueWithIdentifier("EpisodeAccident", sender: nil)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EpisodeAccident" {
            var episodeAccidentVC = segue.destinationViewController as! ToiletEpisodeAccidentViewController
            episodeAccidentVC.episodeType = self.episodeType
            episodeAccidentVC.episodeTime = self.episodeTime
        }
    }
    
    
}