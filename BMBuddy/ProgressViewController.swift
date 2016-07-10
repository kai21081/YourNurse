//
//  ProgressViewController.swift
//  BMBuddy
//
//  Created by Jung Kim on 1/23/16.
//  Copyright © 2016 Jung Kim. All rights reserved.
//

import UIKit
import Charts

class ProgressViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var data1 = ["test", "test1", "test2", "test3"]
    var data2 = ["test", "test1", "test2", "test3"]
    var data3 = ["test", "test1", "test2", "test3"]
    var data4 = ["test", "test1", "test2", "test3"]
    var data5 = ["test", "test1", "test2", "test3"]
    var data6 = ["test", "test1", "test2", "test3"]
    var data7 = ["test", "test1", "test2", "test3"]
    var sectionHeaders = [String]()//["3/21/16", "3/20/16", "3/19/16", "3/18/16", "3/17/16", "3/16/16", "3/15/16"]
    var data = [[[String:AnyObject]]]()
    var dateFormatter = NSDateFormatter()
    var timeFormatter = NSDateFormatter()
    var settings = Settings.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.dateFormatter.dateFormat = "M/dd/yy"
        self.timeFormatter.dateFormat = "h:mm a"
        self.processToiletEpisodes()
        //data = [data1, data2, data3, data4, data5, data6, data7]
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.sectionHeaders = [String]()
        self.data = [[[String:AnyObject]]]()
        self.processToiletEpisodes()
        self.tableView.reloadData()
    }
    
    func processToiletEpisodes(){
        var toiletEpisodes = ToiletEpisodeService.allEpisodes
        if toiletEpisodes != nil {
            toiletEpisodes!.sortInPlace {
                item1, item2 in
                let date1 = item1["episodeTime"] as! NSDate
                let date2 = item2["episodeTime"] as! NSDate
                return date1.compare(date2) == NSComparisonResult.OrderedDescending
            }
            var dateToCompare : NSDate?
            var episodesByDay = [[String:AnyObject]]()
            for var i = 0 ; i < toiletEpisodes!.count; i++ {
                let currentEpisode = toiletEpisodes![i]
                
                let episodeTime = currentEpisode["episodeTime"] as! NSDate
                if dateToCompare == nil {
                    self.sectionHeaders.append(self.dateFormatter.stringFromDate(episodeTime))
                    dateToCompare = episodeTime
                }else{
                    if self.dateFormatter.stringFromDate(dateToCompare!) != self.dateFormatter.stringFromDate(episodeTime) {
                        self.data.append(episodesByDay)
                        self.sectionHeaders.append(self.dateFormatter.stringFromDate(episodeTime))
                        dateToCompare = episodeTime
                        episodesByDay.removeAll()
                    }
                }
                episodesByDay.append(currentEpisode)
            }
            self.data.append(episodesByDay)
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("RecordCell") as! RecordCell
        let episodeData = data[indexPath.section][indexPath.row]
        let episodeTime = episodeData["episodeTime"] as! NSDate
        let isVoid = episodeData["isVoid"] as! Bool
        let isBm = episodeData["isBm"] as! Bool
        let isAccident = episodeData["isAccident"] as! Bool
        let isSkipped = episodeData["isSkipped"] as! Bool
        let isDryRun = episodeData["isDryRun"] as! Bool
        cell.timeLabel.text = self.settings.displayTime(episodeTime)
        cell.voidCheckImage.hidden = !isVoid
        cell.bmCheckImage.hidden = !isBm
        cell.accidentCheckImage.hidden = !isAccident
        cell.dryRunCheckImage.hidden = !isDryRun
        cell.voidCheckView.hidden = isSkipped
        cell.bmCheckView.hidden = isSkipped
        cell.accidentCheckView.hidden = isSkipped
        cell.dryRunCheckView.hidden = isSkipped
        cell.skippedView.hidden = !isSkipped
        return cell

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    @IBAction func editButtonPressed(sender: AnyObject) {
//       self.tableView.setEditing(true, animated: true)
    }
}
