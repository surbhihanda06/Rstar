//
//  Activity_UserVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/18/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class Activity_UserVC: UIViewController,ResponseProtcol,UITableViewDataSource,UITableViewDelegate
{
    //MARK: - Outlets
    @IBOutlet var tableActivity: UITableView!
    @IBOutlet var btnAccepted: UIButton!
    @IBOutlet var btnApplied: UIButton!
    @IBOutlet var AppliedUnderlineVw: UIView!
    @IBOutlet var acceptedUndelineVw: UIView!
    var acceptedJobsArr = [[String:Any]]()
    var appliedArr = [[String:Any]]()
    var jobType = String()
    var refresh = UIRefreshControl()
    var strRfresh = String()
     @IBOutlet weak var lblNoData: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
         lblNoData.isHidden = true
         lblNoData.text = "No Jobs Found"
        refresh.addTarget(self, action: #selector(self.refreshData), for: UIControlEvents.valueChanged)
        self.tableActivity.addSubview(refresh)

        tableActivity.separatorColor = UIColor.clear
        // self.navigationController?.navigationBar.isHidden = true
        
        btnApplied.setImage(UIImage.init(named: "AppliedGray"), for: .normal)
        btnAccepted.setImage(UIImage.init(named: "Check"), for: .normal)
        acceptedUndelineVw.backgroundColor = UIColor.init(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        AppliedUnderlineVw.backgroundColor = UIColor.white
        btnAccepted .setTitleColor(UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0), for: UIControlState.normal)
        btnApplied .setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        jobType = "Accepted"
       
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         getAcceptedDetailsAPI()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Refreshing
    
    func refreshData()
    {
        strRfresh = "Refresh"
        print("Refresh")
        self.refresh.endRefreshing()
        getAcceptedDetailsAPI()
    }

    
    // MARK: - IBAction
    
    @IBAction func Accepted_Action(_ sender: Any)
    {
        self.view.endEditing(true)
        acceptedUndelineVw.backgroundColor = UIColor.init(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        AppliedUnderlineVw.backgroundColor = UIColor.white
        
        btnApplied.setImage(UIImage.init(named: "AppliedGray"), for: .normal)
        btnAccepted.setImage(UIImage.init(named: "Check"), for: .normal)
        AppliedUnderlineVw.isHidden=true
        acceptedUndelineVw.isHidden=false
        btnAccepted .setTitleColor(UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0), for: UIControlState.normal)
        btnApplied .setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        jobType = "Accepted"
        tableActivity.reloadData()
        if acceptedJobsArr.count == 0 {
            lblNoData.isHidden = false
        }
        else
        {
            lblNoData.isHidden = true
        }

        
    }
    
    @IBAction func Applied_Action(_ sender: Any)
    {
        self.view.endEditing(true)
        AppliedUnderlineVw.backgroundColor = UIColor.init(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        acceptedUndelineVw.backgroundColor = UIColor.white
        btnApplied.setImage(UIImage.init(named: "Applied"), for: .normal)
        btnAccepted.setImage(UIImage.init(named: "CheckGray"), for: .normal)
        AppliedUnderlineVw.isHidden=false
        acceptedUndelineVw.isHidden=true
        btnApplied .setTitleColor(UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0), for: UIControlState.normal)
        btnAccepted .setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        jobType = "Applied"
        tableActivity.reloadData()
        if appliedArr.count == 0 {
            lblNoData.isHidden = false
        }
        else
        {
            lblNoData.isHidden = true
        }
        

        
    }
    
    // MARK: - Table Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return 84.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if jobType == "Accepted"
        {
            return acceptedJobsArr.count
        }
        else
        {
            return appliedArr.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:VenuJob_ActiveCell = tableView.dequeueReusableCell(withIdentifier:"VenuJob_ActiveCell") as! VenuJob_ActiveCell
        
        if jobType == "Accepted" {
            if let imageURL = acceptedJobsArr[indexPath.row]["image"]         {
                if let url = URL.init(string: imageURL as! String) {
                    cell.ImgView_Venue.setShowActivityIndicator(true)
                    cell.ImgView_Venue.setIndicatorStyle(.gray)
                    cell.ImgView_Venue.sd_setImage(with: url, placeholderImage: UIImage(named: "logo"))
                }
            }
            if let jobDate = acceptedJobsArr[indexPath.row]["job_date"]
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
            if let title = acceptedJobsArr[indexPath.row]["title"]
            {
                cell.lblJobTitle.text = title as? String
            }
            if let location = acceptedJobsArr[indexPath.row]["location"]
            {
              //  let building_no = acceptedJobsArr[indexPath.row]["building_number"]
                let postcode = acceptedJobsArr[indexPath.row]["postcode"]
                cell.lblLocation.text = "\(location)" + ", " + "\(postcode!)"
            }
           }
        else
        {
            if let imageURL = appliedArr[indexPath.row]["image"]         {
                if let url = URL.init(string: imageURL as! String) {
                    cell.ImgView_Venue.setShowActivityIndicator(true)
                    cell.ImgView_Venue.setIndicatorStyle(.gray)
                    cell.ImgView_Venue.sd_setImage(with: url, placeholderImage: UIImage(named: "logo"))
                }
            }
            if let jobDate = appliedArr[indexPath.row]["job_date"]
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
            if let title = appliedArr[indexPath.row]["title"]
            {
                cell.lblJobTitle.text = title as? String
            }
            if let location = appliedArr[indexPath.row]["postcode"]
            {
                cell.lblLocation.text = location as? String
            }
            
        }
        
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if jobType == "Accepted"
        {
            let AcceptedVenueInfoVC =  UIStoryboard(name: KDashboardUser, bundle: nil).instantiateViewController(withIdentifier: "SearchAcceptedEmpInfoVC") as! SearchAcceptedEmpInfoVC
            AcceptedVenueInfoVC.dicAcceptedDetail = acceptedJobsArr[indexPath.row]
            self.navigationController?.pushViewController(AcceptedVenueInfoVC, animated: true)
        }
        else
        {
            let withDrawVC =  UIStoryboard(name: KDashboardUser, bundle: nil).instantiateViewController(withIdentifier: "WithDrawVC") as! WithDrawVC
            withDrawVC.dicJobDetail = appliedArr[indexPath.row]
            self.navigationController?.pushViewController(withDrawVC, animated: true)
        }
        
        
    }
    
    
    //MARK:- Accepted Info API
    
    func getAcceptedDetailsAPI()
    {
        if strRfresh == "Refresh"
        {
            //No indicator
        }
        else
        {
           MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        print("UserID:",UserDefaults.standard.value(forKey: KuserID) as! String)
        let param : [String:String] = ["user_id": UserDefaults.standard.value(forKey: KuserID) as! String]
        
        let url = kBaseUrl + kAcceptedEmpURL
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
		else if Resposnedic["status"] as! NSInteger == 200 {
            
            if Resposnedic["api"] as! String == "employeeActivity" {
                
                let  jobsDic : [String:Any] = Resposnedic["jobs"] as! [String : Any]
                print(jobsDic)
                
                acceptedJobsArr = jobsDic["accepted_jobs"] as! [[String:Any]]
                appliedArr = jobsDic["applied_jobs"] as! [[String:Any]]
                
                tableActivity.reloadData()
                if jobType == "Accepted"
                {
                    if acceptedJobsArr.count == 0 {
                        lblNoData.isHidden = false
                    }
                    else
                    {
                        lblNoData.isHidden = true
                    }
                }
                else
                {
                    if appliedArr.count == 0 {
                        lblNoData.isHidden = false
                    }
                    else
                    {
                        lblNoData.isHidden = true
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
    
    //MARK:- Post Method
    
    func postMethod(urlStr : String,parameters : [String:Any]){
        
        print(urlStr)
        print(parameters)
        if Reachability.isConnectedToNetwork() {
            
            Alamofire.request(urlStr, method : .post, parameters : parameters).responseJSON(completionHandler: {
                response in
                print(response.result)
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
				/***************************///Aman
					else if response.response?.statusCode == 401 {
						
						self.Response(Resposnedic: responseJson)
					}
                /*******************************/
                    else{
                        self.Failure()
                    }
                } else {
                    self.Failure()
                }
            }) }
        else
        {
              MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
        }
        

    }

}
