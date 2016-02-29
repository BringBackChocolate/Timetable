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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Изменить", style: .Plain, target: self, action: "editingModeChange:")
        tableView.delegate=self
        self.groups = Array(TTDB.bookmarks)
        dispatch_async(dispatch_get_main_queue(),{
            TTDB.loadBookmarks()
            self.groups = self.groups.sort({g1,g2 in
                return g1.name<g2.name
            })
            self.filteredGroups = self.groups
            self.tableView.reloadData()
            self.tableView.setNeedsDisplay()
        })
        // Do any additional setup after loading the view.
    }
    
    func editingModeChange(sender: UIBarButtonItem)
    {
        self.tableView.setEditing(!self.tableView.editing, animated: true)
        if(self.tableView.editing)
        {
            sender.style = .Done
            sender.title = "Готово"
        }
        else
        {
            sender.style = .Plain
            sender.title = "Изменить"
        }
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
        return true
    }
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath)->Bool
    {
        return true
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
        if(self.tableView.editing != true && self.selectedGroup != nil)
        {
            tableView.deselectRowAtIndexPath(indexPath,animated:true)
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
            switch editingStyle {
            case .Delete:
                // remove the deleted item from the model
                self.filteredGroups.removeAtIndex(indexPath.row)
                
                // remove the deleted item from the `UITableView`
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            default:
                return
            }
    }
    
    // called when a row is moved
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    {
            // remove the dragged row's model
            let val = self.filteredGroups.removeAtIndex(sourceIndexPath.row)
            
            // insert it into the new position
            self.filteredGroups.insert(val, atIndex: destinationIndexPath.row)
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
