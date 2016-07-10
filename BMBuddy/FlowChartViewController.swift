//
//  ViewController.swift
//  BMBuddy
//
//  Created by Jung Kim on 12/31/15.
//  Copyright © 2015 Jung Kim. All rights reserved.
//

import UIKit
import MessageUI
import AVFoundation

enum AppMode: String {
    case WA = "While Awake"
    case HS = "Hours of Sleep"
}

struct ToiletEpisode {
    var time : NSDate?
    var isAccident : Bool = false
    var type : EpisodeType?
    var isDryRun : Bool = false
}

class FlowChartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate{

    @IBOutlet weak var textViewHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var flowChartID: String?
    var prevFlowChartID: String?
    var buttons: [[String:AnyObject]]?
    var text: String?
    var viewTemplate: Int!
    var freqVariableHour: Int!
    var freqVariableMin: Int = 0
    var timer: NSTimer?
    var noResponseTimer: NSTimer?
    var timeDiff: Int?
    var settings = Settings.sharedInstance
    var audioPlayer = AVAudioPlayer()
    var toiletEpisode : ToiletEpisode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        if self.flowChartID == nil {
            self.flowChartID = "P-1"
        }
        if currentMode == .WA {
            freqVariableHour = settings.waFreq
        }else{
            freqVariableHour = settings.hsFreq
        }
        
        let path = NSBundle.mainBundle().pathForResource("FlowChart", ofType: "plist")
        let flowChartData = NSDictionary(contentsOfFile: path!)!
        let currentChart = flowChartData.objectForKey(flowChartID!) as! [String:AnyObject]
        if lastToiletingTime != nil {
            self.timeDiff = Int(NSDate().timeIntervalSince1970 -  lastToiletingTime!.timeIntervalSince1970)
        }
        
        if flowChartID! == "P-3" {
            freqVariableHour = Int(ToiletEpisodeService.timeSinceLastEpisode()/3600)
            freqVariableMin = Int(ceil((ToiletEpisodeService.timeSinceLastEpisode()%3600)/60))
        }
        var freqVariableTimeString = "\(self.freqVariableHour) hour"
        if self.freqVariableHour > 1 {
            freqVariableTimeString += "s"
        }
        if freqVariableMin != 0 {
            freqVariableTimeString += " \(self.freqVariableMin) min"
        }
        if freqVariableHour == 0 {
            freqVariableTimeString = "\(self.freqVariableMin) min"
        }
        if self.freqVariableMin > 1 {
            freqVariableTimeString += "s"
        }
        
        
        self.viewTemplate = currentChart["ViewTemplate"] as! Int
        self.text = currentChart["Text"] as? String
        self.text = self.text?.stringByReplacingOccurrencesOfString("FreqVariable", withString: freqVariableTimeString)
        
 
        
