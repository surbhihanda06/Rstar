//
//  Home_UserVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/18/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
 import BRYXBanner

class Home_UserVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var btn_activity: UIButton!
    @IBOutlet var btn_search: UIButton!
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var search_Container: UIView!
    @IBOutlet var activity_Container: UIView!
    @IBOutlet var profile_Container: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        appDelegate.btn1_user = btnProfile
        print(btnProfile)
         print(appDelegate.btn1_user ?? "")
        appDelegate.btn2_user = btn_search
        appDelegate.btn3_user = btn_activity
        self.navigationController?.isNavigationBarHidden = true;
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

        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    
    @IBAction func Activity_Action(_ sender: Any)
    {
        

        profile_Container.isHidden = true
        activity_Container.isHidden = false
        search_Container.isHidden = true
        
    }
    @IBAction func Profile_Action(_ sender: Any) {
        profile_Container.isHidden = false
        activity_Container.isHidden = true
        search_Container.isHidden = true
    }
    @IBAction func Search_Action(_ sender: Any) {
        profile_Container.isHidden = true
        activity_Container.isHidden = true
        search_Container.isHidden = false
        
    }
}
