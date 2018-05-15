//
//  VenueJob_ActiveVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/25/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class VenueJob_ActiveVC: UIViewController,ResponseProtcol,UITableViewDelegate,UITableViewDataSource
{
    //MARK: - IBOutlets
    
    @IBOutlet var tableActiveJobs: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    //MARK:- Variables
    
    var refresh = UIRefreshControl()
    var strRefresh = String()
    var arrJobLists = [[String:Any]]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        lblNoData.isHidden = true
        lblNoData.text = KNoJobsFound
        refresh.addTarget(self, action: #selector(self.refreshData), for: UIControlEvents.valueChanged)
        self.tableActiveJobs.addSubview(refresh)
        let notificationName = Notification.Name(KGetJobs)
        NotificationCenter.default.addObserver(self, selector: #selector(GetJobs), name: notificationName, object: nil)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let param : [String:String] = [KuserID: UserDefaults.standard.value(forKey: KuserID) as! String]
        
        let url = kBaseUrl + KactiveJobs
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
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Refreshing
    
    func refreshData()
    {
        strRefresh = KRefresh
       self.refresh.endRefreshing()
        GetJobs()
    }
    
    //MARK:- GET JOBS
    
    func GetJobs()
    {
        if strRefresh == KRefresh
        {
            //No indicator
        }
        else
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        let param : [String:String] = [KuserID: UserDefaults.standard.value(forKey: KuserID) as! String]
        
        let url = kBaseUrl + KactiveJobs
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
    
    //MARK:- Edit Profile API
    
    func DeleteJobs(param : [String:Any])
    {
        if Reach.isConnectedToNetwork() == true
        {
            let param : [String:Any] = [KuserID:Register_Data.sharedInstance.userID,Kjobid :"\(param[Kjobid]!)"]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            ServerRequest.sharedInstance.delegate = self
            ServerRequest.sharedInstance.PostApi(urlStr: KdeleteJob, param)
        }
        else
        {
              MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
        }
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
        let apiName : String = Resposnedic[Kapi] as! String
        if(apiName == KactiveJobs)
        {
            if let arrJbLst = Resposnedic["activejobs"] as? [[String:Any]]
            {
                arrJobLists = arrJbLst
            }
          //  arrJobLists = Resposnedic[KactiveJobs] as! [[String:Any]]
            if(arrJobLists.count>0)
            {
                lblNoData.isHidden = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: KPostSuccess), object: nil)
            }
            else
            {
                lblNoData.isHidden = false
            }
            tableActiveJobs.reloadData()
        }
        else if(apiName == KdeleteJob)
        {
            GetJobs()
        }
		
	}
    }
    
    func Failure()
    {
        MBProgressHUD.hide(for: self.view, animated: true)
        CommonFunctions.sharedInstance.showAlert(message: Ksomethingwentwrong, delegate: self)
        print(div)
    }
    
    // MARK: - Table Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return arrJobLists.count
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:VenuJob_ActiveCell = tableView.dequeueReusableCell(withIdentifier:KVenuJob_ActiveCell) as! VenuJob_ActiveCell
        
        if let imageURL = arrJobLists[indexPath.row][KImage]   {
            if let url = URL.init(string: imageURL as! String) {
                cell.ImgView_Venue.setShowActivityIndicator(true)
                cell.ImgView_Venue.setIndicatorStyle(.gray)
                cell.ImgView_Venue.sd_setImage(with: url, placeholderImage: UIImage(named: Klogo))
            }
        }
        if let jobDate = arrJobLists[indexPath.row][Kjob_date]
        {
            print(jobDate)
            print(jobDate)
            var DateStr:String = jobDate as! String
            DispatchQueue.global(qos: .background).async {
                DateStr = DateStr.ChangeUTCStringToLocal()
                DispatchQueue.main.async
                    {
                        cell.lblDate.text = DateStr
                }
            }
            print(DateStr)
            
        }
        if let title = arrJobLists[indexPath.row][Ktitle]
        {
            cell.lblJobTitle.text = title as? String
        }
        if let postcode = arrJobLists[indexPath.row]["postcode"]
        {
           // let building_no = arrJobLists[indexPath.row]["building_number"]
          //  let postcode = arrJobLists[indexPath.row]["postcode"]
           // cell.lblLocation.text = "\(building_no!)" + ", " + "\(location)" + ", " + "\(postcode!)"
            cell.lblLocation.text = "\(postcode)"
            //cell.lblLocation.text = location as? String
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let dic = arrJobLists[indexPath.row] as [String:Any]
        print(dic)
        
        if let status  = dic[Kjob_status] as? String
        {
            if (status == KApplied)
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: KDashboardVenue, bundle:nil)
                let SearchAcceptedVenueInfoVC = storyBoard.instantiateViewController(withIdentifier: KSearchAcceptedVenueInfoVC) as! SearchAcceptedVenueInfoVC
                SearchAcceptedVenueInfoVC.dicAcceptedDetail = arrJobLists[indexPath.row]
                self.navigationController?.pushViewController(SearchAcceptedVenueInfoVC, animated: true)
            }
            else
            {
                print(arrJobLists)
                print(arrJobLists[indexPath.row])
                let ApplicantListVC =  UIStoryboard(name: KDashboardVenue, bundle: nil).instantiateViewController(withIdentifier: KApplicantListVC) as! ApplicantListVC
                ApplicantListVC.dicJobDetail = arrJobLists[indexPath.row]
                self.navigationController?.pushViewController(ApplicantListVC, animated: true)
            }
         }
    }
    
    // this method handles row deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete
        {
              DeleteJobs(param: arrJobLists[indexPath.row])
        }
    }
    
    //MARK:- Post Method
    
    func postMethod(urlStr : String,parameters : [String:Any]){
        
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
				/********************///Aman
					else if response.response?.statusCode == 401 {
						
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
        }
        
    }
    
}
