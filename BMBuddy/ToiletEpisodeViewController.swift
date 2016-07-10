//
//  ToiletEpisodeViewController.swift
//  BMBuddy
//
//  Created by Jung Kim on 1/31/16.
//  Copyright © 2016 Jung Kim. All rights reserved.
//

import UIKit

enum EpisodeType: String {
    case VOID = "VOID"
    case BM = "BM"
    case VOIDBM = "VOID+BM"
}

class ToiletEpisodeViewController: UIViewController {
    
    @IBOutlet weak var voidEpisode: UIButton!
    
    @IBOutlet weak var bmEpisode: UIButton!
    @IBOutlet weak var voidBmEpisode: UIButton!
    @IBOutlet weak var lastVOIDTime: UILabel!
    @IBOutlet weak var lastBMTime: UILabel!
    
    
    var selectedEpisode: EpisodeType? = .VOID
    var settings = Settings.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        
        let lastToiletingTimeVoid = NSUserDefaults.standardUserDefaults().objectForKey("lastVoidEpisodeTime") as? NSDate
        let lastToiletingTimeBm = NSUserDefaults.standardUserDefaults().objectForKey("lastBmEpisodeTime") as? NSDate
        
        if lastToiletingTimeVoid != nil {
            lastVOIDTime.text = self.settings.displayTime(lastToiletingTimeVoid!)
        }else {
            lastVOIDTime.text = "NA"
        }
        if lastToiletingTimeBm != nil {
            lastBMTime.text = self.settings.displayTime(lastToiletingTimeBm!)
        }else {
            lastBMTime.text = "NA"
        }

        
    }
    
    @IBAction func episodeButtonPressed(sender: AnyObject) {
        let selectedButton = sender as! UIButton
        
        if selectedButton == voidEpisode {
            selectedEpisode = .VOID
        }else if selectedButton == bmEpisode {
            selectedEpisode = .BM
        }else if selectedButton == voidBmEpisode {
            selectedEpisode = .VOIDBM
        }else {
            selectedEpisode = nil
        }
        performSegueWithIdentifier("EpisodeTime", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EpisodeTime" {
            let episodeTimeVC = segue.destinationViewController as! ToiletEpisodeTimeViewController
            episodeTimeVC.episodeType = selectedEpisode
        }
    }
    

}
