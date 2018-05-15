//
//  Home_VenueVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/25/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Crashlytics


class Home_VenueVC: UIViewController
{
    
    //MARK:- IBOutLets
    
    @IBOutlet var search_Container: UIView!
    @IBOutlet var activity_Container: UIView!
    @IBOutlet var profile_Container: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = false
         // UserDefaults.standard.set(true, forKey: "IsDirectProfile")
        if (UserDefaults.standard.bool(forKey: "IsDirectProfile"))
        {
        profile_Container.isHidden = false
        activity_Container.isHidden = true
        search_Container.isHidden = true
        }
        else
        {
            profile_Container.isHidden = true
            activity_Container.isHidden = true
            search_Container.isHidden = false
        
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - IBActions
    
    @IBAction func Activity_Action(_ sender: Any)
    {
        // Crashlytics.sharedInstance().crash()
        profile_Container.isHidden = true
        activity_Container.isHidden = false
        search_Container.isHidden = true
    }
    @IBAction func Search_Action(_ sender: Any)
    {
        profile_Container.isHidden = true
        activity_Container.isHidden = true
        search_Container.isHidden = false
        
    }
    @IBAction func profile_Action(_ sender: Any)
    {
        profile_Container.isHidden = false
        activity_Container.isHidden = true
        search_Container.isHidden = true
    }
    
}
