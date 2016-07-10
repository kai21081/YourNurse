//
//  ToiletEpisodeAccidentViewController.swift
//  BMBuddy
//
//  Created by Jung Kim on 3/6/16.
//  Copyright © 2016 Jung Kim. All rights reserved.
//

import UIKit

class ToiletEpisodeAccidentViewController: UIViewController, UITabBarControllerDelegate {
    
    var episodeType: EpisodeType!
    var episodeTime: NSDate?
    var selectedColor = UIColor.blackColor()
    var normalColor : UIColor!
    var isEpisodeOnToilet: Bool?
    var isAccident: Bool = false
    
    @IBOutlet weak var epOnToiletYesButton: UIButton!
    @IBOutlet weak var epOnToiletNoButton: UIButton!
    @IBOutlet weak var epText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        normalColor = epOnToiletYesButton.backgroundColor
    }
    @IBAction func answerButtonPressed(sender: AnyObject) {
        var selectedButton = sender as! UIButton
        selectedButton.backgroundColor = selectedColor
        lastToiletingTime = episodeTime
        
        if selectedButton == epOnToiletYesButton {
            epOnToiletNoButton.backgroundColor = normalColor
            isEpisodeOnToilet = true
            ToiletEpisodeService.saveEpisode(episodeTime!, episodeType: episodeType, isAccident: isAccident)
            self.tabBarController?.selectedIndex = 0
        }else if selectedButton == epOnToiletNoButton {
            epOnToiletYesButton.backgroundColor = normalColor
            isEpisodeOnToilet = false
            isAccident = true
            ToiletEpisodeService.saveEpisode(episodeTime!, episodeType: episodeType, isAccident: isAccident)
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    
}