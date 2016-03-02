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
    //string constants
    let kEditButtonName:String = "Изменить"
    let kDoneButtonName:String = "Готово"
    let kCancelButtonName:String = "Отменить"
    let kChangeEditingModeSelectorName = "changeEditingMode:"
    let kCancelSearchSelectorName = "cancelSearch:"
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet var searchBar:UISearchBar!
    
    var selectedGroup:Group?
    var groups = [Group]()
    var filteredGroups = [Group]()
    
    //== View delegates
    
    override func viewDidLoad()
    {
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"GROUP")
        self.tableView.backgroundColor = UIColor.polytechColor()
        super.viewDidLoad()
        self.navigationItem.title="Избранное"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: kEditButtonName, style: .Plain, target: self, action: Selector(self.kChangeEditingModeSelectorName))
        tableView.delegate=self
        self.groups = Array(TTDB.bookmarks)
        dispatch_async(dispatch_get_main_queue(),{
            TTDB.loadBookmarks()            
            self.filteredGroups = self.groups
            self.tableView.reloadData()
            self.tableView.setNeedsDisplay()
        })
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
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //== Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier=="showTimetable")
        {
            if let nvc=segue.destinationViewController as?UINavigationController
            {
                if let vc=nvc.viewControllers.first as?CalendarViewController
                {
                    vc.group=selectedGroup
                }
            }            
        }
        super.prepareForSegue(segue,sender:sender)
    }
    
    //== Helpers
    
    func allowEnterEditMode(sender: UIBarButtonItem)
    {
        self.tableView.editing = false
        sender.style = .Plain
        sender.title = self.kEditButtonName
        sender.action = Selector(self.kChangeEditingModeSelectorName)
    }
    
    func changeEditingMode(sender: UIBarButtonItem)
    {
        if(self.tableView.editing)
        {
            self.tableView.setEditing(false, animated: true)
            sender.style = .Plain
            sender.title = self.kEditButtonName
        }
        else
        {
            self.tableView.setEditing(true, animated: true)
            sender.style = .Done
            sender.title = self.kDoneButtonName
        }
    }
    
    //== Table view delegates
    
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
            switch editingStyle {
            case .Delete:
                // remove the deleted item from the model
                let groupToRemove =  self.filteredGroups.removeAtIndex(indexPath.row)
                
                // remove the deleted item from the `UITableView`
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
                TTDB.removeBookmark(groupToRemove)
                self.groups = TTDB.bookmarks
                
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
        TTDB.bookmarks = filteredGroups
        TTDB.saveBookmarks()
    }
    
    //== Search delegates
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)   //user taps on search text field
    {
        //if we performing editing in the moment, cancel editing
        if(self.tableView.editing)
        {
            changeEditingMode(self.navigationItem.rightBarButtonItem!)
        }
        
        //top right button is cancel button now
        self.navigationItem.rightBarButtonItem?.title = self.kCancelButtonName
        self.navigationItem.rightBarButtonItem?.action = Selector(self.kCancelSearchSelectorName)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        filterContentForSearchText(searchText)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar)
    {
        filterContentForSearchText(searchBar.text!)
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //== Search Helpers
    
    func filterContentForSearchText(searchText: String)
    {
        if searchText == ""
        {
            if(self.filteredGroups.count != self.groups.count)
            {
                self.filteredGroups = self.groups
            }
            else
            {
                //do not reload table view if nothing to update
                return
            }
        }
        else
        {
            self.filteredGroups = groups.filter { group in
                return group.name.containsString(searchText)
            }

        }
        tableView.reloadData()
        self.tableView.setNeedsDisplay()
    }
    
    func cancelSearch(sender: UIBarButtonItem)
    {
        //clear search request
        self.searchBar.text = ""
        
        //display all groups
        self.filteredGroups = self.groups
        tableView.reloadData()
        self.tableView.setNeedsDisplay()
        
        //disable searching mode
        self.searchBar.endEditing(true)
        
        //change top right button
        allowEnterEditMode(sender)
    }
}
