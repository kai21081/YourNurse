//
//  HomeViewController.swift
//  BMBuddy
//
//  Created by Jung Kim on 12/31/15.
//  Copyright © 2015 Jung Kim. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func waButtonPressed(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setValue("WhileAwake", forKey: "CurrentMode")
        currentMode = .WA
        self.showP1()
    }
    

    @IBAction func hsButtonPressed(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setValue("HoursOfSleep", forKey: "CurrentMode")
        currentMode = .HS
        self.showP1()
    }
    
    func showP1(){
        let tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarVC") as! UITabBarController
        
//        let flowChartVC = flowChartNav.topViewController as! FlowChartViewController
//        flowChartVC.flowChartID = "P-1"
        self.presentViewController(tabBarController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
