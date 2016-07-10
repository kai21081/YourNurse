//
//  BMTabBarController.swift
//  BMBuddy
//
//  Created by Jung Kim on 3/13/16.
//  Copyright © 2016 Jung Kim. All rights reserved.
//

import UIKit

class BMTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

//        Utility.setLocalNotification(1)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if let navController = viewController as? UINavigationController{
            navController.popToRootViewControllerAnimated(false)
        }
        if self.selectedIndex == 1 {
            var timeDiff: NSTimeInterval = 2*3600
            if currentMode != .WA {
                timeDiff = 4*3600
            }
            print("\(ToiletEpisodeService.timeSinceLastEpisode())")
            if ToiletEpisodeService.timeSinceLastEpisode() > 0 {
                let currentTime = NSDate()
                if ToiletEpisodeService.timeSinceLastEpisode() < timeDiff {
                    let navVC = self.selectedViewController as! UINavigationController
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ToiletEpisodeFrequentVC") as! ToiletEpisodeFrequentViewController
                    navVC.pushViewController(vc, animated: false)
                }
            }
        }
    }

}
