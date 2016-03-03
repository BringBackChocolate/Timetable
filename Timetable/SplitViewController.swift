//
//  SplitViewController.swift
//  Timetable
//
//  Created by Sergey Rump (SPHERE) on 03.03.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
class SplitViewController:UISplitViewController
{
    var splashView:CBZSplashView?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        animateAppear()
    }
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        if(animated)
        {
            animateAppear()
        }
    }
    func animateAppear()
    {
        if(splashView != nil){return}
        if let img=UIImage(named:"PolyMask")//?.scaleToSize(CGSizeMake(100,100))
        {            
            let color=UIColor.polytechColor()
            splashView=CBZSplashView(icon:img,backgroundColor:color)
            if let sw=splashView
            {
                sw.animationDuration=1
                self.view.addSubview(sw)
            }
        }
    }
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        splashView?.startAnimationWithCompletionHandler({})
    }
}