        if self.text != nil {
            self.textView.text = self.text!.stringByReplacingOccurrencesOfString("-newLine-", withString: "\n")
        }
        self.buttons = currentChart["Buttons"] as? [[String:AnyObject]]
        if self.buttons != nil {
            self.tableView.reloadData()
        }else{
            self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "gotoTimerScreen", userInfo: nil, repeats: false)
        }
        
        if self.viewTemplate == 3 {
            self.textViewHeightContraint.constant = 0
            self.view.needsUpdateConstraints()
        } else if self.viewTemplate == 2 {
            self.textViewHeightContraint.constant = 540
            self.view.needsUpdateConstraints()
        }
        
        if self.toiletEpisode == nil {
            self.toiletEpisode = ToiletEpisode()
        }
        if flowChartID! == "P-4" {
            ToiletEpisodeService.saveEpisode(self.toiletEpisode!.time!, episodeType: self.toiletEpisode!.type, isAccident: self.toiletEpisode!.isAccident, isDryRun: self.toiletEpisode!.isDryRun)
        }
        
    }
    override func viewWillDisappear(animated: Bool) {
        if self.timer != nil {
            self.timer!.invalidate()
            self.timer = nil
        }
        if self.noResponseTimer != nil {
            self.noResponseTimer!.invalidate()
            self.noResponseTimer = nil
        }
        super.viewWillDisappear(animated)
    }
    
    func gotoTimerScreen() {
        self.dismissAndShowTabBar(0)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell") as! ButtonCell
        if self.buttons != nil {
            let curButtonObj = self.buttons![indexPath.row]
            let curButtonTitle = curButtonObj["Title"] as! String
//            let curButtonAction = curButtonObj["Action"] as! String
            cell.label.text = curButtonTitle
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.buttons == nil {
            return 0
        }else{
            return self.buttons!.count
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let curButtonObj = self.buttons![indexPath.row]
        var curAction = curButtonObj["Action"] as! String
        if curAction.rangeOfString("P-") != nil {
            if curAction == "P-8-R"{
                let selectedEpisodeType = curButtonObj["EpisodeType"] as! String
                var episodeType : EpisodeType = .VOID
                if selectedEpisodeType == "BM" {
                    episodeType = .BM
                }else if selectedEpisodeType == "VOIDBM"{
                    episodeType = .VOIDBM
                }
                self.toiletEpisode!.time = NSDate()
                self.toiletEpisode!.type = episodeType
            }
            if curAction == "P-4" {
                self.toiletEpisode!.time = NSDate()
                if self.flowChartID == "P-9-R" {
                    self.toiletEpisode!.isDryRun = true
                }else if self.flowChartID == "P-8-R" {
                    let soundFilePath = NSBundle.mainBundle().pathForResource("applause", ofType: "mp3")
                    let fileURL = NSURL(fileURLWithPath: soundFilePath!)
                    do{
                        self.audioPlayer = try AVAudioPlayer(contentsOfURL: fileURL)
                        self.audioPlayer.play()
                    }catch{
                        print("something wrong with file path")
                    }
                }
            }
            if curAction == "P-15-R" {
                self.toiletEpisode!.isAccident = true
            }
            let flowChartVC = self.storyboard?.instantiateViewControllerWithIdentifier("FlowChartVC") as! FlowChartViewController
            flowChartVC.flowChartID = curAction
            flowChartVC.prevFlowChartID = self.flowChartID
            flowChartVC.toiletEpisode = self.toiletEpisode
            self.navigationController?.pushViewController(flowChartVC, animated: true)
        }
        
        if curAction.rangeOfString("R-") != nil {
            if curAction == "R-11" {
                if currentMode == .HS {
                    if self.timeDiff == nil || self.timeDiff > freqVariableHour*3600 {
                        curAction = "P-2"
                    }else{
                        curAction = "P-12"
                        //Is this skipped???
                    }
                }else {
                    if self.timeDiff == nil || self.timeDiff > freqVariableHour*3600 {
                        curAction = "P-2"
                    }else{
                        curAction = "P-3"
                    }

                }
                let flowChartVC = self.storyboard?.instantiateViewControllerWithIdentifier("FlowChartVC") as! FlowChartViewController
                flowChartVC.flowChartID = curAction
                flowChartVC.toiletEpisode = self.toiletEpisode
                self.navigationController?.pushViewController(flowChartVC, animated: true)
            }else if curAction == "R-30" {
                self.dismissAndShowTabBar(1)
            }
        }
        if curAction.rangeOfString("Home") != nil {
            self.dismissAndShowTabBar(0)
        }
        
        if curAction.rangeOfString("sendMessage") != nil {
            let msgController = MFMessageComposeViewController()
            if MFMessageComposeViewController.canSendText() {
                msgController.body = "I Need Help.\rPlease check-in on me."
                msgController.recipients = [settings.careGiverNumber]
                msgController.messageComposeDelegate = self
                self.presentViewController(msgController, animated: true, completion: nil)
            }
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true) {
            if self.flowChartID == "P-9-R" {
                self.dismissAndShowTabBar(0)
            }else{
                let flowChartVC = self.storyboard?.instantiateViewControllerWithIdentifier("FlowChartVC") as! FlowChartViewController
                flowChartVC.flowChartID = "P-4"
                flowChartVC.prevFlowChartID = self.flowChartID
                flowChartVC.toiletEpisode = self.toiletEpisode
                self.navigationController?.pushViewController(flowChartVC, animated: true)
            }
        }
    }
    
    func dismissAndShowTabBar(index: Int) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: {
            let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
            let viewController = appDelegate.window!.rootViewController as! BMTabBarController
            viewController.selectedIndex = index
        })
    }

}

