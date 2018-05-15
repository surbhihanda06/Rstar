//
//  Rating_RegisterVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/8/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit

class Rating_RegisterVC: UIViewController
{
   // MARK: - IBOtlets
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAlmostDone: UIButton!
    @IBOutlet weak var lblText2: UILabel!
    @IBOutlet var lblText1: UILabel!
    @IBOutlet var lblAdvance_top: NSLayoutConstraint!
    @IBOutlet var slider_Rating: NapySlider!
    
    // MARK: - Variables
    
     var strEdit = String()
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if strEdit == kEdit {
            
            lblTitle.text = KEDITPROFILE
        }
        else
        {
            lblTitle.text = KREGISTER
        }
        UserDefaults.standard.set(true, forKey: KRatingChange)
        btnAlmostDone.layer.masksToBounds = false
        btnAlmostDone.layer.cornerRadius = 2.0
       }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if(UserDefaults.standard.bool(forKey: KRatingChange) == true)
        {
              UserDefaults.standard.set(false, forKey: KRatingChange)
            let top : CGFloat = slider_Rating.frame.height/4
               lblAdvance_top.constant = top
                   slider_Rating.min = 0
            slider_Rating.max = 4
            slider_Rating.step = 1
            
            if(strEdit == kEdit)
            {
                //let string = NSString(string: Register_Data.sharedInstance.rating_Time)
                slider_Rating.handlePosition = (Register_Data.sharedInstance.rating_Time as AnyObject).doubleValue
            }
            else
            {
                slider_Rating.handlePosition = 0
            }
             }
          }
    
    override func viewWillAppear(_ animated: Bool)
    {
            UserDefaults.standard.set(true, forKey: KIsTimeRating)
             NotificationCenter.default.addObserver(self, selector: #selector(RateValue), name: NSNotification.Name(rawValue: KRating), object: nil)
      }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func RateValue()
    {
         let rating :Int = Int(slider_Rating.handlePosition)
          Register_Data.sharedInstance.rating_Time = "\(rating)"
          if(rating == 0)
        {
                 lblText1.text = KNone
         lblText2.text = KWhatsAcocktail
           }
        else if(rating == 1)
        {
            lblText1.text = KBEGINNER
              lblText2.text = KICanMakeTheVeryBasicsLongIslandIceTeasForDays
         }
        else if(rating == 2)
        {
            lblText1.text = KMEDIUM
            lblText2.text = KGotAllTheBasicsDown
        }
        else if(rating == 3)
        {
            lblText1.text = KADVANCED
              lblText2.text = KIMACockTailBartender
        }
        else if(rating == 4)
        {
            lblText1.text = KEXPERT
                 lblText2.text = KIfCockTailsWere
        }
        else
        {
                lblText1.text = KEXPERT
          lblText2.text = KIfCockTailsWere
           }
       print( slider_Rating.handlePosition)
     }
  
    @IBAction func OneMore_Action(_ sender: Any)
    {
             let rating_KeepSmil_RegisterVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: KRating_KeepSmil_RegisterVC) as! Rating_KeepSmil_RegisterVC
        if strEdit == "Edit"
        {
            rating_KeepSmil_RegisterVC.strEditing = kEdit
        }
        self.navigationController?.pushViewController(rating_KeepSmil_RegisterVC, animated: true)
    }
    @IBAction func Back_Action(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
 }

