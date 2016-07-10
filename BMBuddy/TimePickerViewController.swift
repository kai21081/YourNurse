//
//  TimePickerViewController.swift
//  BMBuddy
//
//  Created by Jung Kim on 4/24/16.
//  Copyright © 2016 Jung Kim. All rights reserved.
//

import UIKit

class TimePickerViewController: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    var sleepPattern: SleepPattern!
    var newTime: NSDate!
    var clockPref: ClockPreference!
    var settings = Settings.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.datePickerMode = .Time
        if sleepPattern == .TimeToSleep {
            timePicker.setDate(settings.hoursOfSleepStartTime, animated: false)
        }else{
            timePicker.setDate(settings.whileAwakeStartTime, animated: false)
        }
        if settings.clockPref == .EU {
            let locale =  NSLocale(localeIdentifier: "NL")
            self.timePicker.locale = locale
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func setTimePressed(sender: AnyObject) {
//        self.newTime = timePicker.date
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
