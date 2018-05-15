//
//  ForgotVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/11/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD

class ForgotVC: UIViewController,UITextFieldDelegate,ResponseProtcol {
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet var txtFld_Email: B68UIFloatLabelTextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        btnSubmit.layer.masksToBounds = false
        btnSubmit.layer.cornerRadius = 2.0
        let font = UIFont(name: KCairoRegular, size: 10)!
        let attributes = [
            NSForegroundColorAttributeName: UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0),
            NSFontAttributeName : font]
        txtFld_Email.attributedPlaceholder = NSAttributedString(string: KEMAIL,attributes:attributes)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:- Textfield Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField:UITextField)
    {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    // MARK:- Response Delegate
    
    func Response(Resposnedic : [String:Any])
    {
        MBProgressHUD.hide(for: self.view, animated: true)
        print(Resposnedic)
        
        let msg: String = Resposnedic["message"] as! String
		/***********************///Aman
		let status : Int  = Resposnedic[KStatus] as! Int
          if(status == 401)
		{
			CommonFunctions.sharedInstance.showAlert(message: msg, delegate: self)
		}
		/***********************/
       else if msg != "The selected email is invalid."
        {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: OK, style: .default) { (action:UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
        }
        else
        {
            let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: OK, style: .default) { (action:UIAlertAction) in
               // self.navigationController?.popViewController(animated: true)
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
    
    // MARK:- IBActions
    
    @IBAction func Back_Action(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func Submit_Action(_ sender: Any)
    {
        self.view.endEditing(true)
        if (txtFld_Email.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
        {
            CommonFunctions.sharedInstance.showAlert(message: KPleasefillyouremailaddress, delegate: self)
        }
            
        else if !(txtFld_Email.text?.lowercased().isValidEmail())!
        {
            CommonFunctions.sharedInstance.showAlert(message: KInvalidemailaddress, delegate: self)
        }
        else
        {
            if Reach.isConnectedToNetwork() == true
            {
                var parmDic = [String : Any]()
                parmDic[KEmail] = txtFld_Email.text
                MBProgressHUD.showAdded(to: self.view, animated: true)
                ServerRequest.sharedInstance.delegate = self
                ServerRequest.sharedInstance.PostApi(urlStr: Kforgot_password, parmDic)
            }
            else
            {
                  MBProgressHUD.hide(for: self.view, animated: true)
                CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
            }
        }
    }
}
