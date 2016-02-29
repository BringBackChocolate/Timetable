//
//  BookmarksViewController.swift
//  Timetable
//
//  Created by Maxim Usmanov (SPHERE PO) on 25/02/2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import UIKit

class BookmarksViewController: UIViewController , UITableViewDataSource , UITableViewDelegate, UISearchBarDelegate
{
    @IBOutlet var tableView:UITableView!
    @IBOutlet var searchBar:UISearchBar!
    var selectedGroup:Group?
    var groupNames = [String]()
    var filteredGroupNames = [String]()
    override func viewDidLoad() {
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"GROUP")
        self.tableView.backgroundColor = UIColor.polytechColor()
        super.viewDidLoad()
        self.navigationItem.title="Избранное"
        tableView.delegate=self
        self.groupNames = Array(TTDB.bookmarks)
        dispatch_async(dispatch_get_main_queue(),{
            TTDB.loadBookmarks()
            self.groupNames = self.groupNames.sort()
            self.filteredGroupNames = self.groupNames
            self.tableView.reloadData()
            self.tableView.setNeedsDisplay()
        })
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated:Bool)
    {
        self.navigationController?.setNavigationBarHidden(false,animated:animated)
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    override func viewWillAppear(animated: Bool)
    {
        self.groupNames = Array(TTDB.bookmarks)
        self.searchBar.text=""
        self.searchBar.resignFirstResponder()
        self.filteredGroupNames=groupNames
        super.viewWillAppear(animated)
    }
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int)->Int
    {
        return filteredGroupNames.count
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath:NSIndexPath)->Bool
    {
        return false
    }
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath)->Bool
    {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
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
    func filterContentForSearchText(searchText: String) {
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
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        filterContentForSearchText(searchBar.text!)
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
