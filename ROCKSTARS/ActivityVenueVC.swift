//
//  ActivityVenueVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/25/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class ActivityVenueVC: UIViewController,ResponseProtcol,UITableViewDataSource,UITableViewDelegate {
    
    //MARK:- IBOutlets
    
    @IBOutlet var tableAccepted: UITableView!
    @IBOutlet var btnAccepted: UIButton!
    @IBOutlet var btnHistory: UIButton!
    @IBOutlet var HistoryUnderlineVw: UIView!
    @IBOutlet var acceptedUndelineVw: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    
    //MARK: - Variables
    
    var acceptedJobsArr = [[String:Any]]()
    var historyArr = [[String:Any]]()
    var jobType = String()
    var refresh = UIRefreshControl()
    var strRefresh = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoData.isHidden = true
        lblNoData.text = KNoJobsFound
        refresh.addTarget(self, action: #selector(self.refreshData), for: UIControlEvents.valueChanged)
        self.tableAccepted.addSubview(refresh)
        
        tableAccepted.separatorColor = UIColor.clear
        btnHistory.setImage(UIImage.init(named: KHistoryGray), for: .normal)
        btnAccepted.setImage(UIImage.init(named: KCheck), for: .normal)
        acceptedUndelineVw.backgroundColor = UIColor.init(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        HistoryUnderlineVw.backgroundColor = UIColor.white
        btnAccepted .setTitleColor(UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0), for: UIControlState.normal)
        btnHistory .setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        jobType = KAccepted
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAcceptedDetailsAPI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Refreshing
    
    func refreshData()
    {
        strRefresh = KRefresh
       self.refresh.endRefreshing()
        getAcceptedDetailsAPI()
    }
    
    @IBAction func History_Action(_ sender: Any) {
        
        self.view.endEditing(true)
        HistoryUnderlineVw.backgroundColor = UIColor.init(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        acceptedUndelineVw.backgroundColor = UIColor.white
        btnHistory.setImage(UIImage.init(named: KHistory), for: .normal)
        btnAccepted.setImage(UIImage.init(named: KCheckGray), for: .normal)
        HistoryUnderlineVw.isHidden=false
        acceptedUndelineVw.isHidden=true
        btnHistory .setTitleColor(UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0), for: UIControlState.normal)
        btnAccepted .setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        jobType = KHistory
        tableAccepted.reloadData()
        if historyArr.count == 0 {
            lblNoData.isHidden = false
        }
        else
        {
            lblNoData.isHidden = true
        }
        
    }
    
    @IBAction func Accepted_Action(_ sender: Any) {
        self.view.endEditing(true)
        acceptedUndelineVw.backgroundColor = UIColor.init(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        HistoryUnderlineVw.backgroundColor = UIColor.white
        btnHistory.setImage(UIImage.init(named: KHistoryGray), for: .normal)
        btnAccepted.setImage(UIImage.init(named: KCheck), for: .normal)
        HistoryUnderlineVw.isHidden=true
        acceptedUndelineVw.isHidden=false
        btnAccepted .setTitleColor(UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0), for: UIControlState.normal)
        btnHistory .setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        jobType = KAccepted
        tableAccepted.reloadData()
        if acceptedJobsArr.count == 0 {
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
        if jobType == KAccepted
        {
            return acceptedJobsArr.count
        }
        else
        {
            return historyArr.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:VenuJob_ActiveCell = tableView.dequeueReusableCell(withIdentifier:KVenuJob_ActiveCell) as! VenuJob_ActiveCell
        if jobType == KAccepted {
            if let imageURL = acceptedJobsArr[indexPath.row][KImage]         {
                if let url = URL.init(string: imageURL as! String) {
                    cell.ImgView_Venue.setShowActivityIndicator(true)
                    cell.ImgView_Venue.setIndicatorStyle(.gray)
                    cell.ImgView_Venue.sd_setImage(with: url, placeholderImage: UIImage(named: Klogo))
                }
            }
            if let jobDate = acceptedJobsArr[indexPath.row][Kjob_date]
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
            if let title = acceptedJobsArr[indexPath.row][Ktitle]
            {
                cell.lblJobTitle.text = title as? String
            }
            if let location = acceptedJobsArr[indexPath.row][Klocation]
            {
                cell.lblLocation.text = location as? String
            }
        }
            
        else
        {
            if let imageURL = historyArr[indexPath.row][KImage]         {
                if let url = URL.init(string: imageURL as! String) {
                    cell.ImgView_Venue.setShowActivityIndicator(true)
                    cell.ImgView_Venue.setIndicatorStyle(.gray)
                    cell.ImgView_Venue.sd_setImage(with: url, placeholderImage: UIImage(named: Klogo))
                }
            }
            if let jobDate = historyArr[indexPath.row][Kjob_date]
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
            if let title = historyArr[indexPath.row][Ktitle]
            {
                cell.lblJobTitle.text = title as? String
            }
            if let location = historyArr[indexPath.row][Klocation]
            {
                cell.lblLocation.text = location as? String
            }
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if jobType == KAccepted
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: KDashboardVenue, bundle:nil)
            let AcceptedVenueInfoVC = storyBoard.instantiateViewController(withIdentifier: KSearchAcceptedVenueInfoVC) as! SearchAcceptedVenueInfoVC
            AcceptedVenueInfoVC.dicAcceptedDetail = acceptedJobsArr[indexPath.row]
            self.navigationController?.pushViewController(AcceptedVenueInfoVC, animated: true)
        }
        else
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: KDashboardVenue, bundle:nil)
            let AcceptedVenueInfoVC = storyBoard.instantiateViewController(withIdentifier: KSearchAcceptedVenueInfoVC) as! SearchAcceptedVenueInfoVC
            AcceptedVenueInfoVC.dicAcceptedDetail = historyArr[indexPath.row]
            self.navigationController?.pushViewController(AcceptedVenueInfoVC, animated: true)
        }
    }
    
    
    //MARK:- Accepted Info API
    
    func getAcceptedDetailsAPI()
    {
        
        if strRefresh == KRefresh
        {
            //No indicator
        }
        else
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        let param : [String:String] = [KuserID:UserDefaults.standard.value(forKey: KuserID) as! String]
        
        let url = kBaseUrl + kAcceptedVenueURL
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
       else if Resposnedic[KStatus] as! NSInteger == 200 {
            
            if Resposnedic[Kapi] as! String == kAcceptedVenueURL {
                
                let  jobsDic : [String:Any] = Resposnedic[Kjobs] as! [String : Any]
                print(jobsDic)
                acceptedJobsArr = jobsDic[Kaccepted_jobs] as! [[String:Any]]
                historyArr = jobsDic[Khistory] as! [[String:Any]]
                print(historyArr)
                if(historyArr.count>0)
                {
                    User.sharedInstance.arrJobHistory = historyArr
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: KShowRating), object: nil)
                }
                tableAccepted.reloadData()
                if jobType == KAccepted
                {
                    if acceptedJobsArr.count == 0
                    {
                        lblNoData.isHidden = false
                    }
                    else
                    {
                        lblNoData.isHidden = true
                    }
                }
                else
                {
                    if historyArr.count == 0
                    {
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
					/***********************///Aman
					else if response.response?.statusCode == 401 {
						
						self.Response(Resposnedic: responseJson)
					}
					/************************/
                    else{
                        self.Failure()
                    }
                } else {
                    self.Failure()
                }
            }) } else
        {
            CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
        }
        
    }
    
    
}
