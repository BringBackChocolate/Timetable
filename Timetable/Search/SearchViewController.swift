//
//  SearchViewController.swift
//  Timetable
//
//  Created by Sergey Rump on 24.02.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
class UITableViewCellWithIcon:UITableViewCell
{
    var iconView:UIImageView?
}
class SearchViewController : TimetableVC , UITableViewDataSource , UITableViewDelegate, UISearchBarDelegate
{
    var groups=[Group]()
    var filteredGroups=[Group]()
    var faculty:Faculty?
    @IBOutlet var tableView:UITableView!
    @IBOutlet var searchBar:UISearchBar!
    var selectedGroup:Group?
    override func viewDidLoad()
    {
        self.tableView.registerClass(UITableViewCellWithIcon.self, forCellReuseIdentifier:"GROUP")
        super.viewDidLoad()
        tableView.delegate=self
        if(faculty==nil){return}
        self.navigationItem.title=faculty!.abbr
        groups=TTDB.loadLocalFaculty(faculty!.id, onWeb: {
            gs in
            self.groups=gs
            self.groups.sortInPlace({$0.name < $1.name})
            dispatch_async(dispatch_get_main_queue(),{
                self.tableView.reloadData()
                self.tableView.setNeedsDisplay()
            })
        })
        self.groups.sortInPlace({$0.name < $1.name})
        self.filteredGroups=groups        
    }
    override func viewDidAppear(animated:Bool)
    {
        self.navigationController?.setNavigationBarHidden(false,animated:animated)
        super.viewDidAppear(animated)
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
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let groupIdx=indexPath.row
        let cell = tableView.dequeueReusableCellWithIdentifier("GROUP",forIndexPath:indexPath) as!UITableViewCellWithIcon
        let group=filteredGroups[groupIdx]
        cell.textLabel?.text = "\(group.name)"
        cell.tintColor=tableView.tintColor
        cell.textLabel?.textColor=UIColor.whiteColor()
        cell.backgroundColor=tableView.backgroundColor
        if(TTDB.groupIsFav(group))
        {
            if(cell.iconView==nil)
            {
                if let img=UIImage(named:"Bookmark-Filled")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                {
                    let imgView=UIImageView(image:img)
                    imgView.tintColor=UIColor.whiteColor()
                    cell.addSubview(imgView)
                    let views = ["imgView": imgView]
                    let hConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:[imgView]-10-|",
                                    options: NSLayoutFormatOptions.AlignAllCenterY,metrics:nil,views:views)
                    cell.addConstraint(hConstraint[0])
                    imgView.frame=CGRectMake(cell.frame.width-img.size.width-10,5,
                        img.size.width,img.size.height)
                    cell.iconView=imgView
                }
            }
        }
        else
        {
            cell.iconView?.removeFromSuperview()
            cell.iconView=nil
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let groupIdx=indexPath.row
        let group=filteredGroups[groupIdx]
        self.selectedGroup=group
        tableView.deselectRowAtIndexPath(indexPath,animated:true)
        self.performSegueWithIdentifier("showTimetable", sender:self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
    func filterContentForSearchText(searchText: String) {
        if searchText == "" {
            filteredGroups=groups
            return
        }
        filteredGroups = groups.filter { group in
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
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}