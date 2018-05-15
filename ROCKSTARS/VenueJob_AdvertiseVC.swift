//
//  VenueJobVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/23/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Alamofire

class VenueJob_AdvertiseVC: UIViewController,ResponseProtcol,UITextFieldDelegate
{
    //MARK: -  IBOutlets
    
    @IBOutlet var scrollView_Main: UIScrollView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet var scrollView_jobTypes: UIScrollView!
    @IBOutlet var scrollViewHeight_Jobs: NSLayoutConstraint!
    @IBOutlet var img_tick: UIImageView!
    @IBOutlet var txtFld_pay: UITextField!
    @IBOutlet var txtFld_descrption: UITextField!
    @IBOutlet var txtFld_endTime: UITextField!
    @IBOutlet var txtFld_StartTime: UITextField!
    @IBOutlet var txtFld_MM: UITextField!
    @IBOutlet var txtFld_DD: UITextField!
    @IBOutlet var btnBarTender: UIButton!
    @IBOutlet var txtFld_YYYY: UITextField!
    @IBOutlet var btnBarBack: UIButton!
    @IBOutlet var btnBussie: UIButton!
    @IBOutlet var ScrollView_height: NSLayoutConstraint!
    @IBOutlet var scrollView_Skills: UIScrollView!
    
    //MARK: -  Variables
    
    var skillArr = [[String:Any]]()
    var JobskillArr = [[String:Any]]()
    var selected_SkillArr = [[String:Any]]()
    var selectedSkill_IDStr = ""
    var selectedJobSkill_IDStr = ""
    var strDay = ""
    var strMonth = ""
    var strYear = ""
    var strStartTime = ""
    var StartTime = ""
    var strEndTime = ""
    var strVenue_Display = "0"
    var timer = Timer()
    var strStartHours = ""
    var strStartMinutes = ""
	var timePicking = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = false
        img_tick.image = UIImage.init(named: "box")
        MBProgressHUD.showAdded(to: self.view, animated: true)
        GetApi(urlStr:KgetJobs )
        GetApi(urlStr: KgetJobSkills)
        
    }
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARk:- Response Delegate
    
    func Response(Resposnedic : [String:Any])
    {
        MBProgressHUD.hide(for: self.view, animated: true)
        print(Resposnedic)
		/***********************///Aman
		let status : Int  = Resposnedic[KStatus] as! Int
		if(status == 401)
		{
			let msg: String = Resposnedic["message"] as! String
			CommonFunctions.sharedInstance.showAlert(message: msg, delegate: self)
		}
		/***********************/
		else
		{
        let apiName : String = Resposnedic["api"] as! String
        if(apiName == KgetJobSkills)
        {
            skillArr = Resposnedic[KjobSkills] as! [[String : Any]]
            for i in 0..<skillArr.count
            {
                var dic = skillArr[i]
                dic[Kselected] = "0"
                skillArr[i] = dic
            }
            print(skillArr)
            CreateSkillView(SkillsArr:skillArr )
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
            
            CreateJobSkillView(JobskillArr:JobskillArr )
        }
        
        if(apiName == KjobPost)
        {
            print(Resposnedic)
            let msg : String = Resposnedic[KMessage] as! String
            let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
            let OKAction = UIAlertAction(title:OK, style: .default) { (action:UIAlertAction) in
                for i in 0..<self.skillArr.count
                {
                    var dic = self.skillArr[i]
                    dic[Kselected] = "0"
                    self.skillArr[i] = dic
                }
                print(self.skillArr)
                self.CreateSkillView(SkillsArr:self.skillArr )
                for i in 0..<self.JobskillArr.count
                {
                    var dic = self.JobskillArr[i]
                    dic[Kselected] = "0"
                    self.JobskillArr[i] = dic
                }
                print(self.JobskillArr)
                self.CreateJobSkillView(JobskillArr:self.JobskillArr )
                self.txtFld_descrption.text = ""
                self.txtFld_DD.text = ""
                self.txtFld_MM.text = ""
                self.txtFld_endTime.text = ""
                self.txtFld_StartTime.text = ""
                self.txtFld_pay.text = ""
                self.selectedJobSkill_IDStr = ""
                self.selectedSkill_IDStr = ""
                self.strVenue_Display = "0"
                self.img_tick.image = UIImage.init(named: "box")
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Get_Jobs"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Post_Success"), object: nil)
                
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }
	}
    }
    
    func Failure()
    {
        MBProgressHUD.hide(for: self.view, animated: true)
        CommonFunctions.sharedInstance.showAlert(message: Ksomethingwentwrong, delegate: self)
        print(div)
    }
    
    // MARK:- DatePicker Method
    
    func datePickerValueChanged(sender:UIDatePicker)
    {
		
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        txtFld_DD.text = formatter.string(from: sender.date)
        strDay = formatter.string(from: sender.date)
		print(strDay)
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "MMM"
       // let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter1.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        txtFld_MM.text = formatter1.string(from: sender.date)
        let formatter11 = DateFormatter()
        formatter11.dateFormat = "MM"
        //let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter11.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        strMonth = formatter11.string(from: sender.date)
		 print(strMonth)
        let formatter111 = DateFormatter()
        formatter111.dateFormat = "YYYY"
       // let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter111.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        strYear = formatter111.string(from: sender.date)
        print(strYear)
        txtFld_YYYY.text = formatter111.string(from: sender.date)
		
		/**********Aman*******/
		let formatterForComparison = DateFormatter()
		formatterForComparison.dateFormat = "YYYY-MM-dd"
		formatterForComparison.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
		print(sender.date)
		print(sender.minimumDate!)

		/*********Aman*********/
    }
    
    func StartTimePickerValueChanged(sender:UIDatePicker)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "HH:mm"
       // let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter1.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        strStartTime  = formatter1.string(from: sender.date)
		//strStartTime = "12:30"
        let stringInputArr = strStartTime.components(separatedBy: ":")
        let lastStr = stringInputArr[1]
        var lastStrInt = Int.init("\(lastStr)")
		
