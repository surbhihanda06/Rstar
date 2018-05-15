//
//  Profile_VenueVC.swift
//  ROCKSTARS
//
//  Created by Amandeep Kaur on 5/23/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class Profile_VenueVC: UIViewController
{
    //MARK : - IBOutlets
    
    @IBOutlet var stackProfile: UIStackView!
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet var UsernameLbl: UILabel!
    @IBOutlet var lblVenueAddress: UILabel!
    @IBOutlet var lblVenue_Value: UILabel!
    @IBOutlet var lblMobile_Value: UILabel!
    @IBOutlet var lblEmail_Value: UILabel!
    @IBOutlet var lblUserName_Value: UILabel!
    @IBOutlet var lblPostcode_Value: UILabel!
    @IBOutlet weak var lblRockStarHired_Value: UILabel!
    
    //MARK: - Variables
    
    var editVC : UIViewController? = nil
    
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
        editVC = UIStoryboard(name: KMain, bundle: nil).instantiateViewController(withIdentifier: KEditProfileVenueVC) as! EditProfileVenueVC
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
        let param : [String:String] = ["user_id": UserDefaults.standard.value(forKey: KuserID) as! String]
        
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
    
    func Response(Resposnedic : [String:Any])
    {
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
            if Resposnedic[Kapi] as! String == kProfileURL {
                let  user : [String:Any] = Resposnedic[KUser] as! [String : Any]
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
                print(user[Klocation]!)
                Register_Data.sharedInstance.VenueAddress = "\(user[Klocation]!)"
                Register_Data.sharedInstance.lat = "\(user[Klatitude]!)"
                Register_Data.sharedInstance.lng = "\(user[Klongitude]!)"
		        //Register_Data.sharedInstance.bulidingNo = "\(user["building_number"]!)"
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
                if let location = user[Klocation]
                {
                  //  let building_no = user["building_number"]
                    let postcode = user["postcode"]
                    lblVenueAddress.text = "\(location)"
                }
                if let postcode = user[Kpostcode]
                {
                    lblPostcode_Value.text = postcode as? String
                }
                if let rstarHired = user[Krstarhired]
                {
                    print(rstarHired)
                    lblRockStarHired_Value.text = "\(user[Krstarhired]!)"
                }
                if let mobile : String = user[KMobile] as? String
                {
                    lblMobile_Value.text = self.setNumberFormat(number:mobile)
                    print(lblMobile_Value.text ?? "")
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
    
    func setNumberFormat(number:String)->String {
        print(number)
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
        return changedStr
    }
    
    // MARK: - IBaction
    
    @IBAction func MenuAction(_ sender: Any)
    {
        sideMenuViewController?._presentLeftMenuViewController()
    }
    
    @IBAction func EditProfile_Action(_ sender: Any)
    {
        self.navigationController?.pushViewController(editVC!, animated: true)
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
                        
                        self.Response(Resposnedic: responseJson)
                    }
				/************************///Aman
					else if  response.response?.statusCode == 401 {
						
						self.Response(Resposnedic: responseJson)
					}
			  /***************************/
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
