//
//  RockStarProfileVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 6/2/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class RockStarProfileVC: UIViewController,ResponseProtcol {
    
    //MARK: - IBOutlets
    
    @IBOutlet var scrollView_AdditionalSkills: UIScrollView!
    @IBOutlet var scrollViewHeight_Jobs: NSLayoutConstraint!
    @IBOutlet var lblAboutMe_Value: UILabel!
    @IBOutlet var lblShift_Str: UILabel!
    @IBOutlet var lblShift_value: UILabel!
    @IBOutlet var viewRating: FloatRatingView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var imgBackground: UIImageView!
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
    
    //MARK: - Variables
    
    var timer = Timer()
    var rockStar_ID = String()
    var dic_ApplicantProfile = [String : Any]()
    var SkillArr = [[String:Any]]()
    var job_id = String()
    var dicJobDetail = [String:Any]()
    var cocKTailValue = Float()
    var spiritValue = Float()
    
    override func viewDidLoad()
    {
        self.automaticallyAdjustsScrollViewInsets = false
        viewSpirits.isHidden = true
        viewCockTail.isHidden = true
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: KCockTail_Edit)
        UserDefaults.standard.set(false, forKey: KSpirits_Edit)
        viewCockTail_Slider.min = 0
        viewCockTail_Slider.max = 4
        viewCockTail_Slider.step = 1
        viewSpirits_Slider.min = 0
        viewSpirits_Slider.max = 4
        viewSpirits_Slider.step = 1
        print(rockStar_ID)
        print(job_id)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        imgUser.layer.cornerRadius = imgUser.frame.size.width/2
        imgUser.clipsToBounds = true
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        getProfileDetailsAPI()
    }
    
    //MARK:- Profile API
    
    func getProfileDetailsAPI()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let param : [String:String] = [KuserID:rockStar_ID]
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
    
 // MARK: - Response Delegate
    
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
       else if Resposnedic[KStatus] as! NSInteger == 200
        {
            let  user : [String:Any] = Resposnedic[KUser] as! [String : Any]
            print(user)
            spritisHeight_Constraints.constant = viewSpirits.frame.size.width
            cockTailHeight_Constraints.constant = viewCockTail.frame.size.width
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(LoadData), userInfo: nil, repeats: true);
            dic_ApplicantProfile = user
             SkillArr = user[Kskills] as! [[String : Any]]
            
        }
    }
    
    func Failure()
    {
        MBProgressHUD.hide(for: self.view, animated: true)
        CommonFunctions.sharedInstance.showAlert(message: Ksomethingwentwrong, delegate: self)
        print(KFailure)
    }
    
    //MARK:- Other Methods
    
    
    func CreateSkillView(SkillArr:[[String : Any]])
    {
        print(SkillArr)
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        var scrollViewHeight : CGFloat = 0
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
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            let dic = SkillArr[i]
            print(dic)
            view.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
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
    
    
    func LoadData()
    {
           if let  userName = dic_ApplicantProfile[KName]
        {
            lblUserName.text = userName as? String
        }
          if let shift = dic_ApplicantProfile[Kshifts]
        {
            lblShift_value.text = "\(shift)"
        }
        if let about_me = dic_ApplicantProfile[Kabout_me]
        {
            lblAboutMe_Value.text = CommonFunctions.sharedInstance.decode("\(about_me)")
        }
        
        if let imageURL = dic_ApplicantProfile[KImage]
        {
            if let url = URL.init(string: imageURL as! String) {
                imgUser.setShowActivityIndicator(true)
                imgUser.setIndicatorStyle(.gray)
                    imgBackground.setShowActivityIndicator(true)
                imgBackground.setIndicatorStyle(.gray)
                             imgUser.sd_setImage(with: url, placeholderImage: UIImage(named: Kimg))
                imgBackground.sd_setImage(with: url, placeholderImage: UIImage(named: Kimg))
               }
        }
        if let rating = dic_ApplicantProfile[Krating]
        {
            setRating(value:Float.init("\(rating)")!)
        }
        if let Cock_rating = dic_ApplicantProfile[Kcocktail_knowledge]
        {
            if let Spirit_rating = dic_ApplicantProfile[Kspirit_knowledge]
            {
                Slider_rating(Cock_value: Float.init("\(Cock_rating)")!, spirit_Value: Float.init("\(Spirit_rating)")! )
            }
        }
         CreateSkillView(SkillArr:SkillArr )
    }
    func FinalView()
    {
        viewSpirits.isHidden = false
        viewSpirits_Slider.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
        
        timer.invalidate()
        let rating_CockTail = cocKTailValue
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
        let rating_Spirits = spiritValue
        viewSpirits_Slider.handlePosition = Double(rating_Spirits)
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
    func Slider_rating(Cock_value:Float,spirit_Value:Float)
    {
        cocKTailValue = Cock_value
        spiritValue = spirit_Value
        viewCockTail.isHidden = false
          viewCockTail_Slider.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
         timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(FinalView), userInfo: nil, repeats: false);
        
    }
    
    func setRating(value:Float)
    {
        self.viewRating.contentMode = UIViewContentMode.scaleAspectFit
        self.viewRating.rating = value
        self.viewRating.editable = false
        self.viewRating.halfRatings = false
        self.viewRating.floatRatings = true
    }
    
    //MARK: - IBActions
    
    @IBAction func btnLivesAction(_ sender: Any)
    {
        let tutorialVC = UIStoryboard(name: KTutorial, bundle: nil).instantiateViewController(withIdentifier: KTutorialViewController) as! TutorialViewController
        self.navigationController?.pushViewController(tutorialVC, animated: true)
    }
    @IBAction func Back_Action(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
