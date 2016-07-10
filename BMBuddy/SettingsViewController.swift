//
//  SettingsViewControllerTableViewController.swift
//  BMBuddy
//
//  Created by Jung Kim on 4/24/16.
//  Copyright © 2016 Jung Kim. All rights reserved.
//

import UIKit

enum SleepPattern: Int {
    case TimeToSleep = 0
    case TimeToWakeUp
}

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var timeToGoToSleepLabel: UILabel!
    @IBOutlet weak var timeToWakeUpLabel: UILabel!
    
    @IBOutlet weak var clockUSCell: UITableViewCell!
    @IBOutlet weak var clockEUCell: UITableViewCell!

    @IBOutlet weak var waStepper: UIStepper!
    @IBOutlet weak var hsStepper: UIStepper!
    @IBOutlet weak var waLabel: UILabel!
    @IBOutlet weak var hsLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var settings = Settings.sharedInstance
    var localSettings = Settings()
    var dateFormatter = NSDateFormatter()
    var timeToGoToSleep : NSDate!{
        didSet {
            self.timeToGoToSleepLabel.text = self.settings.displayTime(timeToGoToSleep)
        }
    }
    var timeToWakeUp : NSDate! {
        didSet {
            self.timeToWakeUpLabel.text = self.settings.displayTime(timeToWakeUp)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localSettings.hoursOfSleepStartTime = settings.hoursOfSleepStartTime
        localSettings.whileAwakeStartTime = settings.whileAwakeStartTime
        localSettings.waFreq = settings.waFreq
        localSettings.hsFreq = settings.hsFreq
        localSettings.clockPref = settings.clockPref
        localSettings.bmFriendlyName = settings.bmFriendlyName
        localSettings.voidFriendlyName = settings.voidFriendlyName
        self.loadSettings()
        
//        self.saveButton.enabled = false
        navigationItem.rightBarButtonItem = nil
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "clockPreferenceChanged:", name: "ClockPreferenceChangedNotification", object: nil)

    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ClockPreferenceChangedNotification", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadSettings()
    }
    
    override func viewWillDisappear(animated: Bool) {
        localSettings.hoursOfSleepStartTime = settings.hoursOfSleepStartTime
        localSettings.whileAwakeStartTime = settings.whileAwakeStartTime
        localSettings.waFreq = settings.waFreq
        localSettings.hsFreq = settings.hsFreq
        localSettings.clockPref = settings.clockPref
        localSettings.bmFriendlyName = settings.bmFriendlyName
        self.settingsValueChanged()
        super.viewWillDisappear(animated)
    }

    func loadSettings(){
        timeToGoToSleep = settings.hoursOfSleepStartTime
        timeToWakeUp = settings.whileAwakeStartTime
        if localSettings.hoursOfSleepStartTime != settings.hoursOfSleepStartTime {
            timeToGoToSleep = localSettings.hoursOfSleepStartTime
        }
        if localSettings.whileAwakeStartTime != settings.whileAwakeStartTime {
            timeToWakeUp = localSettings.whileAwakeStartTime
        }
        
        self.waStepper.value = Double(settings.waFreq)
        self.hsStepper.value = Double(settings.hsFreq)
        waLabel.text = "Every \(settings.waFreq) Hours"
        hsLabel.text = "Every \(settings.hsFreq) Hours"
        if settings.clockPref == .US {
            self.clockUSCell.accessoryType = .Checkmark
            self.clockEUCell.accessoryType = .None
        }else{
            self.clockEUCell.accessoryType = .Checkmark
            self.clockUSCell.accessoryType = .None
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       var selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        if selectedCell == clockEUCell {
            clockEUCell.accessoryType = .Checkmark
            clockUSCell.accessoryType = .None
            self.localSettings.clockPref = .EU
        }else if selectedCell == clockUSCell {
            clockUSCell.accessoryType = .Checkmark
            clockEUCell.accessoryType = .None
            self.localSettings.clockPref = .US
        }
        self.settingsValueChanged()
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        if segue.identifier == "SetTime" {
            if let vc = segue.sourceViewController as? TimePickerViewController {
                
                if vc.sleepPattern == .TimeToSleep {
                    localSettings.hoursOfSleepStartTime = vc.timePicker.date
                }else{
                    localSettings.whileAwakeStartTime = vc.timePicker.date
                }
                self.settingsValueChanged()
            }
        }
    }
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        if sender  == waStepper {
            waLabel.text = "Every \(Int(waStepper.value)) Hours"
            self.localSettings.waFreq = Int(waStepper.value)
        }else if sender == hsStepper {
            hsLabel.text = "Every \(Int(hsStepper.value)) Hours"
            self.localSettings.hsFreq = Int(hsStepper.value)
        }
        self.settingsValueChanged()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSleepTimePicker" {
            var vc = segue.destinationViewController as! TimePickerViewController
            vc.sleepPattern = .TimeToSleep
        }else if segue.identifier == "ShowWakeUpTimePicker" {
            var vc = segue.destinationViewController as! TimePickerViewController
            vc.sleepPattern = .TimeToWakeUp
        }
    }
    
    func clockPreferenceChanged(notification: NSNotification){
        
        self.timeToGoToSleepLabel.text = self.settings.displayTime(self.timeToGoToSleep)
        self.timeToWakeUpLabel.text = self.settings.displayTime(self.timeToWakeUp)
    }
    
    func settingsValueChanged(){
        let sleepTime = settings.hoursOfSleepStartTime != localSettings.hoursOfSleepStartTime
        let wakeupTime = settings.whileAwakeStartTime != localSettings.whileAwakeStartTime
        let waFreq = settings.waFreq != localSettings.waFreq
        let hsFreq = settings.hsFreq != localSettings.hsFreq
        let clockPref = settings.clockPref != localSettings.clockPref
        let bmName = settings.bmFriendlyName != localSettings.bmFriendlyName
        let voidName = settings.voidFriendlyName != localSettings.voidFriendlyName
        if sleepTime || wakeupTime || waFreq || hsFreq || clockPref || bmName || voidName {
            self.saveButtonPressed(self)
            //self.saveButton.enabled = true
        }else{
            //self.saveButton.enabled = false
        }
    }
    
    @IBAction func TestModeValueChanged(sender: AnyObject) {
        let switchControl = sender as! UISwitch
        isTestMode = switchControl.on
        self.tabBarController?.selectedIndex = 0
    }
    
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        if settings.clockPref != localSettings.clockPref {
            NSNotificationCenter.defaultCenter().postNotificationName("ClockPreferenceChangedNotification", object: nil)
        }
        settings.hoursOfSleepStartTime = localSettings.hoursOfSleepStartTime
        settings.whileAwakeStartTime = localSettings.whileAwakeStartTime
        settings.waFreq = localSettings.waFreq
        settings.hsFreq = localSettings.hsFreq
        settings.clockPref = localSettings.clockPref
        settings.bmFriendlyName = localSettings.bmFriendlyName
        settings.voidFriendlyName = localSettings.voidFriendlyName
        var userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(settings.hoursOfSleepStartTime, forKey: "TimeToGoToSleep")
        userDefault.setObject(settings.whileAwakeStartTime, forKey: "TimeToWakeUp")
        userDefault.setObject(settings.waFreq, forKey: "WAFreq")
        userDefault.setObject(settings.hsFreq, forKey: "HSFreq")
        var isUSClock : Bool = settings.clockPref == .US
        userDefault.setObject(isUSClock, forKey: "IsUSClock")
        userDefault.setObject(settings.voidFriendlyName.rawValue, forKey: "VOIDFriendlyName")
        userDefault.setObject(settings.bmFriendlyName.rawValue, forKey: "BMFriendlyName")
        userDefault.synchronize()
//        self.saveButton.enabled = false
    }
    
}
