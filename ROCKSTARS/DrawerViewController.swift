//
//  DrawerViewController.swift
//  ROCKSTARS
//
//  Created by Amrit on 15/05/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MessageUI
import MBProgressHUD

class DrawerViewController: UIViewController,MFMailComposeViewControllerDelegate,ResponseProtcol {
    
    @IBOutlet var tblMenu: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tblMenu.delegate = self
        tblMenu.dataSource = self
        tblMenu.separatorStyle = .none
        tblMenu.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        tblMenu.register(UITableViewCell.self, forCellReuseIdentifier: Kcell)
        tblMenu.isOpaque = false
        tblMenu.backgroundColor = UIColor.clear
        tblMenu.backgroundView = nil
        tblMenu.bounces = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK : TableViewDataSource & Delegate Methods
extension DrawerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Kcell, for: indexPath)
        
        let titles: [String] = [KHelpSupport,KSettings,KLogSpcOut]
        cell.backgroundColor = UIColor.clear
        
        let label = UILabel.init(frame: CGRect.init(x:30,y:4,width:tableView.frame.size.width-60,height:30))
        cell.contentView.addSubview(label)
        label.font = UIFont(name: KCairoRegular, size: 18)
        label.textColor = UIColor.white
        label.text  = titles[indexPath.row]
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.init(red: 195/255, green: 88/255, blue: 196/255, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {

        case 0:
			
			openMailApp()
			
//            if MFMailComposeViewController.canSendMail() {
//                let mail = MFMailComposeViewController()
//                mail.mailComposeDelegate = self
//                mail.setToRecipients(["rkstarapp@gmail.com"])//help@rockstarapp.com
//                present(mail, animated: true)
//            } else {
//                print("no mail")
//            }
            break
        case 1:
            
            let storyboard = UIStoryboard(name: "Dashboard_User", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "PasswordNavigation")
           
           sideMenuViewController?.contentViewController = initialViewController
            sideMenuViewController?.hideMenuViewController()
            break
        case 2:
            let actionSheetController: UIAlertController = UIAlertController(title:KAreyousureyouwanttologout, message: nil, preferredStyle: .actionSheet)
            let cancel: UIAlertAction = UIAlertAction(title: KCancel, style: .cancel) { action -> Void in
            }
            actionSheetController.addAction(cancel)
            
            let logout: UIAlertAction = UIAlertAction(title: KLogout, style: .destructive)
            { action -> Void in
                self.LogoutApi()

            }
            actionSheetController.addAction(logout)
            self.present(actionSheetController, animated: true, completion: nil)
            break
        default:
            break
        }
    }
	
	// MARK: - MFMailComposeViewControllerDelegate
	
	func openMailApp() {
		
		if MFMailComposeViewController.canSendMail()
		{
			let mailComposeViewController = configuredMailComposeViewController("help@rockstarapp.com","")
			self.present(mailComposeViewController, animated: true, completion: nil)
		} else
		{
			showSettingAlert()
		}
	}
	
	// MARK: - MFMailComposeViewControllerDelegate
	func configuredMailComposeViewController(_ mailID : String ,_ body : String) -> MFMailComposeViewController
	{
		let mailComposerVC = MFMailComposeViewController()
		mailComposerVC.mailComposeDelegate = self
		mailComposerVC.setToRecipients([mailID])
		mailComposerVC.setSubject("")
		mailComposerVC.setMessageBody(body, isHTML: true)
		
		return mailComposerVC
	}
	
	func showSettingAlert() -> Void
	{
		let alertController = UIAlertController (title: "Unable to share", message: "Your device could not send e-mail.  Please check e-mail configuration in settings and try again.", preferredStyle: .alert)
		
		let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
			guard let settingsUrl = URL(string: "App-Prefs:root=Mail") else {
				return
			}
			
			if UIApplication.shared.canOpenURL(settingsUrl) {
				UIApplication.shared.openURL(settingsUrl)
			}
		}
		alertController.addAction(settingsAction)
		let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
		alertController.addAction(cancelAction)
		present(alertController, animated: true, completion: nil)
	}

	
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        sideMenuViewController?.hideMenuViewController()
        controller.dismiss(animated: true)
    }
    
    func LogoutApi()
    {
        if Reach.isConnectedToNetwork() == true
        {
            
             MBProgressHUD.showAdded(to: appDelegate.window!, animated: true)
            let param : [String:String] = [KuserID:UserDefaults.standard.value(forKey: KuserID) as! String]
            print(param)
            let obj = ServerRequest()
            obj.delegate = self
            let url = kBaseUrl + Klogout
            obj.postMethod(urlStr: url, parameters: param)
            
        }
        else
        {
              MBProgressHUD.hide(for: appDelegate.window!, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
        }
       
    }
    func Response(Resposnedic : [String:Any])
    {
        MBProgressHUD.hide(for: appDelegate.window!, animated: true)
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
        UserDefaults.standard.set(false, forKey: KIsLogin)
        self.appDelegate.InitilizeLogin()
		}
		
        
    }
    func Failure()
    {
        MBProgressHUD.hide(for: self.view, animated: true)
        CommonFunctions.sharedInstance.showAlert(message: Ksomethingwentwrong, delegate: self)
    }
    
}
