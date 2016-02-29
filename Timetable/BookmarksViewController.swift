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
    var groups = [Group]()
    var filteredGroups = [Group]()
    override func viewDidLoad() {
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"GROUP")
        self.tableView.backgroundColor = UIColor.polytechColor()
        super.viewDidLoad()
        self.navigationItem.title="Избранное"
        tableView.delegate=self
        self.groups = Array(TTDB.bookmarks)
        dispatch_async(dispatch_get_main_queue(),{
            TTDB.loadBookmarks()            
            self.filteredGroups = self.groups
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
        self.groups = Array(TTDB.bookmarks)
        self.searchBar.text=""
        self.searchBar.resignFirstResponder()
        self.filteredGroups=groups
        super.viewWillAppear(animated)
    }
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int)->Int
    {
        return filteredGroups.count
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
        let groupName=filteredGroups[groupIdx].name
        cell.textLabel?.text = groupName
        cell.tintColor=tableView.tintColor
        cell.textLabel?.textColor=UIColor.whiteColor()
        cell.backgroundColor=tableView.backgroundColor
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let groupIdx=indexPath.row
        let sel_group=filteredGroups[groupIdx]
        self.selectedGroup=sel_group
        tableView.deselectRowAtIndexPath(indexPath,animated:true)
        if selectedGroup != nil
        {
            self.performSegueWithIdentifier("showTimetable", sender:self)
        }
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
            self.filteredGroups = self.groups
            return
        }
        self.filteredGroups = groups.filter { group in
            return group.name.containsString(searchText)
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
