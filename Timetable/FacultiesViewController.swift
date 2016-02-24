//
//  FacultiesViewController.swift
//  Timetable
//
//  Created by Sergey Rump (SPHERE) on 24.02.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
class FacultiesViewController : UIViewController , UITableViewDataSource , UITableViewDelegate
{
    var faculties=[Faculty]()
    @IBOutlet var tableView:UITableView!
    var selectedFac:Faculty?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate=self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"FAC")
        self.navigationItem.title="СПБПУ"
        faculties=TTDB.loadLocalFaculties({
            facs in
            self.faculties=facs
            dispatch_async(dispatch_get_main_queue(),{
                self.tableView.reloadData()
                self.tableView.setNeedsDisplay()
            })
        })        
    }
    override func viewDidAppear(animated:Bool)
    {
        self.navigationController?.setNavigationBarHidden(false,animated:animated)
        super.viewDidAppear(animated)
    }
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int)->Int
    {
        return faculties.count
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
        let cell = tableView.dequeueReusableCellWithIdentifier("FAC",forIndexPath:indexPath)
        let fac=faculties[groupIdx]
        cell.textLabel?.text = "\(fac.abbr)"
        cell.tintColor=tableView.tintColor
        cell.textLabel?.textColor=UIColor.whiteColor()
        cell.backgroundColor=tableView.backgroundColor
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let groupIdx=indexPath.row
        let fac=faculties[groupIdx]
        self.selectedFac=fac
        tableView.deselectRowAtIndexPath(indexPath,animated:true)
        self.performSegueWithIdentifier("showFaculty", sender:self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="showFaculty")
        {
            if let vc=segue.destinationViewController as?SearchViewController
            {
                vc.faculty=selectedFac
            }
        }
        super.prepareForSegue(segue,sender:sender)
    }
}