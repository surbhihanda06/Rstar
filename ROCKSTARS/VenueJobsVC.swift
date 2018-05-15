//
//  VenueJobsVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/25/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import MBProgressHUD


class VenueJobsVC: UIViewController,ResponseProtcol {
    
    //MARK:- IBOutlets
    
    @IBOutlet var container_Active: UIView!
    @IBOutlet var container_Advertise: UIView!
    @IBOutlet var ratingView: UIView!
    @IBOutlet var btnAdevertise: UIButton!
    @IBOutlet var btnActive: UIButton!
    @IBOutlet var activeUnderlineVw: UIView!
    @IBOutlet var advertiseUndelineVw: UIView!
    @IBOutlet var rockStar_Name: UILabel!
    
    //MARK: - Variables
    var historyArr = [[String:Any]]()
    var UserhistoryDic = [String:Any]()
    
    override func viewDidLoad() {
        ratingView.isHidden = true
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = false
        let notificationName = Notification.Name(KPostSuccess)
        
        NotificationCenter.default.addObserver(self, selector: #selector(Active_Action), name: notificationName, object: nil)
        
        let notificationName1 = Notification.Name(KShowRating)
        NotificationCenter.default.addObserver(self, selector: #selector(ShowRatingView), name: notificationName1, object: nil)
        
        container_Active.isHidden = true
        container_Advertise.isHidden = false
        
        btnActive.setImage(UIImage.init(named: KCheckGray), for: .normal)
        btnAdevertise.setImage(UIImage.init(named: KSpeaker), for: .normal)
        activeUnderlineVw.isHidden=true
        advertiseUndelineVw.isHidden=false
        advertiseUndelineVw.backgroundColor = UIColor.init(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        activeUnderlineVw.backgroundColor = UIColor.lightGray
        btnAdevertise .setTitleColor(UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0), for: UIControlState.normal)
        btnActive .setTitleColor(UIColor.darkGray, for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Other Methods
    
    func ShowRatingView()
    {
        historyArr = User.sharedInstance.arrJobHistory
        print(historyArr)
        
        for k in 0..<historyArr.count
        {
            if  let ratingValue = historyArr[k][Krating]
            {
                let rating = "\(ratingValue)"
                
                if(rating == "0")
                {
                    UserhistoryDic = historyArr[k] as [String:Any]
                    UserhistoryDic[Krating] = "1"
                    historyArr[k] = UserhistoryDic
                    User.sharedInstance.arrJobHistory = historyArr
                    rockStar_Name.text = KRateSpace + "\(UserhistoryDic[KName]!)" + Ksperformance
                    ratingView.isHidden = false
                    // Rate Adrian's
                    return
                }
                
            }
        }
    }
    
    //MARK:- Edit Profile API
    
    func RatingApi(rate:String)
    {
        if Reach.isConnectedToNetwork() == true
        {
            let dict : [String:Any] = [KvenueUndrScid:Register_Data.sharedInstance.userID,Kjobid :"\(UserhistoryDic[Kjobid]!)",Krate :rate,KuserID:(UserhistoryDic[KuserID]!)]
            print(dict)
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            ServerRequest.sharedInstance.delegate = self
            ServerRequest.sharedInstance.PostApi(urlStr: "rating", dict)
        }
        else
        {
              MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
        }
    }
    
    //Response Delegate
    
    func Response(Resposnedic : [String:Any]) {
        print(Resposnedic)
        MBProgressHUD.hide(for: self.view, animated: true)
		/***********************///Aman
		
		let status : Int  = Resposnedic[KStatus] as! Int
		if(status == 401)
		{
			let msg: String = Resposnedic["message"] as! String
			CommonFunctions.sharedInstance.showAlert(message: msg, delegate: self)
		}
		/***********************/
        else if Resposnedic[KStatus] as! NSInteger == 200 {
            if Resposnedic[Kapi] as! String == Krating
            {
                let msg = Resposnedic[KMessage] as! String
                CommonFunctions.sharedInstance.showAlert(message: msg, delegate: self)
                ratingView.isHidden = true
                ShowRatingView()
            }
            else{
                
                print(KFailure)
            }
        }
    }
    
    func Failure()
    {
        MBProgressHUD.hide(for: self.view, animated: true)
        CommonFunctions.sharedInstance.showAlert(message: Ksomethingwentwrong, delegate: self)
        print(KFailure)
    }
    
    //MARK: - IBACTIONS
    
    @IBAction func RateHigh_Avtion(_ sender: Any)
    {
        print(UserhistoryDic)
        RatingApi(rate: "2")
    }
    
    @IBAction func RateLow_Action(_ sender: Any)
    {
        print(UserhistoryDic)
        RatingApi(rate: "0")
    }
    
    @IBAction func RateMedium_Action(_ sender: Any)
    {
        print(UserhistoryDic)
        RatingApi(rate: "1")
    }
    
    @IBAction func Active_Action(_ sender: Any) {
        self.view.endEditing(true)
        container_Active.isHidden = false
        container_Advertise.isHidden = true
        activeUnderlineVw.backgroundColor = UIColor.init(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        advertiseUndelineVw.backgroundColor = UIColor.lightGray
        btnActive.setImage(UIImage.init(named: KCheck), for: .normal)
        btnAdevertise.setImage(UIImage.init(named: KSpeakerGray), for: .normal)
        activeUnderlineVw.isHidden=false
        advertiseUndelineVw.isHidden=true
        btnActive .setTitleColor(UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0), for: UIControlState.normal)
        btnAdevertise .setTitleColor(UIColor.darkGray, for: UIControlState.normal)
    }
    
    @IBAction func Advertise_Action(_ sender: Any) {
        self.view.endEditing(true)
        container_Active.isHidden = true
        container_Advertise.isHidden = false
        advertiseUndelineVw.backgroundColor = UIColor.init(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        activeUnderlineVw.backgroundColor = UIColor.lightGray
        
        btnActive.setImage(UIImage.init(named: KCheckGray), for: .normal)
        btnAdevertise.setImage(UIImage.init(named: KSpeaker), for: .normal)
        activeUnderlineVw.isHidden=true
        advertiseUndelineVw.isHidden=false
        btnAdevertise .setTitleColor(UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0), for: UIControlState.normal)
        btnActive .setTitleColor(UIColor.darkGray, for: UIControlState.normal)
    }
    
}
