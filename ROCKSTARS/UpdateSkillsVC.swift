//
//  UpdateSkillsVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/31/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD

class UpdateSkillsVC: UIViewController,ResponseProtcol {
    
    @IBOutlet var scrollView_AdditionalSkills: UIScrollView!
    @IBOutlet var scrollViewHeight_Jobs: NSLayoutConstraint!
    @IBOutlet var lblStatusSpirits: UILabel!
    @IBOutlet var lblStatusSpirits_centerConstraints: NSLayoutConstraint!
    @IBOutlet var lblStatus_cockTail: UILabel!
    @IBOutlet var lblStatusCockTail_CenterConsraints: NSLayoutConstraint!
    @IBOutlet var spritisHeight_Constraints: NSLayoutConstraint!
    @IBOutlet var cockTailHeight_Constraints: NSLayoutConstraint!
    @IBOutlet var viewSpirits: UIView!
    @IBOutlet var viewCockTail: UIView!
    
    @IBOutlet var viewSpirits_Slider: Horizental_spritis!
    @IBOutlet var viewCockTail_Slider: Horizental_cockTail!
    var dic_ApplicantProfile = [String : Any]()
    
    var skillArr = [[String:Any]]()
    var timer = Timer()
    var user_ID = String()
     var SelectedSkillsArr = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewSpirits.isHidden = true
        viewCockTail.isHidden = true
        UserDefaults.standard.set(true, forKey: KCockTail_Edit)
        UserDefaults.standard.set(true, forKey: KSpirits_Edit)
        NotificationCenter.default.addObserver(self, selector: #selector(RateValue_CockTail), name: NSNotification.Name(rawValue: KCockTail_Edit), object: nil)
      
        NotificationCenter.default.addObserver(self, selector: #selector(RateValue_Spirits), name: NSNotification.Name(rawValue: KSpirits_Edit), object: nil)
        
        viewCockTail_Slider.min = 0
        viewCockTail_Slider.max = 4
        viewCockTail_Slider.step = 1
        
        viewSpirits_Slider.min = 0
        viewSpirits_Slider.max = 4
        viewSpirits_Slider.step = 1

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        getProfileDetailsAPI()
    }
    //MARK:- Profile API
    
    func getProfileDetailsAPI()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let param : [String:String] = [KuserID:user_ID]
        print(param)
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
       else if Resposnedic["status"] as! NSInteger == 200
        {
            //var msg : String = dic[KMessage] as! String
                let api : String = Resposnedic[Kapi] as! String
            
          if(api == kProfileURL)
          {
            let  user : [String:Any] = Resposnedic[KUser] as! [String : Any]
            print(user)
            
            spritisHeight_Constraints.constant = viewSpirits.frame.size.width
            cockTailHeight_Constraints.constant = viewCockTail.frame.size.width
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(LoadData), userInfo: nil, repeats: false);
            dic_ApplicantProfile = user
             Register_Data.sharedInstance.arrSkills = user["skills"] as! Array
            
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            ServerRequest.sharedInstance.delegate = self
            if Reach.isConnectedToNetwork() == true
            {
                ServerRequest.sharedInstance.GetApi(urlStr: Kget_all_skills)
            }
            else
            {
                  MBProgressHUD.hide(for: self.view, animated: true)
                CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
            }
            
            }
          else if(api == "edit_profile")
          {
            let  user : [String:Any] = Resposnedic[KUser] as! [String : Any]
            print(user)
            Register_Data.sharedInstance.rating_Time = "\(user["cocktail_knowledge"]!)"
            Register_Data.sharedInstance.arrSkills = user["skills"] as! Array
           Register_Data.sharedInstance.rating_KeepSellin = "\(user["spirit_knowledge"]!)"
            
            let alertController = UIAlertController(title: "", message: "Updated successfully", preferredStyle: .alert)
            let OKAction = UIAlertAction(title:OK, style: .default) { (action:UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
          
          }
          else
          {
            skillArr = Resposnedic["skills"] as! [[String : Any]]
            
            for k in 0..<skillArr.count
            {
                var dic = skillArr[k]
                
                dic["selected"] = "0"
                
                skillArr[k] = dic
            }
            
           
            
            for i in 0..<skillArr.count
            {
                
            let IDarr = Register_Data.sharedInstance.arrSkills
                
                print(skillArr)
               
                print(IDarr)
                
                for j in 0..<IDarr.count
                {
                    
                    let dictSkill = skillArr[i]
                    
                    let id1 = String(describing : IDarr[j]["id"])
                    let id2 = String(describing : dictSkill["id"])
                    if (id2 == id1)
                    {
                        var dic = skillArr[i]
                        dic["selected"] = "1"
                        skillArr[i] = dic
                    }
                    else
                    {
                    }
                }
            }
            
             print(skillArr)
     
            let rating_cock :Int = Int(viewCockTail_Slider.handlePosition)
            Register_Data.sharedInstance.rating_Time = "\(rating_cock)"
            let rating_spirits :Int = Int(viewSpirits_Slider.handlePosition)
            Register_Data.sharedInstance.rating_KeepSellin = "\(rating_spirits)"

           // skillArr = user[Kskills] as! [[String : Any]]
            CreateSkillView(SkillArr:skillArr )
            }
            //LoadData(dic: user)
            
            //}
        }
    }
    func Failure()
    {
        MBProgressHUD.hide(for: self.view, animated: true)
          CommonFunctions.sharedInstance.showAlert(message: Ksomethingwentwrong, delegate: self)
        print(KFailure)
    }
    
    //MARK:- Other Methods
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
        CreateSkillView(SkillArr:skillArr )
      
       }
    
