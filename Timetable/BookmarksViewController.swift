//
//  BookmarksViewController.swift
//  Timetable
//
//  Created by Maxim Usmanov (SPHERE PO) on 25/02/2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import UIKit

class BookmarksViewController: SearchViewController
{
    var groupNames = [String]()
    var filteredGroupNames = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="Избранное"
        tableView.delegate=self
        
        dispatch_async(dispatch_get_main_queue(),{
            TTDB.loadBookmarks()
            self.groupNames = Array(TTDB.bookmarks)
            self.groupNames = self.groupNames.sort()
            self.tableView.reloadData()
            self.tableView.setNeedsDisplay()
            self.filteredGroupNames = self.groupNames
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let groupIdx=indexPath.row
        let cell = tableView.dequeueReusableCellWithIdentifier("GROUP",forIndexPath:indexPath)
        let groupName=filteredGroupNames[groupIdx]
        cell.textLabel?.text = groupName
        cell.tintColor=tableView.tintColor
        cell.textLabel?.textColor=UIColor.whiteColor()
        cell.backgroundColor=tableView.backgroundColor
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let groupIdx=indexPath.row
        let groupName=filteredGroupNames[groupIdx]
        self.selectedGroup=TTDB.findGroup(groupName)
        tableView.deselectRowAtIndexPath(indexPath,animated:true)
        self.performSegueWithIdentifier("showTimetable", sender:self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="showTimetable")
        {
            if let vc=segue.destinationViewController as?CalendarViewController
            {
                vc.group=selectedGroup
            }
        }
        super.prepareForSegue(segue,sender:sender)
    }
    override func filterContentForSearchText(searchText: String) {
        if searchText == "" {
            self.filteredGroupNames = self.groupNames
            return
        }
        self.filteredGroupNames = groupNames.filter { group in
            return group.containsString(searchText)
        }
        tableView.reloadData()
        self.tableView.setNeedsDisplay()
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
