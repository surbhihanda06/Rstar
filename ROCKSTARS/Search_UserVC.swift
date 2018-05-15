//
//  SearchViewController.swift
//  ROCKSTARS
//
//  Created by Amandeep Kaur on 5/8/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage
import Alamofire
import CoreLocation
import IQKeyboardManagerSwift


class Search_UserVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ResponseProtcol,CLLocationManagerDelegate{
    
    //MARK:- Outlets
    @IBOutlet weak var txtFld_date: UITextField!
    @IBOutlet var txtFld_toDate: UITextField!
    @IBOutlet var lblSelected_Skills: UILabel!
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var lblCocktailRank: UILabel!
    @IBOutlet weak var lblSpiritRank: UILabel!
    @IBOutlet weak var lblCocktailLvlName: UILabel!
    @IBOutlet weak var lblSpiritLvlName: UILabel!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var txtFldMyLocation: UITextField!
    @IBOutlet weak var txtFldPostCode: UITextField!
    @IBOutlet var view_Triangle: UIView!
    @IBOutlet weak var SearchTblView: UITableView!
    @IBOutlet weak var btnMyLoc: UIButton!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var skillsScrollVw: UIScrollView!
    @IBOutlet weak var btnPostcode: UIButton!
    @IBOutlet weak var txtFldKM: B68UIFloatLabelTextField!
    @IBOutlet weak var triangleImg: UIImageView!
    @IBOutlet var ImageView_Alpha: UIImageView!
    @IBOutlet var peakView: UIView!
    @IBOutlet var table_Places: UITableView!
    
    //MARK:- Variables
    var arrImg = [String]()
    var arrName = [String]()
    var arrJobPosition = [String]()
    var arrDatetime = [String]()
    var arrJobLists = [[String:Any]]()
    var strMyLoc = String()
    var strPostcode = String()
    var geoCoder = CLGeocoder()
    var dicSkillsDetail = [String:Any]()
    var JobskillArr = [[String:Any]]()
    var selectedSkill_IDStr = ""
    var selectedJobSkill_IDStr = ""
    var strlat = String()
    var strlng = String()
    let locationManager = CLLocationManager()
    var skillArr = [[String:Any]]()
    var timer = Timer()
    var locationArr = [AnyObject]()
    var locationArrID = [AnyObject]()
    var refresh = UIRefreshControl()
    var strRefresh = String()
    var strFromDate = String()
    var strToDate = String()
    var finalStrFromDate = String()
    var finalStrToDate = String()
    //var IsShowPopup  = Bool()
    
    
    override func viewDidLoad()
    {
      //  IsShowPopup = true
        UserDefaults.standard.set(false, forKey: "IsFilter")
        table_Places.isHidden = true
        ImageView_Alpha.isHidden = true
        peakView.isHidden = true
        triangleImg.isHidden = true
        strMyLoc = "0"
        strPostcode = "0"
        
        super.viewDidLoad()
        lblNoData.isHidden = true
        lblNoData.text = "No Jobs Found"
        refresh.addTarget(self, action: #selector(self.refreshData), for: UIControlEvents.valueChanged)
     self.SearchTblView.addSubview(refresh)
        
        self.navigationController?.isNavigationBarHidden = true;
        let font = UIFont(name: KCairoRegular, size: 10)!
        let attributes = [
            NSForegroundColorAttributeName: UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0),
            NSFontAttributeName : font]
        txtFldKM.attributedPlaceholder = NSAttributedString(string: "Within(KM)",attributes:attributes)
        txtFld_date.attributedPlaceholder = NSAttributedString(string: "From Date",attributes:attributes)
        txtFld_toDate.attributedPlaceholder = NSAttributedString(string: "To Date",attributes:attributes)
        arrImg = ["image.jpg","image.jpg","image.jpg","image.jpg"]
        arrName = ["John Cylin","Jack Reacher","Carel Smith","jaqlin farnandes"]
        arrJobPosition = ["Job Position 1","Job Position 2","Job Position 3","Job Position 4"]
        arrDatetime = ["23 April,2017, 4:30 PM","23 April,2017, 4:30 PM","23 April,2017, 4:30 PM","23 April,2017, 4:30 PM"]
        searchView.layer.masksToBounds = false
        searchView.layer.shadowColor = UIColor.lightGray.cgColor
        searchView.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(5.0))
        searchView.layer.shadowOpacity = 0.5
        searchView.layer.cornerRadius = 2.0
        SearchTblView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        SearchTblView.separatorColor = UIColor.clear
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        strlat =  "\(locValue.latitude)"
        strlng =  "\(locValue.longitude)"
           let currentLocation = CLLocation()
        let locLat = currentLocation.coordinate.latitude
        let locLong = currentLocation.coordinate.longitude
        print("Mylocations = \(locLat)\(locLong)\(currentLocation.coordinate.latitude)\(currentLocation.coordinate.longitude)")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let param : [String:String] = ["user_id": UserDefaults.standard.value(forKey: KuserID) as! String]
        
        let url = kBaseUrl + KemployeeDashboard
        if Reach.isConnectedToNetwork() == true
        {
            if(UserDefaults.standard.bool(forKey: "IsFilter"))
            {
               RefershFilterData()
            }
            else
            {
            postMethod(urlStr: url, parameters: param)
            }
            
            GetApi(urlStr: KgetJobs)//Kget_all_skills
            getProfileDetailsAPI()
            
        }
         else
        {
              MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
    }
    
    //MARK:- Refreshing
    
