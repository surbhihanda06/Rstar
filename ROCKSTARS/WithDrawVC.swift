//
//  WithDrawVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 6/14/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD

class WithDrawVC: UIViewController,ResponseProtcol {
    //MARK: - IBOutlets
    @IBOutlet var lbl_role: UILabel!
    @IBOutlet var lbl_location: UILabel!
    @IBOutlet var img_Venue: UIImageView!
    @IBOutlet var line_venue: UIView!
    @IBOutlet var scrollView_jobTypes: UIScrollView!
    @IBOutlet var scrollViewHeight_Jobs: NSLayoutConstraint!
    @IBOutlet var txtFld_pay: UITextField!
    @IBOutlet var txtFld_descrption: UITextField!
    @IBOutlet var txtFld_PostCode: UITextField!
    @IBOutlet var txtFld_endTime: UITextField!
    @IBOutlet var txtFld_StartTime: UITextField!
    @IBOutlet var txtFld_MM: UITextField!
    @IBOutlet var txtFld_DD: UITextField!
    @IBOutlet var txtFld_YYYY: UITextField!
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
        txtFld_descrption.text = "\(dicJobDetail["description"]!)"
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
        
//        let strTime = "\(dicJobDetail["start_time"]!)"
//        print(strTime)
        
        let formatter2 = DateFormatter()
//        formatter2.dateFormat = "HH:mm:ss"
//        if let Start_time = formatter2.date(from:strTime)
//        {
//            print(Start_time)
//            let startTimeStr = formatter2.string(from: Start_time)
//            txtFld_StartTime.text = startTimeStr.ChangeUTCTimeToCurrent()
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
        print(JobskillArr)
        print(dicJobDetail)
        CreateJobSkillView(JobskillArr:JobskillArr )
    }
    
    
    func CreateJobSkillView(JobskillArr:[[String : Any]])
    {
      /*  print(JobskillArr)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        var scrollViewHeight : CGFloat = 0
        // var scrollView : CGFloat = 0
        var leadingParent = scrollView_jobTypes.leadingAnchor
        var topParent = scrollView_jobTypes.topAnchor
        scrollViewHeight = scrollViewHeight + 25.0 + 10.0
        var z = 0
        for i in 0..<JobskillArr.count
        {
            z += 1
            let view = UIView()
            view.backgroundColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
            view.layer.cornerRadius = 5.0
            view.layer.borderWidth = 2.0
            view.layer.borderColor = (UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)).cgColor
            view.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(5))
            scrollView_jobTypes.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(equalTo: topParent, constant: 10).isActive = true
            if (screenHeight>568)
            {
                if(i%3 == 0)
                {
                    view.leadingAnchor.constraint(equalTo: leadingParent, constant: 0).isActive = true
                }
                else
                {
                    view.leadingAnchor.constraint(equalTo: leadingParent, constant: 10).isActive = true
                }
            }
            else
            {
                if(i%2 == 0)
                {
                    view.leadingAnchor.constraint(equalTo: leadingParent, constant: 0).isActive = true
                }
                else
                {
                    view.leadingAnchor.constraint(equalTo: leadingParent, constant: 10).isActive = true
                }
            }
            let button = UIButton()
            button.backgroundColor = .clear
            button.setTitle(JobskillArr[i][Kskill_name] as! String, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            button.titleLabel?.textColor = UIColor.white
            button.tag = i
            // button.addTarget(self, action: #selector(SkillJob_Action), for: .touchUpInside)
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            let dic = JobskillArr[i]
            // print(selected_SkillArr)
            print(dic)
            //  let str = dic[Kselected] as! String
            
            //  if str == "1"
            // {
            view.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
            //  }
            //  else
            //  {
            //     view.backgroundColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
            // }
            if (screenHeight>568)
            {
                if z == 3
                {
                    z = 0
                    scrollViewHeight = scrollViewHeight + 25.0 + 10.0
                    leadingParent = scrollView_jobTypes.leadingAnchor
                    topParent = view.bottomAnchor
                    print(scrollView_jobTypes.frame.size.width)
                    print(view.frame.size.width)
                    
                }
                else
                {
                    leadingParent = view.trailingAnchor
                }
                
            }
            else
            {
                if z == 2
                {
                    z = 0
                    scrollViewHeight = scrollViewHeight + 25.0 + 10.0
                    leadingParent = scrollView_jobTypes.leadingAnchor
                    topParent = view.bottomAnchor
                    print(scrollView_jobTypes.frame.size.width)
                    print(view.frame.size.width)
                    
                }
                else
                {
                    leadingParent = view.trailingAnchor
                }
                
            }
            
            
            if(i == JobskillArr.count-1)
            {
                view.bottomAnchor.constraint(equalTo: scrollView_jobTypes.bottomAnchor, constant: -20).isActive = true
            }
            
        }
        scrollViewHeight = scrollViewHeight+10
        scrollViewHeight_Jobs.constant = CGFloat(scrollViewHeight)
        scrollView_jobTypes.translatesAutoresizingMaskIntoConstraints = false
 */
    }
    //MARK:- Edit Profile API
    func ApplyJobAPI()
    {
        
        if Reach.isConnectedToNetwork() == true
        {
            
            let dict : [String:Any] = ["user_id":Register_Data.sharedInstance.userID,"job_id" :"\(dicJobDetail["job_id"]!)"]
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            ServerRequest.sharedInstance.delegate = self
            ServerRequest.sharedInstance.PostApi(urlStr: KwithdrawJob, dict)
            
        }
        else
        {
              MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
        }
    }
    
    
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
            msg = "\(KJobwithdrawSuccessfully)"
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
    
    @IBAction func Apply_Action(_ sender: Any) {
        ApplyJobAPI()
    }
    @IBAction func BackAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
