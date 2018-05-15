//
//  ApplicantListVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/26/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD

class ApplicantListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,ResponseProtcol {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableApplicant: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    //MARK: - Variables
    
    var dicJobDetail = [String:Any]()
    var arrApplicantList = [[String:Any]]()
    var refresh = UIRefreshControl()
    var strRefresh = String()
    
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets = false
        super.viewDidLoad()
        lblNoData.isHidden = true
        refresh.addTarget(self, action: #selector(self.refreshData), for: UIControlEvents.valueChanged)
        self.tableApplicant.addSubview(refresh)
        print(dicJobDetail)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        GetApplicantList()
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
        GetApplicantList()
    }
    
    // MARK:- Response Delegate
    
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
		else
		{
        arrApplicantList = Resposnedic[Kapplicants] as! [[String:Any]]
        tableApplicant.reloadData()
        if arrApplicantList.count == 0 {
            lblNoData.isHidden = false
        }
        else
        {
            lblNoData.isHidden = true
        }
		}
    }
    func Failure()
    {
        MBProgressHUD.hide(for: self.view, animated: true)
        CommonFunctions.sharedInstance.showAlert(message: Ksomethingwentwrong, delegate: self)
    }
    
    //MARK:- Edit Profile API
    
    func GetApplicantList()
    {
        if Reach.isConnectedToNetwork() == true
        {
            let dict : [String:Any] = [KuserID:Register_Data.sharedInstance.userID,Kjobid :"\(dicJobDetail[Kjobid]!)"]
            
            if strRefresh == KRefresh
            {
                //No indicator
            }
            else
            {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            ServerRequest.sharedInstance.delegate = self
            ServerRequest.sharedInstance.PostApi(urlStr: KapplicantList, dict)
        }
        else
        {
              MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
        }
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
        
        return arrApplicantList.count
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:ApplicantCell = tableView.dequeueReusableCell(withIdentifier:KApplicantCell) as! ApplicantCell
        
        if let imageURL = arrApplicantList[indexPath.row][KImage]         {
            if let url = URL.init(string: imageURL as! String) {
                cell.ImgView_User.setShowActivityIndicator(true)
                cell.ImgView_User.setIndicatorStyle(.gray)
                cell.ImgView_User.sd_setImage(with: url, placeholderImage: UIImage(named: Klogo))
                
            }
        }
        cell.viewRating.contentMode = UIViewContentMode.scaleAspectFit
        let dic = arrApplicantList[indexPath.row]
        if let rating  = dic[Krating]
        {
          cell.viewRating.rating = Float.init("\(rating)")!
            cell.viewRating.editable = false
            cell.viewRating.halfRatings = false
            cell.viewRating.floatRatings = true
            
        }
        cell.lblShift.text = "\(dic[Kshifts]!)"
        cell.lblJobTitle.text = "\(dic[KName]!)"
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(arrApplicantList)
        print(arrApplicantList[indexPath.row])
        let applicantProfileVC =  UIStoryboard(name: KDashboardVenue, bundle: nil).instantiateViewController(withIdentifier: KApplicantProfileVC) as! ApplicantProfileVC
        let dic = arrApplicantList[indexPath.row] as [String:Any]
        applicantProfileVC.applicant_ID = "\(dic[KuserID]!)"
        applicantProfileVC.job_id = "\(dicJobDetail[Kjobid]!)"
        applicantProfileVC.dicJobDetail = dicJobDetail
        self.navigationController?.pushViewController(applicantProfileVC, animated: true)
        
    }
    
    @IBAction func Back_Action(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}
