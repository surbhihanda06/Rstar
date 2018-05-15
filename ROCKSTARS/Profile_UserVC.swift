//
//  Profile_UserVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/18/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD

class Profile_UserVC: UIViewController,ResponseProtcol
{
    //MARK : - IBOutlets
    
    @IBOutlet var stackEditProfile: UIStackView!
    @IBOutlet var stackProfile: UIStackView!
    @IBOutlet var UsernameLbl: UILabel!
    @IBOutlet var btnEditProfile: UIButton!
    @IBOutlet var txtFld_Dob: UITextField!
    @IBOutlet var txtFld_Mobile: UITextField!
    @IBOutlet var txtFld_Email: UITextField!
    @IBOutlet var txtFld_UserName: UITextField!
    @IBOutlet var lblRating_Value: UILabel!
    @IBOutlet var lblShift_Str: UILabel!
    @IBOutlet var lblShift_value: UILabel!
    @IBOutlet var viewRating: FloatRatingView!
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet var lblDob_Value: UILabel!
    @IBOutlet var lblDob: UILabel!
    @IBOutlet var lblMobile_Value: UILabel!
    @IBOutlet var lblMobile: UILabel!
    @IBOutlet var lblEmail_Value: UILabel!
    @IBOutlet var lblEmail: UILabel!
    
    //MARK : - Variables
    
    var editVC : UIViewController? = nil
    var IsEdit = Bool()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        lblRating_Value.isHidden = true
        // IsEdit = true
       // stackEditProfile.isHidden = true
        self.navigationController?.isNavigationBarHidden = true;
      //  imgUser.layer.cornerRadius = imgUser.frame.size.width / 2
      //  imgUser.clipsToBounds = true
      //  imgUser.layer.borderWidth = 0.0
    //    imgUser.layer.borderColor = UIColor.white.cgColor
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        getProfileDetailsAPI()
        editVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterEditVC") as! RegisterEditVC
    }
    override func viewDidAppear(_ animated: Bool)
    {
        imgUser.layer.cornerRadius = imgUser.frame.size.width/2
        imgUser.clipsToBounds = true
    }
    
    // MARK: - Api Methods
    
    func setRating(value:Float)
    {
        self.viewRating.contentMode = UIViewContentMode.scaleAspectFit
        self.viewRating.rating = value
        self.viewRating.editable = false
        self.viewRating.halfRatings = false
        self.viewRating.floatRatings = true
    }
    
    //MARK:- Profile API
    
    func getProfileDetailsAPI()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let param : [String:String] = [KuserID:UserDefaults.standard.value(forKey: KuserID) as! String]
        releasePrint(param)
        let obj = ServerRequest()
        obj.delegate = self
        let url = kBaseUrl + kProfileURL
        if Reach.isConnectedToNetwork() == true
        {
             obj.postMethod(urlStr: url, parameters: param)
        }
           else
        {
              MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
        }
       
    }
    
    //MARK: - Response Delegate
    
    func Response(Resposnedic : [String:Any]) {
        MBProgressHUD.hide(for: self.view, animated: true)
		/***********************///Aman
		
		let status : Int  = Resposnedic[KStatus] as! Int
		if(status == 401)
		{
			let msg: String = Resposnedic["message"] as! String
			CommonFunctions.sharedInstance.showAlert(message: msg, delegate: self)
		}
		/***********************/
       else if Resposnedic["status"] as! NSInteger == 200 {
            
            if Resposnedic["api"] as! String == kProfileURL {
                    let  user : [String:Any] = Resposnedic[KUser] as! [String : Any]
                print(user)
                Register_Data.sharedInstance.name = user["name"] as! String
                Register_Data.sharedInstance.email = user["email"] as! String
                Register_Data.sharedInstance.mobileNumber = user["mobile"] as! String
                print(user)
                if let dob =  user["dob"]
                {
                    Register_Data.sharedInstance.dob = ("\(dob)" == "<null>") ? "Not Available"  : "\(dob)"
                    print(Register_Data.sharedInstance.dob)
                }
                else
                {
                     Register_Data.sharedInstance.dob = "Not Available"
                }
                if let about_me =  user["about_me"]
                {
                     Register_Data.sharedInstance.aboutMe = ("\(about_me)" == "<null>") ? "Not Available"  : "\(about_me)"
                }
                else
                {
                     Register_Data.sharedInstance.aboutMe = "Not Available"
                }
                Register_Data.sharedInstance.imgUrl = user["image"] as! String
                Register_Data.sharedInstance.rating_Time = "\(user["cocktail_knowledge"]!)"
                Register_Data.sharedInstance.arrSkills = user["skills"] as! Array
                Register_Data.sharedInstance.rating_KeepSellin = "\(user["spirit_knowledge"]!)"
                Register_Data.sharedInstance.userID = "\(user["user_id"]!)"
                Register_Data.sharedInstance.roleType = "\(user["role_type"]!)"
                
                if let  userName = user[KName]
                {
                    UsernameLbl.text = userName as? String
                }
                if let email = user[KEmail]
                {
                    lblEmail_Value.text = email as? String
                }
                if let mobile = user[KMobile]
                {
                    lblMobile_Value.text = self.setNumberFormat(number:(mobile as? String)!)
                }
                if let shift = user[Kshifts]
                {
                    let value = "\(shift)"
                    lblShift_value.text = value
                }
                else{
                    lblShift_value.text = "0"
                }
                if let dob = user[KDob]
                {
                    lblDob_Value.text = dob as? String
                    print(lblDob_Value.text ?? "")
                }
                if let imageURL = user[KImage]
                {
                    if let url = URL.init(string: imageURL as! String) {
                        imgUser.setShowActivityIndicator(true)
                        imgUser.setIndicatorStyle(.gray)
                        
                        imgUser.sd_setImage(with: url, placeholderImage: UIImage(named: "img"))
                        imgBackground.sd_setImage(with: url, placeholderImage: UIImage(named: "img"))                    }
                }
                if let rating = user["rating"]
                {
                    setRating(value:Float.init("\(rating)")!)
                }
            }
            else
            {
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
    
    
    func setNumberFormat(number:String)->String {
        let str : String = number
        let startIndexes = [0,3,6]
        let endIndexes = [-7,-4,0]
        var changedStr = ""
        for i in 0...startIndexes.count-1 {
            
            let start = str.index(str.startIndex, offsetBy: startIndexes[i])
            let end = str.index(str.endIndex, offsetBy: endIndexes[i])
            let range = start..<end
            
            let tempStr = str[range]
            
            if(i == 0){
                changedStr.append("\(tempStr)")
            }
            else{
                changedStr.append("-\(tempStr)")
            }
        }
        print(changedStr)
        return changedStr
    }
    
    // MARK: - IBAction
    
    @IBAction func WhatAreLive_Action(_ sender: Any)
    {
        let tutorialVC = UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        self.navigationController?.pushViewController(tutorialVC, animated: true)
    }
    
    @IBAction func MenuAction(_ sender: Any)
    {
        sideMenuViewController?._presentLeftMenuViewController()
    }
    
    @IBAction func EditProfile_Action(_ sender: Any)
    {
        
        self.navigationController?.pushViewController(editVC!, animated: true)
    }
}