    func LoadData()
    {
  
        print(dic_ApplicantProfile)
      
       
        if let Cock_rating = dic_ApplicantProfile["cocktail_knowledge"]
        {
            
            if let Spirit_rating = dic_ApplicantProfile["spirit_knowledge"]
            {
                
                Slider_rating(Cock_value: Float.init("\(Cock_rating)")!, spirit_Value: Float.init("\(Spirit_rating)")! )
            }
        }
    }
    func Slider_rating(Cock_value:Float,spirit_Value:Float)
    {
        viewSpirits.isHidden = false
        viewCockTail.isHidden = false
        
        viewSpirits_Slider.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
        viewCockTail_Slider.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
        timer.invalidate()
        
        let rating_CockTail = Cock_value
        viewCockTail_Slider.handlePosition = Double(rating_CockTail)
        let width : CGFloat = viewCockTail_Slider.frame.width/4
        var value_CockTail: CGFloat = width*CGFloat(rating_CockTail)
        if(rating_CockTail == 0)
        {
            lblStatus_cockTail.text = KNone
            value_CockTail = value_CockTail+8
        }
        else if(rating_CockTail == 1)
        {
            lblStatus_cockTail.text = KBEGINNER
            value_CockTail = value_CockTail+4
        }
        else if(rating_CockTail == 2)
        {
            lblStatus_cockTail.text = KMEDIUM
            value_CockTail = value_CockTail+0
        }
        else if(rating_CockTail == 3)
        {
            lblStatus_cockTail.text = KADVANCED
            value_CockTail = value_CockTail-3
        }
        else if(rating_CockTail == 4)
        {
            lblStatus_cockTail.text = KEXPERT
            value_CockTail = value_CockTail-5
        }
        
        lblStatusCockTail_CenterConsraints.constant = value_CockTail
        ///////
        let rating_Spirits = spirit_Value
        
        viewSpirits_Slider.handlePosition = Double(rating_Spirits)
        //let width : CGFloat = viewCockTail_Slider.frame.width/4
        var value_Spirits: CGFloat = width*CGFloat(rating_Spirits)
        if(rating_Spirits == 0)
        {
            lblStatusSpirits.text = KNone
            value_Spirits = value_Spirits+8
        }
        else if(rating_Spirits == 1)
        {
            lblStatusSpirits.text = KBEGINNER
            value_Spirits = value_Spirits+4
        }
        else if(rating_Spirits == 2)
        {
            lblStatusSpirits.text = KMEDIUM
            value_Spirits = value_Spirits+0
        }
        else if(rating_Spirits == 3)
        {
            lblStatusSpirits.text = KADVANCED
            value_Spirits = value_Spirits-3
        }
        else if(rating_Spirits == 4)
        {
            lblStatusSpirits.text = KEXPERT
            value_Spirits = value_Spirits-5
        }
        
        lblStatusSpirits_centerConstraints.constant = value_Spirits
    }
    func CreateSkillView(SkillArr:[[String : Any]])
    {
        print(SkillArr)
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        var scrollViewHeight : CGFloat = 0
        // var scrollView : CGFloat = 0
        var leadingParent = scrollView_AdditionalSkills.leadingAnchor
        var topParent = scrollView_AdditionalSkills.topAnchor
        scrollViewHeight = scrollViewHeight + 25.0 + 10.0
        var z = 0
        for i in 0..<SkillArr.count
        {
            z += 1
            let view = UIView()
            view.backgroundColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
            view.layer.cornerRadius = 5.0
            view.layer.borderWidth = 2.0
            view.layer.borderColor = (UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)).cgColor
            view.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(5))
            scrollView_AdditionalSkills.addSubview(view)
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
            button.setTitle(SkillArr[i][Kskill_name] as? String, for: .normal)
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
            let dic = SkillArr[i]
           //  print(selected_SkillArr)
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
                    leadingParent = scrollView_AdditionalSkills.leadingAnchor
                    topParent = view.bottomAnchor
                    print(scrollView_AdditionalSkills.frame.size.width)
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
                    leadingParent = scrollView_AdditionalSkills.leadingAnchor
                    topParent = view.bottomAnchor
                    print(scrollView_AdditionalSkills.frame.size.width)
                    print(view.frame.size.width)
                    
                }
                else
                {
                    leadingParent = view.trailingAnchor
                }
                
            }
            
            
            if(i == SkillArr.count-1)
            {
                view.bottomAnchor.constraint(equalTo: scrollView_AdditionalSkills.bottomAnchor, constant: -20).isActive = true
            }
            
        }
        scrollViewHeight = scrollViewHeight+10
        scrollViewHeight_Jobs.constant = CGFloat(scrollViewHeight)
        scrollView_AdditionalSkills.translatesAutoresizingMaskIntoConstraints = false
    }

    
    override func viewDidAppear(_ animated: Bool) {
        //spritisHeight_Constraints.constant = viewSpirits.frame.size.width
       // cockTailHeight_Constraints.constant = viewCockTail.frame.size.width
       // timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(update), userInfo: nil, repeats: true);
        
    }

    func RateValue_CockTail()
    {
        let rating :Int = Int(viewCockTail_Slider.handlePosition)
        Register_Data.sharedInstance.rating_Time = "\(rating)"
        let width : CGFloat = viewCockTail_Slider.frame.width/4
        var value: CGFloat = width*CGFloat(rating)
        if(rating == 0)
        {
            lblStatus_cockTail.text = KNone
            
            value = value+8
        }
        else if(rating == 1)
        {
            lblStatus_cockTail.text = KBEGINNER
           
            value = value+4
        }
        else if(rating == 2)
        {
            lblStatus_cockTail.text = KMEDIUM
           
            value = value+0
        }
        else if(rating == 3)
        {
            lblStatus_cockTail.text = KADVANCED
            
            value = value-3
        }
        else if(rating == 4)
        {
            lblStatus_cockTail.text = KEXPERT
            value = value-5
        }
        lblStatusCockTail_CenterConsraints.constant = value
        
       // let rating :Int = Int(slider_Rating.handlePosition)
       // Register_Data.sharedInstance.rating_KeepSellin = "\(rating)"
        
    }
    func RateValue_Spirits()
    {
        
        let rating :Int = Int(viewSpirits_Slider.handlePosition)
        Register_Data.sharedInstance.rating_KeepSellin = "\(rating)"
        let width : CGFloat = viewSpirits_Slider.frame.width/4
        var value: CGFloat = width*CGFloat(rating)
        if(rating == 0)
        {
            lblStatusSpirits.text = KNone
                       value = value+8
        }
        else if(rating == 1)
        {
            lblStatusSpirits.text = KBEGINNER
                       value = value+4
        }
        else if(rating == 2)
        {
            lblStatusSpirits.text = KMEDIUM
                       value = value+0
        }
        else if(rating == 3)
        {
            lblStatusSpirits.text = KADVANCED
                     value = value-3
        }
        else if(rating == 4)
        {
            lblStatusSpirits.text = KEXPERT
            value = value-5
        }
        lblStatusSpirits_centerConstraints.constant = value
        
    }
    func editProfileAPI()
    {
        if Reach.isConnectedToNetwork() == true
        {
            
            //MBProgressHUD.showAdded(to: self.view, animated: true)
            let dict : [String:Any] = ["user_id":Register_Data.sharedInstance.userID,"role_type" :Register_Data.sharedInstance.roleType,"name" :Register_Data.sharedInstance.name,"mobile" :Register_Data.sharedInstance.mobileNumber,"dob" :Register_Data.sharedInstance.dob,"about_me" :Register_Data.sharedInstance.aboutMe,"cocktail_knowledge" :Register_Data.sharedInstance.rating_Time,"spirit_knowledge" :Register_Data.sharedInstance.rating_KeepSellin,/*"image" :Register_Data.sharedInstance.imgData,*/"skills" : Register_Data.sharedInstance.skills_Selected]
            print(dict)
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            ServerRequest.sharedInstance.delegate = self
            
            ServerRequest.sharedInstance.UploadImageWithParam(urlStr: "editProfile", parameters: dict, imgData: Register_Data.sharedInstance.imgData)
            // ServerRequest.sharedInstance.PostApi(urlStr: "editProfile", dict)
        }
        else
        {
              MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: "Internet connection lost.", delegate: self)
        }
        
        
    }
    @IBAction func Update_Skills(_ sender: Any)
    {
       // if((lbl_SelectedSkills.text?.characters.count)! > 0)
      //  {
            var selectedSkill_IDStr = ""
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
            Register_Data.sharedInstance.skills_Selected = selectedSkill_IDStr
        
        if((selectedSkill_IDStr.characters.count) > 0 || Register_Data.sharedInstance.rating_Time != "0" ||
            Register_Data.sharedInstance.rating_KeepSellin != "0")
          {
            editProfileAPI()
         }
         else
         {
            CommonFunctions.sharedInstance.showAlert(message: KPleaseselectatleastoneskill, delegate: self)
        
        }
        
   // }
    }
    @IBAction func BAck_Action(_ sender: Any)
    {
       self.navigationController?.popViewController(animated: true)
    }
    

}
