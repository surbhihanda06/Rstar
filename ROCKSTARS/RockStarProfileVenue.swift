//
//  RockStarProfileVenue.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 6/1/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire


class RockStarProfileVenue: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet var stackProfile: UIStackView!
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet var UsernameLbl: UILabel!
    @IBOutlet var lblVenue_Value: UILabel!
    @IBOutlet var lblMobile_Value: UILabel!
    @IBOutlet var lblEmail_Value: UILabel!
    @IBOutlet var lblUserName_Value: UILabel!
    @IBOutlet var lblPostcode_Value: UILabel!
    @IBOutlet weak var lblRockStarHired_Value: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        getVenueProfileDetailsAPI()
        
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        
        imgUser.layer.cornerRadius = imgUser.frame.size.width/2
        imgUser.clipsToBounds = true
        imgUser.layer.borderWidth = 0.0
        imgUser.layer.borderColor = UIColor.white.cgColor
    }
    
    //MARK:- Profile API
    
    func getVenueProfileDetailsAPI()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let param : [String:String] = [KuserID: UserDefaults.standard.value(forKey: KuserID) as! String]
        let url = kBaseUrl + kProfileURL
        if Reach.isConnectedToNetwork() == true
        {
            postMethod(urlStr: url, parameters: param)
        }
        else
        {
              MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
        }
        
    }
    
    //Response Delegate
    
    func Response(Responsedic : [String:Any])
    {
        print(Responsedic)
        MBProgressHUD.hide(for: self.view, animated: true)
		/***********************///Aman
		
		let status : Int  = Responsedic[KStatus] as! Int
		if(status == 401)
		{
			let msg: String = Responsedic["message"] as! String
			CommonFunctions.sharedInstance.showAlert(message: msg, delegate: self)
		}
		/***********************/
       else if Responsedic[KStatus] as! NSInteger == 200 {
            
            if Responsedic[Kapi] as! String == kProfileURL {
                
                let  user : [String:Any] = Responsedic[KUser] as! [String : Any]
                print(user)
                Register_Data.sharedInstance.name = user[KName] as! String
                Register_Data.sharedInstance.email = user[KEmail] as! String
                Register_Data.sharedInstance.mobileNumber = user[KMobile] as! String
                Register_Data.sharedInstance.imgUrl = user[KImage] as! String
                Register_Data.sharedInstance.rating_Time = "\(user[Kcocktail_knowledge]!)"
                Register_Data.sharedInstance.postcode = user[Kpostcode] as! String
                Register_Data.sharedInstance.rating_KeepSellin = "\(user[Kspirit_knowledge]!)"
                Register_Data.sharedInstance.rstarHired = "\(user[Krstarhired]!)"
                Register_Data.sharedInstance.venue = user[Kvenue] as! String
                Register_Data.sharedInstance.userID = "\(user[KuserID]!)"
                Register_Data.sharedInstance.roleType = "\(user[Krole_type]!)"
                
                if let  userName = user[KName]
                {
                    lblUserName_Value.text = userName as? String
                    UsernameLbl.text = userName as? String
                }
                if let email = user[KEmail]
                {
                    lblEmail_Value.text = email as? String
                }
                if let venue = user[Kvenue]
                {
                    lblVenue_Value.text = venue as? String
                }
                if let postcode = user[Kpostcode]
                {
                    lblPostcode_Value.text = postcode as? String
                }
                if let rstarHired = user[Krstarhired]
                {
                    lblRockStarHired_Value.text = "\(rstarHired)"
                }
                if let mobile = user[KMobile]
                {
                    lblMobile_Value.text = mobile as? String
                }
                if let imageURL = user[KImage]
                {
                    if let url = URL.init(string: imageURL as! String) {
                        imgUser.setShowActivityIndicator(true)
                        imgUser.setIndicatorStyle(.gray)
                        imgBackground.sd_setImage(with: url, placeholderImage: UIImage(named: Kimg))
                        imgUser.sd_setImage(with: url, placeholderImage: UIImage(named: Kimg))
                    }
                }
            }
            else{
                print("Failure")
            }
        }
    }
    
    func Failure()
    {
        MBProgressHUD.hide(for: self.view, animated: true)
        CommonFunctions.sharedInstance.showAlert(message: Ksomethingwentwrong, delegate: self)
        print("Failure")
    }
    
    // MARK: - IBaction
    
    @IBAction func MenuAction(_ sender: Any)
    {
        sideMenuViewController?._presentLeftMenuViewController()
    }
    
    @IBAction func EditProfile_Action(_ sender: Any)
    {
        let editVC = UIStoryboard(name: KMain, bundle: nil).instantiateViewController(withIdentifier: KEditProfileVenueVC) as! EditProfileVenueVC
        print(self.navigationController ?? "")
        self.navigationController?.pushViewController(editVC, animated: true)
        
    }
    
    //MARK:- Post Method
    
    func postMethod(urlStr : String,parameters : [String:Any]){
        
        if Reachability.isConnectedToNetwork() {
            
            Alamofire.request(urlStr, method : .post, parameters : parameters).responseJSON(completionHandler: {
                response in
                print(response.result)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    let responseJson = JSON as! [String: Any]
                    if response.response?.statusCode == 200 {
                        
                        self.Response(Responsedic: responseJson)
                    }
				/***************************///Aman
					else if response.response?.statusCode == 401 {
						
						self.Response(Responsedic: responseJson)
					}
				/****************************/
                    else{
                        self.Failure()
                    }
                } else {
                    self.Failure()
                }
            }) } else
        {
              MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
        }    }
}