//		if timePicking == true
//		{
//			if((lastStrInt! > 0 && lastStrInt! < 15)||(lastStrInt! == 0)||(lastStrInt! == 00)||(lastStrInt! == 60))
//			{
//				lastStrInt = 15-lastStrInt!
//				let date = sender.date.addingTimeInterval(Double.init(lastStrInt!) * 60)
//				sender.date = date
//			}
//			else if((lastStrInt! > 15 && lastStrInt! < 30)||(lastStrInt! == 15))
//			{
//				lastStrInt = 30-lastStrInt!
//				let date = sender.date.addingTimeInterval(Double.init(lastStrInt!) * 60)
//				sender.date = date
//				
//			}
//			else if((lastStrInt! > 30 && lastStrInt! < 45)||(lastStrInt! == 30))
//			{
//				lastStrInt = 45-lastStrInt!
//				let date = sender.date.addingTimeInterval(Double.init(lastStrInt!) * 60)
//				sender.date = date
//			}
//			else if((lastStrInt! > 45 && lastStrInt! < 60)||(lastStrInt! == 45))
//			{
//				lastStrInt = 60-lastStrInt!
//				let date = sender.date.addingTimeInterval(Double.init(lastStrInt!) * 60)
//				sender.date = date
//			}
//			
//			timePicking = false
//		}
//		else
//		{
		
        if(lastStrInt! > 0 && lastStrInt! < 15)
        {
            lastStrInt = 15-lastStrInt!
            let date = sender.date.addingTimeInterval(Double.init(lastStrInt!) * 60)
            sender.date = date
        }
        else if(lastStrInt! > 15 && lastStrInt! < 30)
        {
            lastStrInt = 30-lastStrInt!
            let date = sender.date.addingTimeInterval(Double.init(lastStrInt!) * 60)
            sender.date = date
        }
        else if(lastStrInt! > 30 && lastStrInt! < 45)
        {
            lastStrInt = 45-lastStrInt!
            let date = sender.date.addingTimeInterval(Double.init(lastStrInt!) * 60)
            sender.date = date
        }
        else if(lastStrInt! > 45 && lastStrInt! < 60)
        {
            lastStrInt = 60-lastStrInt!
            let date = sender.date.addingTimeInterval(Double.init(lastStrInt!) * 60)
            sender.date = date
        }
		//}
        txtFld_StartTime.text = formatter.string(from: sender.date)
        strStartTime  = formatter1.string(from: sender.date)
        
        formatter1.dateFormat = "HH:mm:ss"
      //  let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter1.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        StartTime = formatter1.string(from: sender.date)
    }
    
    func EndTimePickerValueChanged(sender:UIDatePicker)
    {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "hh:mm a"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter1.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
		
        txtFld_endTime.text = formatter1.string(from: sender.date)
        let formatter11 = DateFormatter()
        formatter11.dateFormat = "HH:mm"
      //  let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter11.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        strEndTime = formatter11.string(from: sender.date)
    }
    
    // MARK:- Textfield Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string
        : String) -> Bool
    {
        if(textField == txtFld_pay)
        {
       /*     if(string == "")
            {
            }
            else
            {
                if((textField.text?.characters.count)!>5)
                {
                    return  false
                }
            }
 */
        }
        else if(textField == txtFld_descrption)
        {
            if(string != "")
            {
                if((textField.text?.characters.count)!>300)
                {
                    return  false
                }
            }
        }
        else if(textField == txtFld_endTime || textField == txtFld_MM || textField == txtFld_DD || textField == txtFld_YYYY || textField == txtFld_StartTime )
        {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField:UITextField)
    {
        if(textField == txtFld_MM || textField == txtFld_DD || textField == txtFld_YYYY)
        {
            let datePickerView:UIDatePicker = UIDatePicker()
            let curentLocale: NSLocale = NSLocale.current as NSLocale
            datePickerView.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            datePickerView.backgroundColor = UIColor.white
            datePickerView.minimumDate = NSDate() as Date
			print(datePickerView.minimumDate!)
            datePickerView.datePickerMode = UIDatePickerMode.date
            txtFld_MM.inputView = datePickerView
            txtFld_DD.inputView = datePickerView
            txtFld_YYYY.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
			/**********Aman*******/
			let formatterForComparison = DateFormatter()
			formatterForComparison.dateFormat = "YYYY-MM-dd"
      formatterForComparison.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
			print(datePickerView.date)
			print(datePickerView.minimumDate!)
			/*********Aman*********/
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
           // let curentLocale: NSLocale = NSLocale.current as NSLocale
            formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            txtFld_DD.text = formatter.string(from: datePickerView.date)
            strDay = formatter.string(from: datePickerView.date)
            print(strDay)
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "MMM"
          //  let curentLocale: NSLocale = NSLocale.current as NSLocale
            formatter1.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            txtFld_MM.text = formatter1.string(from: datePickerView.date)
            
            let formatter11 = DateFormatter()
            formatter11.dateFormat = "MM"
           // let curentLocale: NSLocale = NSLocale.current as NSLocale
            formatter11.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            strMonth = formatter11.string(from: datePickerView.date)
            print(strMonth)
            let formatter111 = DateFormatter()
            formatter111.dateFormat = "YYYY"
           // let curentLocale: NSLocale = NSLocale.current as NSLocale
            formatter111.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            strYear = formatter111.string(from: datePickerView.date)
            print(strYear)
            txtFld_YYYY.text = formatter111.string(from: datePickerView.date)
            txtFld_StartTime.text = ""
            txtFld_endTime.text = ""
            
        }
        else if(textField == txtFld_StartTime)
        {
            if(txtFld_DD.text == "") {
                
                txtFld_DD.resignFirstResponder()
                let alert = UIAlertController.init(title: "Select Date", message: "Please select date first", preferredStyle: .alert)
                let done = UIAlertAction.init(title: "Done", style: .cancel, handler: { (done) in
                })
                alert.addAction(done)
                self.present(alert, animated: true, completion: nil)
                print("Please Select Date First")
                
            }
            else
            {
                let timedatePicker:UIDatePicker = UIDatePicker()
                let curentLocale: NSLocale = NSLocale.current as NSLocale
                timedatePicker.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
                timedatePicker.datePickerMode = .time
                timedatePicker.backgroundColor = UIColor.white
                let selectedDate = txtFld_DD.text
                let formatter2 = DateFormatter()
                formatter2.dateFormat = "dd"
               // let curentLocale: NSLocale = NSLocale.current as NSLocale
                formatter2.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
                let todaysDate = formatter2.string(from:Date())
                formatter2.dateFormat = "YYYY"
                let currentYear = formatter2.string(from:Date())
				 formatter2.dateFormat = "MMM"
				  let currentMonth = formatter2.string(from:Date())
                
                if(Int(selectedDate!)! == Int(todaysDate) && Int(txtFld_YYYY.text!) == Int(currentYear) && currentMonth == txtFld_MM.text ){
					
					let calendar = Calendar.current
					let arr = [0,15,30,45]
					var comp = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
					let minute = comp.minute
					if arr.contains(minute!) {
						comp.minute =  comp.minute! + 1
					}
					let date = calendar.date(from:comp)!
                    timedatePicker.minimumDate =  date
                }
				
                txtFld_StartTime.inputView = timedatePicker
                timedatePicker.minuteInterval = 15
                
                timePicking = true
                timedatePicker.addTarget(self, action: #selector(StartTimePickerValueChanged), for: UIControlEvents.valueChanged)
                
                StartTimePickerValueChanged(sender: timedatePicker)
                txtFld_endTime.text = ""
            }
        }
            
        else if(textField == txtFld_endTime)
        {
            if(txtFld_DD.text == "")
            {
                txtFld_endTime.resignFirstResponder()
                let alert = UIAlertController.init(title: "Select Date", message: "Please select date first", preferredStyle: .alert)
                let done = UIAlertAction.init(title: "Done", style: .cancel, handler: { (done) in
                })
                alert.addAction(done)
                self.present(alert, animated: true, completion: nil)
            }
                
            else if(txtFld_StartTime.text == "")
            {
                txtFld_endTime.resignFirstResponder()
                let alert = UIAlertController.init(title: "Select Start Time", message: "Please select start time first", preferredStyle: .alert)
                let done = UIAlertAction.init(title: "Done", style: .cancel, handler: { (done) in
                })
                alert.addAction(done)
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                let timedatePicker:UIDatePicker = UIDatePicker()
                let curentLocale: NSLocale = NSLocale.current as NSLocale
                timedatePicker.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
                timedatePicker.datePickerMode = .time
                timedatePicker.backgroundColor = UIColor.white
                timedatePicker.minuteInterval = 15
				
				let FormatterSelectedDate = DateFormatter()
			//	FormatterSelectedDate.locale = Locale.init(identifier: "en_GB")
				 // let curentLocale: NSLocale = NSLocale.current as NSLocale
				FormatterSelectedDate.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
				FormatterSelectedDate.dateFormat = "dd MMM yyyy hh:mm a"
				//txtFld_endTime.text = formatter1.string(from: timedatePicker.date)
				
				var str  = ""
				if let day = txtFld_DD.text, let month = txtFld_MM.text, let year = txtFld_YYYY.text, let startTime = txtFld_StartTime.text
					{
						str = day  +  " " + month  +  " " + year + " " + startTime
				      print(str)
				}
				//str  = "29 August 2017 03:30 PM"
				print(FormatterSelectedDate)
				let startDate = FormatterSelectedDate.date(from: str)
				print(startDate ?? "")
				let date = startDate?.addingTimeInterval(60.0 * 60.0)
				
               // var arr = strStartTime.components(separatedBy: ":")
//                if arr[0] != "23"
//                {
//                    let date = (Calendar.current as NSCalendar).date(
//                        
//                        bySettingHour: Int(arr[0])!+1, minute: Int(arr[1])!, second: 0, of: Date(), options: .wrapComponents)
//                    //  let curentLocale: NSLocale = NSLocale.current as NSLocale
//                    timedatePicker.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
//                    timedatePicker.minimumDate = (Calendar.current as NSCalendar).date(byAdding: .day, value:0, to: date!, options: [])
//                }
				
				//timedatePicker.minimumDate = date
                txtFld_endTime.inputView = timedatePicker
                timedatePicker.addTarget(self, action: #selector(EndTimePickerValueChanged), for: UIControlEvents.valueChanged)
                
                let formatter1 = DateFormatter()
                formatter1.dateFormat = "hh:mm a"
              //  let curentLocale: NSLocale = NSLocale.current as NSLocale
                formatter1.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
                txtFld_endTime.text = formatter1.string(from: timedatePicker.date)
                
                let formatter11 = DateFormatter()
                formatter11.dateFormat = "HH:mm"
               // let curentLocale: NSLocale = NSLocale.current as NSLocale
                formatter11.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
                strEndTime = formatter11.string(from: timedatePicker.date)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func CreateSkillView(SkillsArr:[[String : Any]])
    {
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        var scrollViewHeight : CGFloat = 0
        var leadingParent = scrollView_Skills.leadingAnchor
        var topParent = scrollView_Skills.topAnchor
        scrollViewHeight = scrollViewHeight + 25.0 + 10.0
        var z = 0
        for i in 0..<SkillsArr.count
        {
            z += 1
            let view = UIView()
            view.backgroundColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
            view.layer.cornerRadius = 5.0
            view.layer.borderWidth = 2.0
            view.layer.borderColor = (UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)).cgColor
            view.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(5))
            scrollView_Skills.addSubview(view)
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
            button.setTitle(SkillsArr[i][Kskill_name] as? String, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            button.titleLabel?.textColor = UIColor.white
            button.tag = i
            button.addTarget(self, action: #selector(Skill_Action), for: .touchUpInside)
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            let dic = skillArr[i]
            print(selected_SkillArr)
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
                    leadingParent = scrollView_Skills.leadingAnchor
                    topParent = view.bottomAnchor
                    print(scrollView_Skills.frame.size.width)
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
                    leadingParent = scrollView_Skills.leadingAnchor
                    topParent = view.bottomAnchor
                    print(scrollView_Skills.frame.size.width)
                    print(view.frame.size.width)
                    
                }
                else
                {
                    leadingParent = view.trailingAnchor
                }
            }
            if(i == SkillsArr.count-1)
            {
                view.bottomAnchor.constraint(equalTo: scrollView_Skills.bottomAnchor, constant: -20).isActive = true
            }
            
        }
        scrollViewHeight = scrollViewHeight+10
        ScrollView_height.constant = CGFloat(scrollViewHeight)
        scrollView_Skills.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func CreateJobSkillView(JobskillArr:[[String : Any]])
    {
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        var scrollViewHeight : CGFloat = 0
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
            button.setTitle(JobskillArr[i][Kskill_name] as? String, for: .normal)
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
            print(selected_SkillArr)
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
    }
    
    func Skill_Action(sender : UIButton)
    {
        var dic = skillArr[sender.tag]
        let str = dic[Kselected] as! String
        
        if(str == "1")
        {
            dic[Kselected] = "0"
        }
        else
        {
            dic[Kselected] = "1"
        }
        skillArr[sender.tag] = dic
        print(skillArr)
        CreateSkillView(SkillsArr:skillArr )
        selectedSkill_IDStr = ""
        for k in 0..<skillArr.count
        {
            let selectedSkill_Str = skillArr[k][Kselected] as! String
            if(selectedSkill_Str == "1")
            {
                let str = skillArr[k][Kid] as! Int
                print(selectedSkill_IDStr)
                if(selectedSkill_IDStr.characters.count == 0)
                {
                    selectedSkill_IDStr = "\(selectedSkill_IDStr)" + "\(str)"
                }
                else
                {
                    selectedSkill_IDStr = "\(selectedSkill_IDStr)" + "," + "\(str)"
                }
            }
        }
        print(selectedSkill_IDStr)
    }
    
    func SkillJob_Action(sender : UIButton)
    {
        
        for j in 0..<JobskillArr.count
        {
            
            var dic = JobskillArr[j]
            //   let str = dic[Kselected] as! String
            
            if sender.tag == j
            {
                dic[Kselected] = "1"
            }
            else
            {
                dic[Kselected] = "0"
            }
            JobskillArr[j] = dic
            
            
        }
        
        
        print(JobskillArr)
        CreateJobSkillView(JobskillArr:JobskillArr )
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
    }
    
    //MARK:- IBActions
    
    @IBAction func Submit_Action(_ sender: Any)
    {
        self.view.endEditing(true)
        if (selectedJobSkill_IDStr.isEmpty)
        {
            CommonFunctions.sharedInstance.showAlert(message: "Please select at least one job role", delegate: self)
        }
        else if (txtFld_DD.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
        {
            CommonFunctions.sharedInstance.showAlert(message: "Please select date.", delegate: self)
        }
        else if (txtFld_StartTime.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
        {
            CommonFunctions.sharedInstance.showAlert(message: "Please select start time.", delegate: self)
        }
     //   else if (selectedSkill_IDStr.isEmpty)
     //   {            CommonFunctions.sharedInstance.showAlert(message: "Please select at least one job skills", delegate: self)
    //    }
            
        else if (txtFld_descrption.text?.replacingOccurrences(of: " ", with: "").isEmpty)!        {
            CommonFunctions.sharedInstance.showAlert(message: "Please fill your descrption", delegate: self)
        }
        else if (txtFld_pay.text?.replacingOccurrences(of: " ", with: "").isEmpty)!        {
            CommonFunctions.sharedInstance.showAlert(message: "Please fill pay amount", delegate: self)
        }
            
        else
        {
            if Reach.isConnectedToNetwork() == true
            {
                var parmDic = [String : Any]()
                parmDic["user_id"] = UserDefaults.standard.value(forKey: KuserID) as! String
                var endTime = ""
                if (!(txtFld_endTime.text?.replacingOccurrences(of: " ", with: "").isEmpty)!)
                {
                 endTime = strEndTime.FinishTimeZoneStr()
                }
               
                print(endTime)
                parmDic["finish_time"] = endTime
                parmDic["pay"] = txtFld_pay.text
                parmDic["display_venue"] = strVenue_Display
                parmDic["skill_id"] = selectedSkill_IDStr
                parmDic["job_type_id"] = selectedJobSkill_IDStr
                parmDic["description"] = txtFld_descrption.text
                let dateStr:String = strYear+"-"+strMonth+"-"+strDay+" "+StartTime
                print(dateStr)
                let str = dateStr.currentTimeZoneStr()
                print(str)
                parmDic["job_date_time"] = str
                print(parmDic)
                MBProgressHUD.showAdded(to: self.view, animated: true)
                print(Register_Data.sharedInstance.imgData)
                ServerRequest.sharedInstance.delegate = self
                ServerRequest.sharedInstance.delegate = self
                ServerRequest.sharedInstance.PostApi(urlStr: KjobPost, parmDic)
            }
            else
            {
                  MBProgressHUD.hide(for: self.view, animated: true)
                CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
            }
        }
    }
    @IBAction func Tick_Action(_ sender: Any)
    {
        if(strVenue_Display == "0")
        {
            strVenue_Display = "1"
            img_tick.image = UIImage.init(named: "check")
            
        }
        else
        {
            strVenue_Display = "0"
            img_tick.image = UIImage.init(named: "box")
        }
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
                // print(response.request!,param)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    let responseJson = JSON as! [String: Any]
                    if response.response?.statusCode == 200 {
                        self.Response(Resposnedic: responseJson)
                    }
					/*************************///Aman
					else if response.response?.statusCode == 401 {
						self.Response(Resposnedic: responseJson)
					}
					/***********************/
                    else
                    {
                        self.Failure()
                    }
                } else
                {
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
}

