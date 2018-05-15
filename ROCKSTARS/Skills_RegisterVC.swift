    
    //
    //  Skills_RegisterVC.swift
    //  ROCKSTARS
    //
    //  Created by Rakesh Kumar on 5/9/17.
    //  Copyright © 2017 SoftProdigy. All rights reserved.
    //
    
    import UIKit
    import MBProgressHUD
    
    
    class Skills_RegisterVC: UIViewController,ResponseProtcol {
        
       
        @IBOutlet weak var lblTitle: UILabel!
        @IBOutlet weak var btnFinish: UIButton!
        @IBOutlet var lbl_SelectedSkills: UILabel!
        @IBOutlet var ScrollView_height: NSLayoutConstraint!
        @IBOutlet var scrollView_Skills: UIScrollView!
        var strEdit = String()
        var skillArr = [[String:Any]]()
        var selected_SkillArr = [[String:Any]]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            if strEdit == "Edit" {
                
                lblTitle.text = "EDIT PROFILE"
            }
            else
            {
                lblTitle.text = "REGISTER"
            }
            btnFinish.layer.masksToBounds = false
            btnFinish.layer.cornerRadius = 2.0
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
        
        override func viewDidAppear(_ animated: Bool)
        {
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
            if(apiName == Kfacebook_register)
            {
                UserDefaults.standard.set(true, forKey: KIsLogin)
                var userDic = [String : Any]()
                userDic = Resposnedic[KUser] as! [String : Any]
                print(userDic[Krole_type] ?? "")
                print(userDic[Krole_type] ?? "")
                User.sharedInstance.email = ""
                User.sharedInstance.name = ""
                if let userId = userDic[KuserID]
                {
                    User.sharedInstance.user_id = "\(userId)"
                    UserDefaults.standard.set("\(userId)", forKey: KuserID)
                    print("\(userId)")
                }
                
                if let role_type = userDic[Krole_type]
                {
                    User.sharedInstance.role_type = "\(role_type)"
                    
                    print("\(role_type)")
                }
               // self.performSegue(withIdentifier: KMainToUser_Skills, sender: self)
                //self.performSegue(withIdentifier: "MainToTutorial", sender: self)
            }
            else if(apiName == Kget_all_skills)
            {
                
                skillArr = Resposnedic["skills"] as! [[String : Any]]
                
            
                for k in 0..<skillArr.count
                {
                    var dic = skillArr[k]
                    dic["selected"] = "0"
                    skillArr[k] = dic
                }
                
                print(skillArr)
                
               /* for i in 0..<skillArr.count
                {
                    
                    //   let str = Register_Data.sharedInstance.skills_Selected
                    let IDarr = Register_Data.sharedInstance.arrSkills
                    
                    print(skillArr)
                    
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
                    print("SkillsArray1--->",skillArr)
                    
                    if strEdit == "Edit"
                    {
                        var strFinalSelectedSkills = String()
                        for x in 0..<skillArr.count
                        {
                            let isSelected = skillArr[x]["selected"] as! String
                            
                            if isSelected == "1"
                            {
                                let strSelectedSkill = skillArr[x]["skill_name"] as! String
                                if strFinalSelectedSkills == ""
                                {
                                    strFinalSelectedSkills = strSelectedSkill
                                }
                                else
                                {
                                    strFinalSelectedSkills = strFinalSelectedSkills + "/" + strSelectedSkill
                                }
                                
                            }
                            
                            
                        }
                        print(strFinalSelectedSkills)
                        
                        lbl_SelectedSkills.text = strFinalSelectedSkills
                    }
                    else
                    {
                        lbl_SelectedSkills.text = ""
                    }
                    
                }*/

                print("SkillsArray--->",skillArr)

                CreateSkillView(SkillsArr:skillArr )
                
                
            }
            else if(apiName == Kregister)
            {
                UserDefaults.standard.set(true, forKey: KIsLogin)
                var userDic = [String : Any]()
                userDic = Resposnedic[KUser] as! [String : Any]
                print(userDic[Krole_type] ?? "")
                print(userDic[Krole_type] ?? "")
                User.sharedInstance.email = ""
                User.sharedInstance.name = ""
                if let userId = userDic[KuserID]
                {
                    User.sharedInstance.user_id = "\(userId)"
                    UserDefaults.standard.set("\(userId)", forKey: KuserID)
                    print("\(userId)")
               
                }
                if let role_type = userDic[Krole_type]
                {
                    User.sharedInstance.role_type = "\(role_type)"
                UserDefaults.standard.set(User.sharedInstance.role_type, forKey: Krole_type)
                    
                    print("\(role_type)")
                }
               self.performSegue(withIdentifier: "MainToTutorial", sender: self)
             //  KappDelegate.InitilizeUserHome()

            }
            
            else if(apiName == "edit_profile")
            {
                
                let msg : String = Resposnedic["message"] as! String
                
                let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                    // self.navigationController?.popViewController(animated: true)
                    self.performSegue(withIdentifier: "MainToUser_Skills", sender: self)
                    
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
        
        
        
        //MARK: - Others Methods
        
        func CreateSkillView(SkillsArr:[[String : Any]])
        {
            var scrollViewHeight : CGFloat = 0
            var leadingParent = scrollView_Skills.leadingAnchor
            var topParent = scrollView_Skills.topAnchor
            scrollViewHeight = scrollViewHeight + 30.0 + 10.0
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
                view.leadingAnchor.constraint(equalTo: leadingParent, constant: 10).isActive = true
                let button = UIButton()
                button.backgroundColor = .clear
                button.setTitle(SkillsArr[i][Kskill_name] as? String, for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
                button.titleLabel?.textColor = UIColor.white
                button.tag = i
                button.addTarget(self, action: #selector(Skill_Action), for: .touchUpInside)
                view.addSubview(button)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.heightAnchor.constraint(equalToConstant: 30).isActive = true
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
                if z == 2
                {
                    z = 0
                    scrollViewHeight = scrollViewHeight + 30.0 + 10.0
                    leadingParent = scrollView_Skills.leadingAnchor
                    topParent = view.bottomAnchor
                    print(scrollView_Skills.frame.size.width)
                    print(view.frame.size.width)
                    
                }
                else
                {
                    leadingParent = view.trailingAnchor
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
            lbl_SelectedSkills.text = ""
            var selectedSkill_NameStr = ""
            
            for k in 0..<skillArr.count
            {
                let selectedSkill_Str = skillArr[k][Kselected] as! String
                if(selectedSkill_Str == "1")
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
                }
            }
            lbl_SelectedSkills.text = selectedSkill_NameStr
        }
        
        func Register()
        {
            if Reach.isConnectedToNetwork() == true
            {
                var parmDic = [String : Any]()
                print(Register_Data.sharedInstance.email)
                print(Register_Data.sharedInstance.password)
                print(Register_Data.sharedInstance.mobileNumber)
                print(Register_Data.sharedInstance.dob)
                print(Register_Data.sharedInstance.skills_Selected)
                print(Register_Data.sharedInstance.rating_Time)
                print(Register_Data.sharedInstance.rating_KeepSellin)
                print(Register_Data.sharedInstance.name)
                
                parmDic[KName] = Register_Data.sharedInstance.name
                parmDic[KEmail] = Register_Data.sharedInstance.email
                parmDic[Krole_type] = "2"
                parmDic[KMobile] = Register_Data.sharedInstance.mobileNumber
                parmDic[KDob] = Register_Data.sharedInstance.dob
                parmDic[Kabout_me] = Register_Data.sharedInstance.aboutMe
                parmDic[Kskills] = Register_Data.sharedInstance.skills_Selected
                parmDic[Kcocktail_knowledge] = Register_Data.sharedInstance.rating_Time
                parmDic[Kspirit_knowledge] = Register_Data.sharedInstance.rating_KeepSellin
                parmDic[KPassword] = Register_Data.sharedInstance.password
                parmDic[Kdevice_type] = Kiphone
                parmDic[Kdevice_token] = defaults.object(forKey: "device_token") as! String
                print(parmDic)
                MBProgressHUD.showAdded(to: self.view, animated: true)
                print(Register_Data.sharedInstance.imgData)
                ServerRequest.sharedInstance.delegate = self
                ServerRequest.sharedInstance.UploadImageWithParam(urlStr: Kregister, parameters: parmDic, imgData: Register_Data.sharedInstance.imgData)
            }
            else
            {
                  MBProgressHUD.hide(for: self.view, animated: true)
                CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
            }
        }
        
        // MARK: - IBActions
        
        @IBAction func OneMoreStep_Action(_ sender: Any)
        {
            if((lbl_SelectedSkills.text?.characters.count)! > 0) || Register_Data.sharedInstance.rating_KeepSellin != "0" || Register_Data.sharedInstance.rating_Time != "0"
            {
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
                if strEdit == "Edit"
                {
                    
                    editProfileAPI()
                    
                }
                    
                else
                {
                    
                    Register()
                    
                }
                
            }
            else
            {
                CommonFunctions.sharedInstance.showAlert(message: KPleaseselectatleastoneskill, delegate: self)
            }
        }
        
        //MARK:- Edit Profile API
        func editProfileAPI()
        {
            if Reach.isConnectedToNetwork() == true
            {
                
                MBProgressHUD.showAdded(to: self.view, animated: true)
                let dict : [String:Any] = ["user_id":Register_Data.sharedInstance.userID,"role_type" :Register_Data.sharedInstance.roleType,"name" :Register_Data.sharedInstance.name,"mobile" :Register_Data.sharedInstance.mobileNumber,"dob" :Register_Data.sharedInstance.dob,"about_me" :Register_Data.sharedInstance.aboutMe,"cocktail_knowledge" :Register_Data.sharedInstance.rating_Time,"spirit_knowledge" :Register_Data.sharedInstance.rating_KeepSellin,/*"image" :Register_Data.sharedInstance.imgData,*/"skills" : Register_Data.sharedInstance.skills_Selected]
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
        

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if strEdit == "Edit"
            {


            }
            else
            {
                let secondViewController = segue.destination as! TutorialViewController
                secondViewController.strTute = "Tutorial"
                //     secondViewController.delegate = self
            }
       
            
            
        }

        
        @IBAction func Back_Action(_ sender: Any)
        {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
