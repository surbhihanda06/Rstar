//
//  UserPasswordVC.swift
//  ROCKSTARS
//
//  Created by Rakesh on 7/28/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD
import IQKeyboardManagerSwift
import Alamofire

class UserPasswordVC: UIViewController,ResponseProtcol {
//MARK :- Outlets
    
    @IBOutlet var txtFld_ConfirmPassword: UITextField!
    @IBOutlet var txtFld_NewPassword: UITextField!
    @IBOutlet var txtFld_OldPassword: UITextField!
  
  //  @IBOutlet  var txtFld_OldPassword: JVFloatLabeledTextField!
      //  @IBOutlet  var txtFld_ConfirmPassword: JVFloatLabeledTextField!
   // @IBOutlet weak var txtFld_NewPassword: JVFloatLabeledTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true;
    
        let font = UIFont(name: KCairoRegular, size: 10)!
        let attributes = [
            NSForegroundColorAttributeName: UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0),
            NSFontAttributeName : font]
        txtFld_OldPassword.attributedPlaceholder = NSAttributedString(string: KOLDPASSWORD,attributes:attributes)
          txtFld_NewPassword.attributedPlaceholder = NSAttributedString(string: KNEWPASSWORD,attributes:attributes)
          txtFld_ConfirmPassword.attributedPlaceholder = NSAttributedString(string: KCONFIRMPASSWORD,attributes:attributes)

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions

    @IBAction func MenuAction(_ sender: Any)
    {
        UserDefaults.standard.set(true, forKey: "IsDirectProfile")
        if(UserDefaults.standard.value(forKey: Krole_type) as! String == "2")
        {
             KappDelegate.InitilizeUserHome()
        }
        else
        {
           KappDelegate.InitilizeVenueHome()
        }
       
         // sideMenuViewController?._presentLeftMenuViewController()
    }
    @IBAction func SubmitAction(_ sender: Any)
    {
     self.view.endEditing(true)
        if (txtFld_OldPassword.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
        {
            CommonFunctions.sharedInstance.showAlert(message: KPleasefilloldpassword, delegate: self)
        }
        
        if (txtFld_NewPassword.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
        {
            CommonFunctions.sharedInstance.showAlert(message: KPleasefillnewpassword, delegate: self)
        }
        else if (txtFld_ConfirmPassword.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
        {
            CommonFunctions.sharedInstance.showAlert(message: KPleasefillyourconfirmpassword, delegate: self)
        }
   
        else if (txtFld_NewPassword.text?.characters.count)!<8
        {
            CommonFunctions.sharedInstance.showAlert(message: KPasswordshouldbeatleast6characters, delegate: self)
            
        }
        else if !(txtFld_NewPassword.text == txtFld_ConfirmPassword.text)
        {
            
           // txtFld_ConfirmPassword.text = ""
            CommonFunctions.sharedInstance.showAlert(message: KPassworddoesntmatch, delegate: self)
            
        }
          else
        {
            if Reach.isConnectedToNetwork() == true
            {
                let url = kBaseUrl + kchangePassword
                var parmDic = [String : Any]()
                parmDic[Kold] = txtFld_OldPassword.text
                parmDic[Knew] = txtFld_NewPassword.text
                parmDic[KuserID] = UserDefaults.standard.value(forKey: KuserID) as! String
                print(parmDic)
                MBProgressHUD.showAdded(to: self.view, animated: true)
                //print(Register_Data.sharedInstance.imgData)
                ServerRequest.sharedInstance.delegate = self
                //ServerRequest.sharedInstance.delegate = self
                ServerRequest.sharedInstance.postMethod(urlStr: url, parameters: parmDic)
            }
            else
            {
                  MBProgressHUD.hide(for: self.view, animated: true)
                CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
            }
        }
    }
    
    // MARK: - Response Delegate
    
    func Response(Resposnedic : [String:Any])
    {
        MBProgressHUD.hide(for: self.view, animated: true)
        print(Resposnedic)
        let msg : String = Resposnedic[KMessage] as! String
		/***********************///Aman
		let status : Int  = Resposnedic[KStatus] as! Int
		if(status == 401)
		{
			CommonFunctions.sharedInstance.showAlert(message: msg, delegate: self)
		}
		/***********************/
       else if Resposnedic[KStatus] as! NSInteger == 200
        {
            let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
            let OKAction = UIAlertAction(title:OK, style: .default) { (action:UIAlertAction) in
                UserDefaults.standard.set(true, forKey: "IsDirectProfile")
                if(UserDefaults.standard.value(forKey: Krole_type) as! String == "2")
                {
                    KappDelegate.InitilizeUserHome()
                }
                else
                {
                    KappDelegate.InitilizeVenueHome()
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }
        else
        {
            let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
            let OKAction = UIAlertAction(title:OK, style: .default) { (action:UIAlertAction) in
                UserDefaults.standard.set(true, forKey: "IsDirectProfile")
                          }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }
        }
    
    func Failure()
    {
        MBProgressHUD.hide(for: self.view, animated: true)
        CommonFunctions.sharedInstance.showAlert(message: Ksomethingwentwrong, delegate: self)
        print(div)
    }


    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Textfield Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
    
         if(textField == txtFld_NewPassword)
        {
            if(string != "")
            {
                if((textField.text?.characters.count)!>15)
                {
                    return  false
                }
            }
        }
        else if(textField == txtFld_ConfirmPassword)
        {
            if(string != "")
            {
                if((textField.text?.characters.count)!>15)
                {
                    return  false
                }
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField:UITextField)
    {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return true
    }
    func  textFieldDidEndEditing(_ textField: UITextField)
    {
    }


    

}
