//
//  ToiletEpisodeHelpViewController.swift
//  BMBuddy
//
//  Created by Jung Kim on 6/9/16.
//  Copyright © 2016 Jung Kim. All rights reserved.
//

import UIKit
import MessageUI

class ToiletEpisodeHelpViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    var settings = Settings.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func noButtonPressed(sender: AnyObject) {
        self.tabBarController?.selectedIndex = 0
    }

    @IBAction func yesButtonPressed(sender: AnyObject) {
        let msgController = MFMessageComposeViewController()
        if MFMessageComposeViewController.canSendText() {
            msgController.body = "I Need Help.\rPlease check-in on me."
            msgController.recipients = [settings.careGiverNumber]
            msgController.messageComposeDelegate = self
            self.presentViewController(msgController, animated: true, completion: nil)
        }

    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
            controller.dismissViewControllerAnimated(true) { 
                self.tabBarController?.selectedIndex = 0
        }
    }
}
