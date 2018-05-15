//
//  SearchAcceptedEmpInfoVC.swift
//  ROCKSTARS
//
//  Created by Amandeep Kaur on 5/30/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD

class SearchAcceptedEmpInfoVC: UIViewController
{
    @IBOutlet var line_venue: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPhNo: UITextField!
    @IBOutlet weak var txtFldVenueManager: UITextField!
    @IBOutlet weak var txtFldVenueAddress: UITextField!
    @IBOutlet weak var txtFldVenueName: UITextField!
    @IBOutlet weak var txtFldPostcode: UITextField!
    @IBOutlet weak var txtFldPay: UITextField!
    @IBOutlet weak var txtFldDescription: UITextField!
    @IBOutlet weak var txtFldFinishTime: UITextField!
    @IBOutlet weak var txtFldStartTime: UITextField!
    @IBOutlet weak var txtFldDay: UITextField!
    @IBOutlet weak var txtFldYear: UITextField!
    @IBOutlet weak var txtFldMonth: UITextField!
    var dicAcceptedDetail = [String:Any]()
    var AcceptedArr = [[String:Any]]()
    var completeDateStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(dicAcceptedDetail)
        if let jobDate = dicAcceptedDetail[Kjob_date]
        {
            completeDateStr = jobDate as! String
            txtFldStartTime.text = completeDateStr.MethodForStartTime()
            txtFldMonth.text = completeDateStr.MethodForMonth()
            txtFldDay.text = completeDateStr.MethodForDay()
            print(completeDateStr)
        }
        print(dicAcceptedDetail)
        txtFldPay.text = "\(dicAcceptedDetail["pay"]!)"
        txtFldDescription.text = "\(dicAcceptedDetail["description"]!)"
        txtFldPostcode.text = "\(dicAcceptedDetail["postcode"]!)"
       // txtFldDay.text = "\(dicAcceptedDetail["on_date"]!)".ChangeUTCDayToCurrent()
        txtFldYear.text = "\(dicAcceptedDetail["on_year"]!)".ChangeUTCYearToCurrent()

        txtFldVenueName.text = "\(dicAcceptedDetail["venue"]!)"
         let isDisplayVenue = "\(dicAcceptedDetail["display_venue"]!)"
        if(isDisplayVenue == "0")
        {
            line_venue.isHidden = true
            txtFldVenueName.isHidden = true

        }
        else
        {
            line_venue.isHidden = false
            txtFldVenueName.isHidden = false
        
        }
        
        txtFldEmail.text = "\(dicAcceptedDetail["email"]!)"
        txtFldPhNo.text = "\(dicAcceptedDetail["mobile"]!)"
        txtFldVenueManager.text = "\(dicAcceptedDetail["name"]!)"
        
        let location = dicAcceptedDetail["location"]
       // let building_no = dicAcceptedDetail["building_number"]
        //let postcode = dicAcceptedDetail["postcode"]
         txtFldVenueAddress.text = "\(location!)"
       // txtFldVenueAddress.text = "\(dicAcceptedDetail["location"]!)"
        
//        let formatter1 = DateFormatter()
//        formatter1.dateFormat = "MM"
//        let date = formatter1.date(from:"\(dicAcceptedDetail["on_month"]!)")
//        let mnthStr = formatter1.string(from: date!)
//        txtFldMonth.text = mnthStr.ChangeUTCMonthToCurrent()
        
        
//        let strTime = "\(dicAcceptedDetail["start_time"]!)"
//        print(strTime)
//        
       let formatter2 = DateFormatter()
//        formatter2.dateFormat = "HH:mm:ss"
//        if let Start_time = formatter2.date(from:strTime)
//        {
//            print(Start_time)
//            let startTimeStr = formatter2.string(from: Start_time)
//            txtFldStartTime.text = startTimeStr.ChangeUTCTimeToCurrent()
//        }
//        else
//        {
//            txtFldStartTime.text = strTime.ChangeUTCTimeToCurrent()
//        }
        
        formatter2.dateFormat = "HH:mm:ss"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter2.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        if let end_time = formatter2.date(from:"\(dicAcceptedDetail["finish_time"]!)")
        {
            let endTimeStr = formatter2.string(from: end_time)
            txtFldFinishTime.text = endTimeStr.ChangeUTCTimeToCurrent()
            
        }
        else
        {
            
            txtFldFinishTime.text = "\(dicAcceptedDetail["finish_time"]!)".ChangeUTCTimeToCurrent()

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool)
    {
        AcceptedArr = dicAcceptedDetail[Kjob_roles] as! [[String : Any]]
        CreateJobSkillView(AcceptedArr:AcceptedArr )
    }
    
    
    func CreateJobSkillView(AcceptedArr:[[String : Any]])
    {
        print(AcceptedArr)
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        var scrollViewHeight : CGFloat = 0
        // var scrollView : CGFloat = 0
        var leadingParent = scrollView.leadingAnchor
        var topParent = scrollView.topAnchor
        scrollViewHeight = scrollViewHeight + 25.0 + 10.0
        var z = 0
        for i in 0..<AcceptedArr.count
        {
            z += 1
            let view = UIView()
            view.backgroundColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
            view.layer.cornerRadius = 5.0
            view.layer.borderWidth = 2.0
            view.layer.borderColor = (UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)).cgColor
            view.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(5))
            scrollView.addSubview(view)
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
            button.setTitle(AcceptedArr[i][Kskill_name] as? String, for: .normal)
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
            let dic = AcceptedArr[i]
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
                    leadingParent = scrollView.leadingAnchor
                    topParent = view.bottomAnchor
                    print(scrollView.frame.size.width)
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
                    leadingParent = scrollView.leadingAnchor
                    topParent = view.bottomAnchor
                    print(scrollView.frame.size.width)
                    print(view.frame.size.width)
                    
                }
                else
                {
                    leadingParent = view.trailingAnchor
                }
                
            }
            
            
            if(i == AcceptedArr.count-1)
            {
                view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
            }
            
        }
        scrollViewHeight = scrollViewHeight+10
     scrollViewHeightConstraint.constant = CGFloat(scrollViewHeight)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }

    
    
    
    @IBAction func btnBackAction(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
        }
   
}
