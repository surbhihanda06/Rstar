
//
//  LoginVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/11/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginVC: UIViewController,ResponseProtcol,UITextFieldDelegate
{
    //MARK: - IBOutlets
    
    @IBOutlet var txtFld_Email: B68UIFloatLabelTextField!
    @IBOutlet var txtFld_password: B68UIFloatLabelTextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnFindShift: UIButton!
    @IBOutlet weak var btnHireSomeone: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "IsDirectProfile")

        btnSignUp.layer.masksToBounds = false
        btnSignUp.layer.cornerRadius = 2.0
        btnFindShift.layer.masksToBounds = false
        btnFindShift.layer.cornerRadius = 2.0
        btnHireSomeone.layer.masksToBounds = false
        btnHireSomeone.layer.cornerRadius = 2.0
        
        let font = UIFont(name: KCairoSemiBold, size: 11)!
        let attributes = [
            NSForegroundColorAttributeName: UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0),
            NSFontAttributeName : font]
        txtFld_Email.attributedPlaceholder = NSAttributedString(string: KEMAIL,attributes:attributes)
        txtFld_password.attributedPlaceholder = NSAttributedString(string: KPASSWORD,attributes:attributes)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(_ animated: Bool)
    {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    // MARK:- IBActions
    
    @IBAction func FindShift_Action(_ sender: Any)
    {
        let registerVC =  UIStoryboard(name: KMain, bundle: nil).instantiateViewController(withIdentifier: KRegisterVC) as! RegisterVC
        self.navigationController?.pushViewController(registerVC, animated: true)
        
    }
    
    @IBAction func HireSome_Action(_ sender: Any)
    {
        let registerVC =  UIStoryboard(name: KMain, bundle: nil).instantiateViewController(withIdentifier: KRegisterVenueVC) as! RegisterVenueVC
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func SignIn_Action(_ sender: Any)
    {
        self.view.endEditing(true)
        if (txtFld_Email.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
        {
            CommonFunctions.sharedInstance.showAlert(message: KPleaseFillYourEmailAddress, delegate: self)
        }
            
        else if !(txtFld_Email.text?.lowercased().isValidEmail())!
        {
            CommonFunctions.sharedInstance.showAlert(message: KInvalidEmailAddress, delegate: self)
        }
        else if (txtFld_password.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
        {
            CommonFunctions.sharedInstance.showAlert(message: KPleaseFillYourPassword, delegate: self)
        }
        else{
            if Reach.isConnectedToNetwork() == true
            {
                var parmDic = [String : Any]()
                parmDic[KEmail] = txtFld_Email.text
                parmDic[KPassword] = txtFld_password.text
                parmDic[Kdevice_type] = Kiphone
                parmDic[Kdevice_token] = defaults.object(forKey: "device_token") as! String
                print(parmDic)
                MBProgressHUD.showAdded(to: self.view, animated: true)
                ServerRequest.sharedInstance.delegate = self
                ServerRequest.sharedInstance.PostApi(urlStr: KLogin, parmDic)
            }
            else
            {
                  MBProgressHUD.hide(for: self.view, animated: true)
                CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
            }
        }
    }
    
    @IBAction func Forgot_Action(_ sender: Any)
    {
        let forgotVC =  UIStoryboard(name: KMain, bundle: nil).instantiateViewController(withIdentifier: KForgotVC) as! ForgotVC
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
    
    
    // MARK:- Response Delegate
    
    
    func Response(Resposnedic : [String:Any])
    {
        MBProgressHUD.hide(for: self.view, animated: true)
        print(Resposnedic)
        
        let msg : String = Resposnedic[KMessage] as! String
        let status : Int  = Resposnedic[KStatus] as! Int
        
        if(msg == KInvalidEmailOrPassword || status == 422 )
        {
            CommonFunctions.sharedInstance.showAlert(message: msg, delegate: self)
        }
		/**********************///Aman
		else if(status == 401)
		{
			CommonFunctions.sharedInstance.showAlert(message: msg, delegate: self)
		}
		/*******************/
        else
        {
            UserDefaults.standard.set(true, forKey: KIsLogin)
            var userDic = [String : Any]()
            userDic = Resposnedic[KUser] as! [String : Any]
            print(userDic[Krole_type] ?? "")
            print(userDic[Krole_type] ?? "")
            User.sharedInstance.email = userDic[KEmail] as! String
            User.sharedInstance.name = userDic[KName] as! String
            User.sharedInstance.user_id = userDic[KuserID] as! String
            UserDefaults.standard.set(userDic[KuserID] as! String, forKey: KuserID)
            let role_type = userDic[Krole_type]!
            User.sharedInstance.role_type = "\(role_type)"
            UserDefaults.standard.set( User.sharedInstance.role_type, forKey: Krole_type)
            print("\(role_type)")
            if User.sharedInstance.role_type == "2"
            {
                KappDelegate.InitilizeUserHome()
            }
            else
            {
                KappDelegate.InitilizeVenueHome()
            }
        }
    }
    func Failure()
    {

        MBProgressHUD.hide(for: self.view, animated: true)
        CommonFunctions.sharedInstance.showAlert(message: Ksomethingwentwrong, delegate: self)
    }
    
    // MARK:- Textfield Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- StatusBar Delegate
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
    
}
