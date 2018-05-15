//
//  RatingViewController.swift
//  ROCKSTARS
//
//  Created by Amandeep Kaur on 6/14/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD

class RatingViewController: UIViewController,ResponseProtcol
{
    //MARK: - IBOutlets
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet var lblRate: UILabel!
    
    //MARK: - Variables
    
    var strRating = String()
    var DataDic = [String: Any]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let dic = DataDic[Kjob_data] as! [String : Any]
        lblRate.text = KRateSpace + "\(dic[KName]!)" + Ksperformance
      }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Other methods
    
    @IBAction func BtnLowAction(_ sender: Any)
    {
        print(DataDic)
        strRating = "0"
        RatingApi(rate: strRating)
    }
    
    @IBAction func BtnMediumAction(_ sender: Any) {
        strRating = "1"
        RatingApi(rate: strRating)
    }
    
    @IBAction func BtnHighAction(_ sender: Any) {
        strRating = "2"
        RatingApi(rate: strRating)
    }
    
    //MARK:- Edit Profile API
    
    func RatingApi(rate:String)
    {
        if Reach.isConnectedToNetwork() == true
        {
            let Data = DataDic[Kjob_data] as! [String : Any]
            let dict : [String:Any] = [KvenueUndrScid:Register_Data.sharedInstance.userID,Kjobid :"\(Data[Kjobid]!)",Krate :rate,KuserID:(Data[KuserID]!)]
            print(dict)
             MBProgressHUD.showAdded(to: self.view, animated: true)
            ServerRequest.sharedInstance.delegate = self
            ServerRequest.sharedInstance.PostApi(urlStr: Krating, dict)
        }
        else
        {
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
       else if Resposnedic[KStatus] as! NSInteger == 200
        {
            if Resposnedic[Kapi] as! String == Krating
            {
                let msg = Resposnedic[KMessage] as! String
                CommonFunctions.sharedInstance.showAlert(message: msg, delegate: self)
                KappDelegate.RemoveRatingView()
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
    
}
