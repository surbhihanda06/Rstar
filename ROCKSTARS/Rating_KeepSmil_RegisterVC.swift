//
//  Rating_KeepSmil_RegisterVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/11/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit

class Rating_KeepSmil_RegisterVC: UIViewController {
    
    //MARK : - IBOtlets
    
    @IBOutlet weak var btnOneMoreStep: UIButton!
    @IBOutlet var lblText2: UILabel!
    @IBOutlet var lblText1: UILabel!
    @IBOutlet var lblAdvance_top: NSLayoutConstraint!
    @IBOutlet var slider_Rating: NapySlider!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK : - Variables
    
    var strEditing = String()
    
    override func viewDidLoad()
    {
        UserDefaults.standard.set(true, forKey: KRatingChange1)
        super.viewDidLoad()
        if strEditing == kEdit {
            
            lblTitle.text = KEDITPROFILE
        }
        else
        {
            lblTitle.text = KREGISTER
        }
        btnOneMoreStep.layer.masksToBounds = false
        btnOneMoreStep.layer.cornerRadius = 2.0
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if(UserDefaults.standard.bool(forKey: KRatingChange1) == true)
        {
            UserDefaults.standard.set(false, forKey: KRatingChange1)
            let top : CGFloat = slider_Rating.frame.height/4
            lblAdvance_top.constant = top
            slider_Rating.min = 0
            slider_Rating.max = 4
            slider_Rating.step = 1
            if(strEditing == kEdit)
            {
                slider_Rating.handlePosition = (Register_Data.sharedInstance.rating_KeepSellin as AnyObject).doubleValue
            }
            else
            {
                slider_Rating.handlePosition = 0
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        UserDefaults.standard.set(false, forKey: KIsTimeRating)
        NotificationCenter.default.addObserver(self, selector: #selector(RateValue), name: NSNotification.Name(rawValue: KRating_Sellin), object: nil)
    }
    
    //MARK:- Other Methods
    
    func RateValue()
    {
        let rating :Int = Int(slider_Rating.handlePosition)
        Register_Data.sharedInstance.rating_KeepSellin = "\(rating)"
        
        if(rating == 0)
        {
            lblText1.text = KNone
            lblText2.text = KIllsticktobeerthanks
        }
        else if(rating == 1)
        {
            lblText1.text = KBEGINNER
            lblText2.text = KVodkaLimeSodaSlinger
        }
        else if(rating == 2)
        {
            lblText1.text = KMEDIUM
            lblText2.text = KCandifferentiatefirstpoursfromtopshelf
        }
        else if(rating == 3)
        {
            lblText1.text = KADVANCED
            lblText2.text = KIcanrecommendspiritsknowthetopshelfwell
        }
        else if(rating == 4)
        {
            lblText1.text = KEXPERT
            lblText2.text = KIcanidentifyhowlongawhiskeywasfermentedbasedonthefartofsomeonewhodrankit
        }
        else
        {
            lblText1.text = KEXPERT
            lblText2.text = KIcanidentifyhowlongawhiskeywasfermentedbasedonthefartofsomeonewhodrankit
        }
        print( slider_Rating.handlePosition)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- IBActions
    
    @IBAction func OneMoreAction(_ sender: Any)
    {
        let skills_RegisterVC =  UIStoryboard(name: KMain, bundle: nil).instantiateViewController(withIdentifier: KSkills_RegisterVC) as! Skills_RegisterVC
        if strEditing == kEdit
        {
            skills_RegisterVC.strEdit = kEdit
        }
        
        self.navigationController?.pushViewController(skills_RegisterVC, animated: true)
    }
    @IBAction func Back_Action(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
