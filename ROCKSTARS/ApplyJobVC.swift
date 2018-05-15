//
//  ApplyJobVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/29/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD


class ApplyJobVC: UIViewController,ResponseProtcol {
    
  //MARK: - IBOutlets
    
    @IBOutlet var lbl_role: UILabel!
    @IBOutlet var lbl_location: UILabel!
    @IBOutlet var img_Venue: UIImageView!
    @IBOutlet var line_venue: UIView!
    @IBOutlet var txtFld_pay: UITextField!
	@IBOutlet var txtVw_descrption: UITextView!
	@IBOutlet var txtFld_PostCode: UITextField!
    @IBOutlet var txtFld_endTime: UITextField!
    @IBOutlet var txtFld_StartTime: UITextField!
    @IBOutlet var txtFld_MM: UITextField!
    @IBOutlet var txtFld_DD: UITextField!
    @IBOutlet var txtFld_YYYY: UITextField!
    
    //MARK: - Variables
    
    var dicJobDetail = [String:Any]()
    var JobskillArr = [[String:Any]]()
    var completeDateStr = String()

    
    @IBOutlet var txtFld_VenueName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dicJobDetail)
        if let jobDate = dicJobDetail[Kjob_date]
        {
            completeDateStr = jobDate as! String
            txtFld_StartTime.text = completeDateStr.MethodForStartTime()
            txtFld_MM.text = completeDateStr.MethodForMonth()
            txtFld_DD.text = completeDateStr.MethodForDay()
            print(completeDateStr)
        }
         txtFld_pay.text = "\(dicJobDetail["pay"]!)"
        txtVw_descrption.text = "\(dicJobDetail["description"]!)"
        txtFld_PostCode.text = "\(dicJobDetail["postcode"]!)"
       // txtFld_DD.text = "\(dicJobDetail["on_date"]!)".ChangeUTCDayToCurrent()
        txtFld_YYYY.text = "\(dicJobDetail["on_year"]!)".ChangeUTCYearToCurrent()
        txtFld_VenueName.text = "\(dicJobDetail["venue"]!)"
        let isDisplayVenue = "\(dicJobDetail["display_venue"]!)"
        if(isDisplayVenue == "0")
        {
            line_venue.isHidden = true
            txtFld_VenueName.isHidden = true
        }
        else
        {
            line_venue.isHidden = false
            txtFld_VenueName.isHidden = false
        }

        if let imageURL = dicJobDetail["image"]
        {
            if let url = URL.init(string: imageURL as! String) {
                img_Venue.setShowActivityIndicator(true)
                img_Venue.setIndicatorStyle(.gray)
                img_Venue.sd_setImage(with: url, placeholderImage: UIImage(named: "logo"))
                }
        }
        if let location = dicJobDetail["postcode"]
        {
        lbl_location.text = "\(location)"
        }
        JobskillArr = dicJobDetail[Kjob_roles] as! [[String : Any]]
        
        var selectedSkill_NameStr = ""
        
        for k in 0..<JobskillArr.count
        {
                let str = JobskillArr[k][Kskill_name] as! String
                print(selectedSkill_NameStr)
                if(selectedSkill_NameStr.characters.count == 0)
                {
                    selectedSkill_NameStr = "\(selectedSkill_NameStr)" + "\(str)"
                }
                else
                {
                    selectedSkill_NameStr = "\(selectedSkill_NameStr)" + "," + " " + "\(str)"
                  }
        }
        lbl_role.text = selectedSkill_NameStr
        
//        let formatter1 = DateFormatter()
//        formatter1.dateFormat = "MM"
//        let date = formatter1.date(from:"\(dicJobDetail["on_month"]!)")
//        let mnthStr = formatter1.string(from: date!)
//        txtFld_MM.text = mnthStr.ChangeUTCMonthToCurrent()
       
        let strTime = "\(dicJobDetail["start_time"]!)"
        print(strTime)
        
        let formatter2 = DateFormatter()
       // formatter2.dateFormat = "HH:mm:ss"
//        if let Start_time = formatter2.date(from:strTime)
//        {
//            print(Start_time)
//            let startTimeStr = formatter2.string(from: Start_time)
//              txtFld_StartTime.text = startTimeStr.ChangeUTCTimeToCurrent()
//        }
//        else
//        {
//            txtFld_StartTime.text = strTime.ChangeUTCTimeToCurrent()
//        }
          formatter2.dateFormat = "HH:mm:ss"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter2.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        
        if let end_time = formatter2.date(from:"\(dicJobDetail["finish_time"]!)"){
           let endTimeStr = formatter2.string(from: end_time)
            txtFld_endTime.text = endTimeStr.ChangeUTCTimeToCurrent()
        
        } else {
        
             txtFld_endTime.text = "\(dicJobDetail["finish_time"]!)".ChangeUTCTimeToCurrent()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool)
    {

    }
 
    //MARK:- Edit Profile API
    
    func ApplyJobAPI()
    {
         if Reach.isConnectedToNetwork() == true
        {
             let dict : [String:Any] = ["user_id":Register_Data.sharedInstance.userID,"job_id" :"\(dicJobDetail["job_id"]!)"]
               MBProgressHUD.showAdded(to: self.view, animated: true)
                ServerRequest.sharedInstance.delegate = self
            ServerRequest.sharedInstance.PostApi(urlStr: "applyJob", dict)
           }
        else
        {
              MBProgressHUD.hide(for: self.view, animated: true)
   CommonFunctions.sharedInstance.showAlert(message: "Internet connection lost.", delegate: self)
        }
    }
    
    //MARK: - Response Delegate
 
    func Response(Resposnedic : [String:Any])
    {
        MBProgressHUD.hide(for: self.view, animated: true)
        print(Resposnedic)
           var msg : String = Resposnedic["message"] as! String
		/***********************///Aman
		let status : Int  = Resposnedic[KStatus] as! Int
		if(status == 401)
		{
			CommonFunctions.sharedInstance.showAlert(message: msg, delegate: self)
		}
		/***********************/
		else
		{
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        { (action:UIAlertAction) in
            self.navigationController?.popViewController(animated: false)
        }
          alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
		}
    }
    
     func Failure()
    {
        MBProgressHUD.hide(for: self.view, animated: true)
          CommonFunctions.sharedInstance.showAlert(message: Ksomethingwentwrong, delegate: self)
        print(div)
    }

    
    //MARK: -  IBActions
    
    @IBAction func Apply_Action(_ sender: Any)
    {
        ApplyJobAPI()
    }
     @IBAction func BackAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