    func refreshData()
    {
        strRefresh = "Refresh"
        print("Refresh")
        self.refresh.endRefreshing()
        if strRefresh == "Refresh"
        {
            //No indicator
        }
        else
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        if(UserDefaults.standard.bool(forKey: "IsFilter"))
        {
           RefershFilterData()
                
          
        }
        else
        {
        let param : [String:String] = ["user_id": UserDefaults.standard.value(forKey: KuserID) as! String]
         let url = kBaseUrl + KemployeeDashboard
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
            }
    
    func getProfileDetailsAPI()
    {
        let param : [String:String] = [KuserID:UserDefaults.standard.value(forKey: KuserID) as! String]
        print(param)
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
    
    //MARK:- Post Method
    
     func postMethod(urlStr : String,parameters : [String:Any]){
        print(urlStr)
         print(parameters)
        
        if Reachability.isConnectedToNetwork()
        {
              Alamofire.request(urlStr, method : .post, parameters : parameters).responseJSON(completionHandler: {
                response in
                print(response.result)
                print(response.result.description)
                print(response.data ?? "")
                print(response.request?.urlRequest ?? "")
                print(response.result.value ?? "")
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    let responseJson = JSON as! [String: Any]
                    if response.response?.statusCode == 200 {
                        
                        self.Response(Resposnedic: responseJson)
                    }
					/***********************///Aman
					else  if response.response?.statusCode == 401 {
						
						self.Response(Resposnedic: responseJson)
					}
					/*****************************/
                    else
                    {
                        self.Failure()
                    }
                } else
                {
                    self.Failure()
                }
              }) }
             else
             {
              MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
        }    }
 
    
    
    func CreateJobSkillView(JobskillArr:[[String : Any]])
    {
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        var scrollViewHeight : CGFloat = 0
          var leadingParent = skillsScrollVw.leadingAnchor
        var topParent = skillsScrollVw.topAnchor
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
            skillsScrollVw.addSubview(view)
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
            button.setTitle((JobskillArr[i][Kskill_name] as! String), for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            button.titleLabel?.textColor = UIColor.white
            button.tag = i
            button.addTarget(self, action: #selector(SkillJob_Action), for: .touchUpInside)
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            let dic = JobskillArr[i]
             print(dic)
            let str = dic[Kselected] as! String
            
            if str == "1"
            {
                view.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
            }
            else
            {
                view.backgroundColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
            }
            if (screenHeight>568)
            {
                if z == 3
                {
                    z = 0
                    scrollViewHeight = scrollViewHeight + 25.0 + 10.0
                    leadingParent = skillsScrollVw.leadingAnchor
                    topParent = view.bottomAnchor
                    print(skillsScrollVw.frame.size.width)
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
                    leadingParent = skillsScrollVw.leadingAnchor
                    topParent = view.bottomAnchor
                    print(skillsScrollVw.frame.size.width)
                    print(view.frame.size.width)
                    
                }
                else
                {
                    leadingParent = view.trailingAnchor
                }
                
            }
            
            
            if(i == JobskillArr.count-1)
            {
                view.bottomAnchor.constraint(equalTo: skillsScrollVw.bottomAnchor, constant: -20).isActive = true
            }
            
        }
        scrollViewHeight = scrollViewHeight+10
        scrollViewHeightConstraint.constant = CGFloat(scrollViewHeight)
        skillsScrollVw.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    // MARK:- DatePicker Method
    
    func datePickerValueChanged(sender:UIDatePicker)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        strFromDate = formatter.string(from: sender.date)
        formatter.dateFormat = "dd-MM-yyyy"
        txtFld_date.text = formatter.string(from: sender.date)
        txtFld_toDate.text = ""
    }
    func datePickerValueChangedTo(sender:UIDatePicker)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        strToDate = formatter.string(from: sender.date)
        formatter.dateFormat = "dd-MM-yyyy"
        txtFld_toDate.text = formatter.string(from: sender.date)
    }
    
    
    
    // MARK:- Textfield Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == txtFldKM)
        {
            if(txtFldKM.text?.characters.count)!>1
            {
                if(string == "")
                {
                return true
                }
            return false
            }
          }
            
       else  if(textField == txtFldPostCode)
        {
            print(textField.text ?? "")
       if(textField.text?.characters.count == 1) && string == ""
            {
                if(timer.isValid) {
                    timer.invalidate()
                }
                locationArr = [AnyObject]()
                locationArrID = [AnyObject]()
                table_Places.reloadData()
                table_Places.isHidden = true
            }
             else if((textField.text?.characters.count)! > 0) && string == ""
            {
                
                var newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
                
                newString = newString.replacingOccurrences(of: " ", with: "")
                
                if(timer.isValid)
                {
                    timer.invalidate()
                }
                
                let dict : [String:String] = ["place":newString]
                timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(GetPlaces), userInfo:dict , repeats: false)
                
            }

            else
            {
         var newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
                 newString = newString.replacingOccurrences(of: " ", with: "")
                     if(timer.isValid) {
                        timer.invalidate()
                    }
                    
                    let dict : [String:String] = ["place":newString]
                    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GetPlaces), userInfo:dict , repeats: false)
            }
            return true
        }
            
        else if(textField == txtFldMyLocation)
        {
            
        }
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField:UITextField)
    {
        if(textField == txtFld_date)
        {
            let datePickerView:UIDatePicker = UIDatePicker()
            let curentLocale: NSLocale = NSLocale.current as NSLocale
            datePickerView.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            datePickerView.backgroundColor = UIColor.white
            datePickerView.minimumDate = NSDate() as Date
            datePickerView.datePickerMode = UIDatePickerMode.dateAndTime

            txtFld_date.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          //  let curentLocale: NSLocale = NSLocale.current as NSLocale
            formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            strFromDate = formatter.string(from: datePickerView.date)
            formatter.dateFormat = "dd-MM-yyyy"
            txtFld_date.text = formatter.string(from: datePickerView.date)
        }
        if(textField == txtFld_toDate)
        {
            if((txtFld_date.text?.characters.count)!>0)
            {
                
                let datePickerView:UIDatePicker = UIDatePicker()
                let curentLocale: NSLocale = NSLocale.current as NSLocale
                datePickerView.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
                datePickerView.backgroundColor = UIColor.white
                let formatter1 = DateFormatter()
                formatter1.dateFormat = "YYYY-MM-dd HH:mm:ss"
               // let curentLocale: NSLocale = NSLocale.current as NSLocale
                formatter1.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
                let miniDate = formatter1.date(from:strFromDate)
                datePickerView.minimumDate = miniDate
                
                datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
                txtFld_toDate.inputView = datePickerView
                datePickerView.addTarget(self, action: #selector(datePickerValueChangedTo), for: UIControlEvents.valueChanged)
                    let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
             //   let curentLocale: NSLocale = NSLocale.current as NSLocale
                formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
                strToDate = formatter.string(from: datePickerView.date)
                formatter.dateFormat = "dd-MM-yyyy"
                txtFld_toDate.text = formatter.string(from: datePickerView.date)
                
            }
            else
            {
                CommonFunctions.sharedInstance.showAlert(message: "Please select From date", delegate: self)
            }
        }
        if(textField == txtFldPostCode)
        {
            IQKeyboardManager.sharedManager().enable = false
        }
    }
       
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
       // import IQKeyboardManagerSwift
        IQKeyboardManager.sharedManager().enable = true

    }
    
    // MARK:- Response Delegate
    
    func Response(Resposnedic : [String:Any])
    {
        print(Resposnedic)
        let strResult = Resposnedic["result"] as! String
		/***********************///Aman
		
		let status : Int  = Resposnedic[KStatus] as! Int
		if(status == 401)
		{
			let msg: String = Resposnedic["message"] as! String
			CommonFunctions.sharedInstance.showAlert(message: msg, delegate: self)
		}
		/***********************/
       else if strResult == "success"
        {
            MBProgressHUD.hide(for: self.view, animated: true)
            let apiName : String = Resposnedic["api"] as! String
            if(apiName == KemployeeDashboard)
            {
                arrJobLists = Resposnedic["dashboard"] as! [[String:Any]]
                SearchTblView.reloadData()
                
                if arrJobLists.count == 0 {
                    lblNoData.isHidden = false
                }
                else
                {
                    lblNoData.isHidden = true
                }
            }
            if Resposnedic["api"] as! String == kProfileURL
            {
                let  user : [String:Any] = Resposnedic[KUser] as! [String : Any]
                print(user)
                Register_Data.sharedInstance.name = user["name"] as! String
                Register_Data.sharedInstance.email = user["email"] as! String
                Register_Data.sharedInstance.mobileNumber = user["mobile"] as! String
                print(user)
                if let dob =  user["dob"]
                {
                    Register_Data.sharedInstance.dob = ("\(dob)" == "<null>") ? "Not Available"  : "\(dob)"
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
                   lblCocktailRank.text = Register_Data.sharedInstance.rating_Time
                lblSpiritRank.text = Register_Data.sharedInstance.rating_KeepSellin
                if lblSpiritRank.text == "0"
                {
                    lblSpiritLvlName.text = "None"
                }
                else if lblSpiritRank.text == "1"
                {
                    lblSpiritLvlName.text = "Beginner"
                }
                else if lblSpiritRank.text == "2"
                {
                    lblSpiritLvlName.text = "Medium"
                }
                else if lblSpiritRank.text == "3"
                {
                    lblSpiritLvlName.text = "Advanced"
                }
                else
                {
                    lblSpiritLvlName.text = "Expert"
                }
                
                if lblCocktailRank.text == "0"
                {
                    lblCocktailLvlName.text = "None"
                }
                else if lblCocktailRank.text == "1"
                {
                    lblCocktailLvlName.text = "Beginner"
                }
                else if lblCocktailRank.text == "2"
                {
                    lblCocktailLvlName.text = "Medium"
                }
                else if lblCocktailRank.text == "3"
                {
                    lblCocktailLvlName.text = "Advanced"
                }
                else
                {
                    lblCocktailLvlName.text = "Expert"
                }
                
                var selectedSkill_NameStr = String()
                selectedSkill_NameStr = ""
                
                skillArr =  user["skills"] as! Array
                for k in 0..<skillArr.count
                {
                    let str = skillArr[k][Kskill_name] as! String
                    print(selectedSkill_NameStr)
                    if(selectedSkill_NameStr.characters.count == 0)
                    {
                        selectedSkill_NameStr = "\(selectedSkill_NameStr)" + "\(str)"
                    }
                    else
                    {
                        selectedSkill_NameStr = "\(selectedSkill_NameStr)" + "/" + " " + "\(str)"
                    }
                    // }
                }
                lblSelected_Skills.text = selectedSkill_NameStr
              }
            if(apiName == KgetJobs)
            {
                JobskillArr = Resposnedic["jobs"] as! [[String : Any]]
                for i in 0..<JobskillArr.count
                {
                    var dic = JobskillArr[i]
                    dic[Kselected] = "0"
                    JobskillArr[i] = dic
                }
                print(JobskillArr)
               //  CreateJobSkillView(JobskillArr:JobskillArr )
            }
            if(apiName == "searchJobs")
            {
                UserDefaults.standard.set(true, forKey: "IsFilter")
             //   if  IsShowPopup == true
               // {
                //    IsShowPopup = false
                ImageView_Alpha.isHidden = true
                peakView.isHidden = true
                triangleImg.isHidden = true
              //  }
                arrJobLists = Resposnedic["jobs"] as! [[String:Any]]
                SearchTblView.reloadData()
                if arrJobLists.count == 0 {
                    lblNoData.isHidden = false
                }
                else
                {
                    lblNoData.isHidden = true
                }
             }
        }
        else
        {
            
            let apiName : String = Resposnedic["api"] as! String
            if apiName == "searchJobs" {
                let alertController = UIAlertController(title: "", message: "Please enable location from settings", preferredStyle: .alert)
                let OKAction = UIAlertAction(title:OK, style: .default) { (action:UIAlertAction) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            else
            {
                let strMessage = Resposnedic["message"] as! String
                let alertController = UIAlertController(title: "", message: strMessage, preferredStyle: .alert)
                let OKAction = UIAlertAction(title:OK, style: .default) { (action:UIAlertAction) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        
        
    }
    func Failure() {
        
        MBProgressHUD.hide(for: self.view, animated: true)
          CommonFunctions.sharedInstance.showAlert(message: Ksomethingwentwrong, delegate: self)
        
    }
    
    //MARK:- Other Methods
    
    func RefershFilterData()
    {
        if Reach.isConnectedToNetwork() == true
        {
            print(JobskillArr)
            
            let skillArr =  Register_Data.sharedInstance.arrSkills
            print(skillArr)
            // for BUSSIE
            
            let k = skillArr as Array
            // Use to get index of BUSSIE in skillArr
            let index = k.index {
                if let dic : Dictionary<String,AnyObject> = $0 as Dictionary<String,AnyObject> {
                    if let value = dic["skill_name"]  as? String, value == "BUSSIE"{
                        return true
                    }
                }
                return false
            }
            if let index1 : NSInteger = index
            {
                let k = JobskillArr as Array
                // Use to get index of BUSSIE in JobskillArr
                let index = k.index {
                    if let dic : Dictionary<String,AnyObject> = $0 as Dictionary<String,AnyObject> {
                        if let value = dic["skill_name"]  as? String, value == "BUSSIE"{
                            return true
                        }
                    }
                    return false
                }
                if let index1 : NSInteger = index
                {
                    print(JobskillArr)
                    var dic = JobskillArr[index1]
                    dic[Kselected] = "1"
                    JobskillArr[index1] = dic
                    print("BUSSIE")
                    print(JobskillArr)
                    
                    print("BUSSIE")
                }
            }
            
            // for BARTENDER
            
            let cockTail_Value = Register_Data.sharedInstance.rating_Time
            let spirit_Value = Register_Data.sharedInstance.rating_KeepSellin
            
            let cockTail :Int = Int.init(cockTail_Value)!
            let spirit :Int = Int.init(spirit_Value)!
            
            if(cockTail > 0 || spirit > 0 )
            {
                //  let skillArr =  JobskillArr
                
                let k = JobskillArr as Array
                let index = k.index {
                    if let dic : Dictionary<String,AnyObject> = $0 as Dictionary<String,AnyObject> {
                        if let value = dic["skill_name"]  as? String, value == "BARTENDER"{
                            return true
                        }
                    }
                    return false
                }
                if let index1 : NSInteger = index
                {
                    print(JobskillArr)
                    var dic = JobskillArr[index1]
                    // let str = dic[Kselected] as! String
                    dic[Kselected] = "1"
                    JobskillArr[index1] = dic
                    print("BARBACK")
                    print(JobskillArr)
                    
                    print("BARTENDER")
                }
            }
            
            // for BARBACK
            
            let index1 = k.index {
                if let dic : Dictionary<String,AnyObject> = $0 as Dictionary<String,AnyObject> {
                    if let value = dic["skill_name"]  as? String, value == "BARBACK"{
                        return true
                    }
                }
                return false
            }
            if let index2 : NSInteger = index1
            {
                let cockTail_Value = Register_Data.sharedInstance.rating_Time
                let spirit_Value = Register_Data.sharedInstance.rating_KeepSellin
                
                let cockTail :Int = Int.init(cockTail_Value)!
                let spirit :Int = Int.init(spirit_Value)!
                
                if(cockTail > 0 || spirit > 0 )
                {
                    let k = JobskillArr as Array
                    let index = k.index {
                        if let dic : Dictionary<String,AnyObject> = $0 as Dictionary<String,AnyObject> {
                            if let value = dic["skill_name"]  as? String, value == "BARBACK"{
                                return true
                            }
                        }
                        return false
                    }
                    if let index1 : NSInteger = index
                    {
                        print(JobskillArr)
                        var dic = JobskillArr[index1]
                        //let str = dic[Kselected] as! String
                        dic[Kselected] = "1"
                        JobskillArr[index1] = dic
                        print("BARBACK")
                        print(JobskillArr)
                        
                        print("BARBACK")
                    }
                }
            }
            selectedJobSkill_IDStr = ""
            for k in 0..<JobskillArr.count
            {
                let selectedSkill_Str = JobskillArr[k][Kselected] as! String
                if(selectedSkill_Str == "1")
                {
                    let str = JobskillArr[k][Kid] as! Int
                    print(selectedJobSkill_IDStr)
                    if(selectedJobSkill_IDStr.characters.count == 0)
                    {
                        selectedJobSkill_IDStr = "\(selectedJobSkill_IDStr)" + "\(str)"
                    }
                    else
                    {
                        selectedJobSkill_IDStr = "\(selectedJobSkill_IDStr)" + "," + "\(str)"
                    }
                }
            }
            print(selectedJobSkill_IDStr)
            /////////////////////////////////////
            IQKeyboardManager.sharedManager().enable = true
            print(strFromDate)
            print(strToDate)
            if(strFromDate.characters.count>0)
            {
                finalStrFromDate = strFromDate.currentDateZoneStrToUTC()
            }
            if(strToDate.characters.count>0)
            {
                finalStrToDate = strToDate.currentDateZoneStrToUTC()
            }
            print(finalStrFromDate)
            print(finalStrToDate)
            
         
                print(UserDefaults.standard.value(forKey: KuserID) as! String)
                print(selectedJobSkill_IDStr)
                print(strlat)
                print(strlng)
                print(txtFldKM.text!)
                let dict : [String:String] = ["user_id": UserDefaults.standard.value(forKey: KuserID) as! String, "roles" : selectedJobSkill_IDStr,"latitude":strlat,"longitude":strlng,"kilometer":txtFldKM.text!,"date_from":finalStrFromDate,"date_to":finalStrToDate]
                print(dict)
                
                
                //    MBProgressHUD.showAdded(to: self.view, animated: true)
                ServerRequest.sharedInstance.delegate = self
                
                ServerRequest.sharedInstance.PostApi(urlStr: "searchJobs", dict)
        }
        else
        {
            MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: "Internet connection lost.", delegate: self)
        }
      //  MBProgressHUD.hide(for: self.view, animated: true)
        
         }
    
    func SkillJob_Action(sender : UIButton)
    {
        
        let skillArr =  Register_Data.sharedInstance.arrSkills
        let Skill_Name = JobskillArr[sender.tag]["skill_name"] as! String
        
        if(Skill_Name == "BUSSIE")
        {
            let k = skillArr as Array
            let index = k.index {
                if let dic : Dictionary<String,AnyObject> = $0 as Dictionary<String,AnyObject> {
                    if let value = dic["skill_name"]  as? String, value == Skill_Name{
                        return true
                    }
                }
                return false
            }
            if let index1 : NSInteger = index
            {
                setSkills_View(index: sender.tag)
            }
            else
            {
                let alertController = UIAlertController(title: "", message: "Must have selected the BUSSIE skill", preferredStyle: .alert)
                let OKAction = UIAlertAction(title:OK, style: .default) { (action:UIAlertAction) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
                
             }
            
            
        }
        if(Skill_Name == "BARTENDER")
        {
            let cockTail_Value = Register_Data.sharedInstance.rating_Time
            let spirit_Value = Register_Data.sharedInstance.rating_KeepSellin
            
            let cockTail :Int = Int.init(cockTail_Value)!
            let spirit :Int = Int.init(spirit_Value)!
            
            if(cockTail > 0 || spirit > 0 )
            {
                setSkills_View(index: sender.tag)
                
            }
            else
            {
                let alertController = UIAlertController(title: "", message: "Must have at least level 1 skill in Spirits or Cocktails", preferredStyle: .alert)
                let OKAction = UIAlertAction(title:OK, style: .default) { (action:UIAlertAction) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
            }
            
            
        }
        if(Skill_Name == "BARBACK")
        {
            let k = skillArr as Array
            let index = k.index {
                if let dic : Dictionary<String,AnyObject> = $0 as Dictionary<String,AnyObject> {
                    if let value = dic["skill_name"]  as? String, value == Skill_Name{
                        return true
                    }
                }
                return false
            }
            if let index1 : NSInteger = index
            {
                let cockTail_Value = Register_Data.sharedInstance.rating_Time
                let spirit_Value = Register_Data.sharedInstance.rating_KeepSellin
                
                let cockTail :Int = Int.init(cockTail_Value)!
                let spirit :Int = Int.init(spirit_Value)!
                
                if(cockTail > 0 || spirit > 0 )
                {
                    setSkills_View(index: sender.tag)
                    
                }
                else
                {
                    let alertController = UIAlertController(title: "", message: "Must have at least level 1 skill in Spirits or Cocktails and selected the BARBACK skill", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title:OK, style: .default) { (action:UIAlertAction) in
                    }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion:nil)
                }
                }
            else
            {
            let alertController = UIAlertController(title: "", message: "Must have at least level 1 skill in Spirits or Cocktails and selected the BARBACK skill", preferredStyle: .alert)
                let OKAction = UIAlertAction(title:OK, style: .default) { (action:UIAlertAction) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
            }
           }
        
        
        ///////////////////////////////////////////
        
        
        print(selectedJobSkill_IDStr)
    }
    
    func setSkills_View(index:Int)
    {
        var dic = JobskillArr[index]
        let str = dic[Kselected] as! String
        
        if(str == "1")
        {
            dic[Kselected] = "0"
        }
        else
        {
            dic[Kselected] = "1"
        }
        JobskillArr[index] = dic
        print(JobskillArr)
      //  CreateJobSkillView(JobskillArr:JobskillArr )

        selectedJobSkill_IDStr = ""
        for k in 0..<JobskillArr.count
        {
            let selectedSkill_Str = JobskillArr[k][Kselected] as! String
            if(selectedSkill_Str == "1")
            {
                let str = JobskillArr[k][Kid] as! Int
                print(selectedJobSkill_IDStr)
                if(selectedJobSkill_IDStr.characters.count == 0)
                {
                    selectedJobSkill_IDStr = "\(selectedJobSkill_IDStr)" + "\(str)"
                }
                else
                {
                    selectedJobSkill_IDStr = "\(selectedJobSkill_IDStr)" + "," + "\(str)"
                }
            }
        }
        
    }
    // MARK: - Table Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
       
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == table_Places
        {
            return 40
        }
        else
        {
        return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == table_Places
        {
            return locationArr.count
        }
        else
        {
            return arrJobLists.count
        }
        
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == table_Places
        {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: cCELL) as UITableViewCell!
            if !(cell != nil)
            {
                cell = UITableViewCell(style:.default, reuseIdentifier: cCELL)
            }
            
           print(locationArr)
            cell?.textLabel!.text = locationArr[indexPath.row] as? String
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)
            return cell!
            
        }
        else
        {
            
            let cell:VenuJob_ActiveCell = tableView.dequeueReusableCell(withIdentifier:"VenuJob_ActiveCell") as! VenuJob_ActiveCell
            
            if let imageURL = arrJobLists[indexPath.row]["image"]         {
                if let url = URL.init(string: imageURL as! String) {
                    cell.ImgView_Venue.setShowActivityIndicator(true)
                    cell.ImgView_Venue.setIndicatorStyle(.gray)
                    cell.ImgView_Venue.sd_setImage(with: url, placeholderImage: UIImage(named: "logo"))
                    
                }
            }
            if let jobDate = arrJobLists[indexPath.row]["job_date"]
            {
                var DateStr:String = jobDate as! String
                print(DateStr)
                DispatchQueue.global(qos: .background).async {
                    DateStr = DateStr.ChangeUTCStringToLocal()
                    DispatchQueue.main.async
                        {
                            cell.lblDate.text = DateStr
                             print(DateStr)
                    }
                }
               
            }
            if let title = arrJobLists[indexPath.row]["title"]
            {
                cell.lblJobTitle.text = title as? String
            }
            if let location = arrJobLists[indexPath.row]["postcode"]
            {
                cell.lblLocation.text = location as? String
            }
            
            
            cell.selectionStyle = .none
            return cell
          }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
         IQKeyboardManager.sharedManager().enable = true
        if(tableView == table_Places)
        {
            if(timer.isValid) {
                timer.invalidate()
            }
            btnPostcode.setImage(UIImage(named: "check"),for: .normal)
            txtFldMyLocation.text = ""
			btnMyLoc.setImage(UIImage(named: "box"), for: .normal)
            strPostcode = "1"
            txtFldPostCode.text = locationArr[indexPath.row] as? String
            table_Places.isHidden = true
            txtFldPostCode.resignFirstResponder()
            MBProgressHUD.showAdded(to: self.view, animated: true)
            CommonFunctions.sharedInstance.findCoordinates(placeID: (locationArrID[indexPath.row] as? String)!) { (address,lat, lng) -> (Void) in
                self.strlat = lat
                self.strlng = lng
                DispatchQueue.main.async {
                       MBProgressHUD.hide(for: self.view, animated: true)
                }
           
            }
        }
        else
        {
         print(arrJobLists)
        print(arrJobLists[indexPath.row])
        let applyJobVC =  UIStoryboard(name: KDashboardUser, bundle: nil).instantiateViewController(withIdentifier: KApplyJobVC) as! ApplyJobVC
        applyJobVC.dicJobDetail = arrJobLists[indexPath.row]
        self.navigationController?.pushViewController(applyJobVC, animated: true)
        }
        }
    
    //MARK:- IBActions
    
    @IBAction func Cross_Action(_ sender: Any)
    {
        txtFld_date.text = ""
        txtFld_toDate.text = ""
        strFromDate = ""
        strToDate = ""
        finalStrFromDate = ""
        finalStrToDate = ""

    }
    @IBAction func Update_Action(_ sender: Any)
    {
      //  IsShowPopup = false
         IQKeyboardManager.sharedManager().enable = true
        let UpdateSkillsVC =  UIStoryboard(name: KDashboardUser, bundle: nil).instantiateViewController(withIdentifier: "UpdateSkillsVC") as! UpdateSkillsVC
        UpdateSkillsVC.user_ID = UserDefaults.standard.value(forKey: KuserID) as! String
        self.navigationController?.pushViewController(UpdateSkillsVC, animated: true)
    }
    @IBAction func btnMenu(_ sender: UIButton)
    {
        sideMenuViewController?._presentLeftMenuViewController()
    }
    
    @IBAction func btnFilterAction(_ sender: Any)
    {
         appDelegate.btn1_user?.isUserInteractionEnabled = false
        appDelegate.btn2_user?.isUserInteractionEnabled = false
        appDelegate.btn3_user?.isUserInteractionEnabled = false
        appDelegate.btn1_user?.isHidden = true
        appDelegate.btn2_user?.isHidden = true
        appDelegate.btn3_user?.isHidden = true
        ImageView_Alpha.isHidden = false
        peakView.isHidden = false
        triangleImg.isHidden = false
    }
    @IBAction func btnMyLocAction(_ sender: Any)
    {
        strPostcode = "0"
        if strMyLoc == "0" {
            btnMyLoc.setImage(UIImage(named: "check"), for: .normal)
            txtFldMyLocation.text = "My Current Location"
            btnPostcode.setImage(UIImage(named: "box"),for: .normal)
            txtFldPostCode.text = ""
            strMyLoc = "1"
            strPostcode = "0"
            self.locationManager.requestAlwaysAuthorization()
            
            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
            
        }
        else
        {
            locationManager.stopUpdatingLocation()
            txtFldMyLocation.text = ""
            strlat = ""
            strlng = ""
            btnMyLoc.setImage(UIImage(named: "box"), for: .normal)
            
            strMyLoc = "0"
        }
        
    }
    @IBAction func btnPostcodeAction(_ sender: Any)
    {
        strMyLoc = "0"
        locationManager.stopUpdatingLocation()
        strlat = ""
        strlng = ""
        btnMyLoc.setImage(UIImage(named: "box"), for: .normal)
        
        if strPostcode == "0" {
           // if txtFldPostCode.text!.replacingOccurrences(of: " ", with: "").characters.count == 0
           // {
                txtFldPostCode.becomeFirstResponder()
                
           // }
//            else
//            {
//                btnPostcode.setImage(UIImage(named: "check"),for: .normal)
//                txtFldMyLocation.text = ""
//                btnMyLoc.setImage(UIImage(named: "box"), for: .normal)
//                strPostcode = "1"
//            }
        }
        else
        {
            txtFldPostCode.text = ""
            strlat = ""
            strlng = ""
            btnPostcode.setImage(UIImage(named: "box"),for: .normal)
            strPostcode = "0"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        IQKeyboardManager.sharedManager().enable = true
        self.view.endEditing(true)
        appDelegate.btn1_user?.isUserInteractionEnabled = true
        appDelegate.btn2_user?.isUserInteractionEnabled = true
        appDelegate.btn3_user?.isUserInteractionEnabled = true
        appDelegate.btn1_user?.isHidden = false
        appDelegate.btn2_user?.isHidden = false
        appDelegate.btn3_user?.isHidden = false
        ImageView_Alpha.isHidden = true
        peakView.isHidden = true
        triangleImg.isHidden = true
    }
    
    //MARK:-
    func addPikeOnView(view:UIView,side: NSInteger, size: CGFloat) {
        //self.layoutIfNeeded()
        let peakLayer = CAShapeLayer()
        var path: CGPath?
        switch side {
        case 0:
            path = self.makePeakPathWithRect(rect: view.bounds, topSize: size, rightSize: 0.0, bottomSize: 0.0, leftSize: 0.0)
        case 1:
            path = self.makePeakPathWithRect(rect: view.bounds, topSize: 0.0, rightSize: 0.0, bottomSize: 0.0, leftSize: size)
            break
        case 2:
            path = self.makePeakPathWithRect(rect: view.bounds, topSize: 0.0, rightSize: size, bottomSize: 0.0, leftSize: 0.0)
            break
        case 3:
            path = self.makePeakPathWithRect(rect: view.bounds, topSize: 0.0, rightSize: 0.0, bottomSize: size, leftSize: 0.0)
            break
        default:
            break
        }
        peakLayer.path = path
        let color = (view.backgroundColor?.cgColor)
        peakLayer.fillColor = color
        peakLayer.strokeColor = color
        peakLayer.lineWidth = 1
        peakLayer.position = CGPoint.zero
        view.layer.insertSublayer(peakLayer, at: 0)
    }
    
    
    func makePeakPathWithRect(rect: CGRect, topSize ts: CGFloat, rightSize rs: CGFloat, bottomSize bs: CGFloat, leftSize ls: CGFloat) -> CGPath {
        //                      P3
        //                    /    \
        //      P1 -------- P2     P4 -------- P5
        //      |                               |
        //      |                               |
        //      P16                            P6
        //     /                                 \
        //  P15                                   P7
        //     \                                 /
        //      P14                            P8
        //      |                               |
        //      |                               |
        //      P13 ------ P12    P10 -------- P9
        //                    \   /
        //                     P11
        
        let centerX = rect.width - 50
        let centerY = rect.height / 2
        var h: CGFloat = 0
        let path = CGMutablePath()
        var points: [CGPoint] = []
        // P1
        points.append(CGPoint(x:rect.origin.x,y: rect.origin.y))
        // Points for top side
        if ts > 0 {
            h = ts * sqrt(3.0) / 2
            let x = rect.origin.x + centerX
            let y = rect.origin.y
            points.append(CGPoint(x:x - ts,y: y))
            points.append(CGPoint(x:x,y: y - h))
            points.append(CGPoint(x:x + ts,y: y))
        }
        
        // P5
        points.append(CGPoint(x:rect.origin.x + rect.width,y: rect.origin.y))
        // Points for right side
        if rs > 0 {
            h = rs * sqrt(4.0) / 2
            let x = rect.origin.x + rect.width
            let y = rect.origin.y + centerY
            points.append(CGPoint(x:x,y: y - rs))
            points.append(CGPoint(x:x + h,y: y))
            points.append(CGPoint(x:x,y: y + rs))
        }
        
        // P9
        points.append(CGPoint(x:rect.origin.x + rect.width,y: rect.origin.y + rect.height))
        // Point for bottom side
        if bs > 0 {
            h = bs * sqrt(3.0) / 2
            let x = rect.origin.x + centerX
            let y = rect.origin.y + rect.height
            points.append(CGPoint(x:x + bs,y: y))
            points.append(CGPoint(x:x,y: y + h))
            points.append(CGPoint(x:x - bs,y: y))
        }
        
        // P13
        points.append(CGPoint(x:rect.origin.x, y: rect.origin.y + rect.height))
        // Point for left sidey:
        if ls > 0 {
            h = ls * sqrt(3.0) / 2
            let x = rect.origin.x
            let y = rect.origin.y + centerY
            points.append(CGPoint(x:x,y: y + ls))
            points.append(CGPoint(x:x - h,y: y))
            points.append(CGPoint(x:x,y: y - ls))
        }
        
        let startPoint = points.removeFirst()
        self.startPath(path: path, onPoint: startPoint)
        for point in points {
            self.addPoint(point: point, toPath: path)
        }
        self.addPoint(point: startPoint, toPath: path)
        return path
    }
    
    func startPath( path: CGMutablePath, onPoint point: CGPoint) {
        path.move(to: CGPoint(x: point.x, y: point.y))
    }
    
    func addPoint(point: CGPoint, toPath path: CGMutablePath) {
        path.addLine(to: CGPoint(x: point.x, y: point.y))
    }
    
    
    //MARK:- Search API
    func searchAPI()
    {
         MBProgressHUD.hide(for: self.view, animated: true)
        print(strFromDate)
        print(strToDate)
        if(strFromDate.characters.count>0)
        {
             finalStrFromDate = strFromDate.currentDateZoneStrToUTC()
        }
        if(strToDate.characters.count>0)
        {
            finalStrToDate = strToDate.currentDateZoneStrToUTC()
        }
        

        print(finalStrFromDate)
        print(finalStrToDate)
            
//        if Reach.isConnectedToNetwork() == true
//        {
            print(UserDefaults.standard.value(forKey: KuserID) as! String)
            print(selectedJobSkill_IDStr)
            print(strlat)
            print(strlng)
            print(txtFldKM.text!)
            let dict : [String:String] = ["user_id": UserDefaults.standard.value(forKey: KuserID) as! String, "roles" : selectedJobSkill_IDStr,"latitude":strlat,"longitude":strlng,"kilometer":txtFldKM.text!,"date_from":finalStrFromDate,"date_to":finalStrToDate]
            print(dict)
            //"29.3963429"
            //"76.8940807"
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
             ServerRequest.sharedInstance.delegate = self
            
            ServerRequest.sharedInstance.PostApi(urlStr: "searchJobs", dict)
            
//        }
//        else
//        {
//              MBProgressHUD.hide(for: self.view, animated: true)
//            CommonFunctions.sharedInstance.showAlert(message: "Internet connection lost.", delegate: self)
//        }
    }
    @IBAction func BtnUpdateAction(_ sender: Any)
    {
          if Reach.isConnectedToNetwork() == true
        {
            MBProgressHUD.hide(for: self.view, animated: true)
            
            print(JobskillArr)
            
            let skillArr =  Register_Data.sharedInstance.arrSkills
            print(skillArr)
            // for BUSSIE
            
            let k = skillArr as Array
            // Use to get index of BUSSIE in skillArr
            let index = k.index {
                if let dic : Dictionary<String,AnyObject> = $0 as Dictionary<String,AnyObject> {
                    if let value = dic["skill_name"]  as? String, value == "BUSSIE"{
                        return true
                    }
                }
                return false
            }
            if let index1 : NSInteger = index
            {
                let k = JobskillArr as Array
                // Use to get index of BUSSIE in JobskillArr
                let index = k.index {
                    if let dic : Dictionary<String,AnyObject> = $0 as Dictionary<String,AnyObject> {
                        if let value = dic["skill_name"]  as? String, value == "BUSSIE"{
                            return true
                        }
                    }
                    return false
                }
                if let index1 : NSInteger = index
                {
                    print(JobskillArr)
                    var dic = JobskillArr[index1]
                    dic[Kselected] = "1"
                    JobskillArr[index1] = dic
                    print("BUSSIE")
                    print(JobskillArr)
                    
                    print("BUSSIE")
                }
            }
            
            // for BARTENDER
            
            let cockTail_Value = Register_Data.sharedInstance.rating_Time
            let spirit_Value = Register_Data.sharedInstance.rating_KeepSellin
          
            
         let cockTail :Int = Int.init(cockTail_Value)!
            let spirit :Int = Int.init(spirit_Value)!
            
            if(cockTail > 0 || spirit > 0 )
            {
                //  let skillArr =  JobskillArr
                
                let k = JobskillArr as Array
                let index = k.index {
                    if let dic : Dictionary<String,AnyObject> = $0 as Dictionary<String,AnyObject> {
                        if let value = dic["skill_name"]  as? String, value == "BARTENDER"{
                            return true
                        }
                    }
                    return false
                }
                if let index1 : NSInteger = index
                {
                    print(JobskillArr)
                    var dic = JobskillArr[index1]
                    // let str = dic[Kselected] as! String
                    dic[Kselected] = "1"
                    JobskillArr[index1] = dic
                    print("BARBACK")
                    print(JobskillArr)
                    
                    print("BARTENDER")
                }
            }
            
            // for BARBACK
            
            let index1 = k.index {
                if let dic : Dictionary<String,AnyObject> = $0 as Dictionary<String,AnyObject> {
                    if let value = dic["skill_name"]  as? String, value == "BARBACK"{
                        return true
                    }
                }
                return false
            }
            if let index2 : NSInteger = index1
            {
                let cockTail_Value = Register_Data.sharedInstance.rating_Time
                let spirit_Value = Register_Data.sharedInstance.rating_KeepSellin
                
                let cockTail :Int = Int.init(cockTail_Value)!
                let spirit :Int = Int.init(spirit_Value)!
                
                if(cockTail > 0 || spirit > 0 )
                {
                    let k = JobskillArr as Array
                    let index = k.index {
                        if let dic : Dictionary<String,AnyObject> = $0 as Dictionary<String,AnyObject> {
                            if let value = dic["skill_name"]  as? String, value == "BARBACK"{
                                return true
                            }
                        }
                        return false
                    }
                    if let index1 : NSInteger = index
                    {
                        print(JobskillArr)
                        var dic = JobskillArr[index1]
                        //let str = dic[Kselected] as! String
                        dic[Kselected] = "1"
                        JobskillArr[index1] = dic
                        print("BARBACK")
                        print(JobskillArr)
                        
                        print("BARBACK")
                    }
                    
                }
                
            }
            selectedJobSkill_IDStr = ""
            for k in 0..<JobskillArr.count
            {
                let selectedSkill_Str = JobskillArr[k][Kselected] as! String
                if(selectedSkill_Str == "1")
                {
                    let str = JobskillArr[k][Kid] as! Int
                    print(selectedJobSkill_IDStr)
                    if(selectedJobSkill_IDStr.characters.count == 0)
                    {
                        selectedJobSkill_IDStr = "\(selectedJobSkill_IDStr)" + "\(str)"
                    }
                    else
                    {
                        selectedJobSkill_IDStr = "\(selectedJobSkill_IDStr)" + "," + "\(str)"
                    }
                }
            }
            
            print(selectedJobSkill_IDStr)
            /////////////////////////////////////
            IQKeyboardManager.sharedManager().enable = true
            
            
            if !(txtFldKM.text == "")
            {
                if !(strPostcode == "1" || strMyLoc == "1")
                {
                    let alertController = UIAlertController(title: "", message: "Please select current location or enter zipcode.", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title:OK, style: .default) { (action:UIAlertAction) in
                    }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion:nil)
                    return
                    
                }
                
            }
            if strPostcode == "1" || strMyLoc == "1"
            {
                if txtFldKM.text == ""
                {
                    let alertController = UIAlertController(title: "", message: "Please enter distance", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title:OK, style: .default) { (action:UIAlertAction) in
                    }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion:nil)
                    return
                    
                }
            }
            if strPostcode == "1" && strlat == ""
            {
                let alertController = UIAlertController(title: "", message: "Please enter valid location", preferredStyle: .alert)
                let OKAction = UIAlertAction(title:OK, style: .default) { (action:UIAlertAction) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
                return
                
            }
            
            if((txtFld_date.text?.characters.count)!>0 && txtFld_toDate.text?.characters.count == 0)
            {
                CommonFunctions.sharedInstance.showAlert(message: "Please select To date", delegate: self)
                return
                //if(txtFld_toDate.text)
                
            }
            MBProgressHUD.hide(for: self.view, animated: true)
            searchAPI()
            
            //  }
        }
        else
        {
            MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: "Internet connection lost.", delegate: self)
        }
        }
    
    
    //MARK :- GetPlaces API
    
    func GetPlaces(timer:Timer)
    {
        let userInfo : [String:String] = timer.userInfo as! [String:String]
        let strPlace : String = userInfo["place"]!
        let str = "AIzaSyAkB27vm8v1Oi-f7HXhudvyx-4CGxk9Az0"
        //let strPlace = "moha"
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(strPlace)&key=\(str)&components=country:au")
       // let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(strPlace)&key=\(str)")
        
        print(url ?? "")
        
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
            // 3
            do {
                if data != nil{
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as!  NSDictionary
                    print(dic)
                    var arr = NSArray()
                    arr = dic.value(forKey: "predictions") as! NSArray
                    self.locationArr = [AnyObject]()
                    self.locationArrID = [AnyObject]()
                    if (arr.count >  0)
                    {
                        for dic in arr
                        {
                            print(dic)
                            
                            self.locationArr.append((dic as! NSDictionary).value(forKey: "description") as AnyObject)
                            self.locationArrID.append((dic as! NSDictionary).value(forKey: "place_id") as AnyObject)
                            
                        }
                        
                        print(self.locationArr)
                        print(self.locationArrID)
                        DispatchQueue.main.async {
                            self.table_Places.isHidden = false
                            
                            
                            self.table_Places.reloadData()
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            self.strlat = ""
                            self.strlng = ""
                            self.table_Places.isHidden = true
                            self.table_Places.reloadData()
                        }
                        
                    }
                    print(self.locationArr)
                    print(self.locationArrID)
                }
                else {
                    
                    print("no data")
                }
            }catch {
                print("Error")
            }
        }
        // 5
        task.resume()
    }
    
    
    //MARK:- GETApI
    
    func GetApi(urlStr : String)
    {
        if Reach.isConnectedToNetwork() == true
        {
            let url = kBaseUrl + urlStr
            Alamofire.request(url, method : .get, parameters : nil).responseJSON(completionHandler: {
                response in
                print(response.result)
                print(response.result.description)
                print(response.data ?? "")
                print(response.request?.urlRequest ?? "")
                print(response.result.value ?? "")
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    let responseJson = JSON as! [String: Any]
                    if response.response?.statusCode == 200
                    {
                        self.Response(Resposnedic: responseJson)
                    }
					/*************************///Aman
					else if response.response?.statusCode == 401
					{
						self.Response(Resposnedic: responseJson)
					}
				   /****************************/
                    else
                    {
                        self.Failure()
                    }
                    
                } else {
                    self.Failure()
                }
            })
        }
            
        else
        {
              MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
        }
         }
    
    
    func checkZipCode () {
        
        CLGeocoder().geocodeAddressString("140301", completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                
                MBProgressHUD.hide(for: self.view, animated: true)
                //self.animateZipResponderUp()
                //CommonFunctions.sharedInstance().showALert("Unable to get Location. Please Try Again", target: self)
                return
            }
            
            if placemarks!.count > 0 {
                
                let pm = placemarks![0]
                self.displayLocationInfo(pm)
                
            } else {
                
                MBProgressHUD.hide(for: self.view, animated: true)
                //self.animateZipResponderUp()
                //CommonFunctions.sharedInstance().showALert("Unable to get Location. Please Try Again", target: self)
            }
        })
    }
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        
        if let containsPlacemark = placemark {
            
            locationManager.stopUpdatingLocation()
           // let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
          //  let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
           // let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            //print(country)
           // print(containsPlacemark.addressDictionary)
           // print(containsPlacemark.subLocality)
           // print(containsPlacemark.locality)
           // print(containsPlacemark.location?.coordinate)
           // print(containsPlacemark.name)
           // print(containsPlacemark.region)
            let locValue:CLLocationCoordinate2D = (containsPlacemark.location?.coordinate)!
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            strlat =  "\(locValue.latitude)"
            strlng =  "\(locValue.longitude)"

        }
    }
    
}
