//
//  RegisterVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/11/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD
import FBSDKCoreKit
import FBSDKLoginKit

class RegisterVC: UIViewController,UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate,ResponseProtcol,UITextViewDelegate {
    
    @IBOutlet var lblCharCount: UILabel!
    @IBOutlet weak var btnHidePwd: UIButton!
    @IBOutlet weak var btnShowpwd: UIButton!
    @IBOutlet weak var btnShowHidePwdImg: UIButton!
    @IBOutlet var imgView_User: UIImageView!
    var imagePicker = UIImagePickerController()
    var fbLoginManager = FBSDKLoginManager()
    var imgData = Data()
    @IBOutlet var txtFld_ConfirmPass: B68UIFloatLabelTextField!
    @IBOutlet var txtFld_Password: B68UIFloatLabelTextField!
    @IBOutlet var txtFld_Email: B68UIFloatLabelTextField!
    @IBOutlet var txtFld_Name: B68UIFloatLabelTextField!
    @IBOutlet var txtFld_Dob: B68UIFloatLabelTextField!
    @IBOutlet var txtFld_MobileNum: B68UIFloatLabelTextField!
    
    @IBOutlet var txtView_AboutMe: UITextView!
    
    
    let datePickerView:UIDatePicker = UIDatePicker()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
          lblCharCount.isHidden = true
        let font = UIFont(name: KCairoRegular, size: 10)!
       // let font = UIFont(name: "Cairo-Regular", size: 10)!
        txtView_AboutMe.font = font
        txtView_AboutMe.textColor = UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        let attributes = [
            NSForegroundColorAttributeName: UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0),
            NSFontAttributeName : font]
        txtFld_ConfirmPass.attributedPlaceholder = NSAttributedString(string: KCONFIRMPASSWORDSTAR,attributes:attributes)
        txtFld_Password.attributedPlaceholder = NSAttributedString(string: KPASSWORDSTAR,attributes:attributes)
        txtFld_Email.attributedPlaceholder = NSAttributedString(string: KEMAILSTAR,attributes:attributes)
        txtFld_Name.attributedPlaceholder = NSAttributedString(string: KNAMESTAR,attributes:attributes)
        txtFld_MobileNum.attributedPlaceholder = NSAttributedString(string: KMOBILENUMBERSTAR,attributes:attributes)
        txtFld_Dob.attributedPlaceholder = NSAttributedString(string: KDOBSTAR,attributes:attributes)
        print(txtFld_Name.font ?? "")
        
     //  txtView_AboutMe.attributedPlaceholder = NSAttributedString(string: KABOUTME300charactersmax,attributes:attributes)
        
        imagePicker.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        imgView_User.layer.cornerRadius = imgView_User.frame.size.width/2;
        imgView_User.clipsToBounds = true
        imgView_User.layer.borderWidth = 0.0
        imgView_User.layer.borderColor = UIColor.white.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        btnHidePwd.isHidden = true
        let image = UIImage(named: KHidePWD)
        btnShowHidePwdImg.setBackgroundImage(image, for: .normal)
        txtFld_Password.isSecureTextEntry = true
        txtFld_ConfirmPass.isSecureTextEntry = true
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    // MARK:- DatePicker Method
    
    func datePickerValueChanged(sender:UIDatePicker)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        txtFld_Dob.text = formatter.string(from: sender.date)
    }
    
    //MARK:- TextView Delegates
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0) {
           textView.text = nil
             let font = UIFont(name: KCairoRegular, size: 10)!
          textView.font = font
            textView.textColor = UIColor.darkGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0)
            let font = UIFont(name: KCairoRegular, size: 10)!
            textView.font = font

        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let font = UIFont(name: KCairoRegular, size: 14)!
        textView.font = font
        
        let charcter = textView.text?.characters.count
        
        if(charcter == 0)
        {
            let font = UIFont(name: KCairoRegular, size: 10)!
            textView.font = font
            lblCharCount.isHidden = false
            lblCharCount.text = "\(300-1-charcter!)"+" left"
            
        }
        else if (charcter == 1 && text == "")
        {
            let font = UIFont(name: KCairoRegular, size: 10)!
            textView.font = font
            lblCharCount.isHidden = true
            
        }
        else if(charcter == 300 && text == "")
        {
            lblCharCount.text = "\(300+1-charcter!)"+" left"
            return true
        }
        else if(charcter == 300)
        {
            lblCharCount.text = "0"+" left"
            return false
        }
        else if text == ""
        {
            lblCharCount.text = "\(300+1-charcter!)"+" left"
        }
        else
        {
            lblCharCount.text = "\(300-1-charcter!)"+" left"
        }
        return  true
            }
    
    // MARK:- Textfield Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if(textField == txtFld_MobileNum)
        {
            if(string == "")
            {
            }
            else
            {
                if((textField.text?.characters.count)!>9)
                {
                    return  false
                }
            }
        }
        else if(textField == txtFld_Password)
        {
            if(string == "")
            {
            }
            else
            {
                if((textField.text?.characters.count)!>15)
                {
                    return  false
                }
            }
        }
        else if(textField == txtFld_ConfirmPass)
        {
            if(string == "")
            {
            }
            else
            {
                if((textField.text?.characters.count)!>15)
                {
                    return  false
                }
            }
        }
        else if(textField == txtFld_Name)
        {
            if(string == "")
            {
            }
            else if(string == " ")
            {
                if((txtFld_Name.text?.characters.count)!>0)
                {
                let last1 = txtFld_Name.text?.substring(from:(txtFld_Name.text?.index((txtFld_Name.text?.endIndex)!, offsetBy: -1))!)
                if(last1 == " ")
                {
                  return false
                }
                }
                else
                {
                return false
                }
            
            }
            else
            {
                if((textField.text?.characters.count)!>30)
                {
                    return  false
                }
                let aSet = NSCharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz, ").inverted
                let compSepByCharInSet = string.components(separatedBy: aSet)
                let numberFiltered = compSepByCharInSet.joined(separator: "")
                return string == numberFiltered
            }
        }
        else if(textField == txtView_AboutMe)
        {
           
            let charcter = textField.text?.characters.count
            
            if(charcter == 0)
            {
                 lblCharCount.isHidden = false
                 lblCharCount.text = "\(300-1-charcter!)"+" left"
                
            }
            else if (charcter == 1 && string == "")
            {
                lblCharCount.isHidden = true
            
            }
            else if(charcter == 300 && string == "")
            {
            lblCharCount.text = "\(300+1-charcter!)"+" left"
            return true
            }
            else if(charcter == 300)
            {
            lblCharCount.text = "0"+" left"
                return false
            }
            else if string == ""
            {
                 lblCharCount.text = "\(300+1-charcter!)"+" left"
            }
            else
            {
                lblCharCount.text = "\(300-1-charcter!)"+" left"

            }
            
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            
            if(textField == txtFld_Password || textField == txtFld_ConfirmPass) {
                
                return newLength <= 20
            }
         
        }
        else if(textField == txtFld_Email)
        {
            if(string == "")
            {
            }
            else if((textField.text?.characters.count)!>30)
            {
                return  false
            }
        }
 
        
        //  println("While entering the characters this method gets called")
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField:UITextField)
    {
        if(textField == txtFld_Dob)
        {
            
            datePickerView.backgroundColor = UIColor.white
            let curentLocale: NSLocale = NSLocale.current as NSLocale
            datePickerView.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
//            datePickerView.maximumDate = NSDate() as Date
            datePickerView.datePickerMode = UIDatePickerMode.date
            txtFld_Dob.inputView = datePickerView
            datePickerView.maximumDate = (Calendar.current as NSCalendar).date(byAdding: .year, value:-18, to: Date(), options: [])
            datePickerView.minimumDate = (Calendar.current as NSCalendar).date(byAdding: .year, value:-100, to: Date(), options: [])
            
//            let done: UIBarButtonItem = UIBarButtonItem(title: KDone, style: UIBarButtonItemStyle.done, target: self, action: Selector("doneButtonAction"))
            datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
    }
    
    func  textFieldDidEndEditing(_ textField: UITextField)
    {
        if(textField == txtView_AboutMe)
        {
            lblCharCount.isHidden = true
        }
    
        if(textField == txtFld_Dob)
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let curentLocale: NSLocale = NSLocale.current as NSLocale
            formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            txtFld_Dob.text = formatter.string(from: datePickerView.date)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Picker Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        // return genderArr.count
        
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ""
    }
    
    
    
    //MARK:- Response Delegate
    
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
        let apiName : String = Resposnedic[Kapi] as! String
        if(apiName == Kcheck_email_exist)
        {
            let msg : String = Resposnedic[KMessage] as! String
            if(msg == KTheemailhasalreadybeentaken)
            {
                if(UserDefaults.standard.bool(forKey: KIsFb_Login) == true)
                {
                    UserDefaults.standard.set(true, forKey: KIsLogin)
                    var userDic = [String : Any]()
                    userDic = Resposnedic[KUser] as! [String : Any]
                    print(userDic[Krole_type] ?? "")
                    print(userDic[Krole_type] ?? "")
                    User.sharedInstance.email = ""
                    User.sharedInstance.name = ""
                    if let userId = userDic[KuserID]
                    {
                        User.sharedInstance.user_id = "\(userId)"
                        UserDefaults.standard.set("\(userId)", forKey: KuserID)
                        print("\(userId)")
                    }
                    if let role_type = userDic[Krole_type]
                    {
                        User.sharedInstance.role_type = "\(role_type)"
                        print("\(role_type)")
                    }
                    /// move to dashboard
                    
                    self.performSegue(withIdentifier: KmainToUser_Register, sender: self)
                }
                else
                {
                    CommonFunctions.sharedInstance.showAlert(message: msg, delegate: self)
                }
            }
            else
            {
                DispatchQueue.main.async {
                    let rating_RegisterVC =  UIStoryboard(name: KMain, bundle: nil).instantiateViewController(withIdentifier: KRating_RegisterVC) as! Rating_RegisterVC
                    self.navigationController?.pushViewController(rating_RegisterVC, animated: true)
                }
            }
        }
	}
    }
    
    func Failure()
    {
        MBProgressHUD.hide(for: self.view, animated: true)
        CommonFunctions.sharedInstance.showAlert(message: Ksomethingwentwrong, delegate: self)
        print(div)
    }
    
    @IBAction func Back_Action(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- ImagePicker Delegates
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imgView_User.image = chosenImage
        imgView_User.layer.cornerRadius = imgView_User.frame.size.width/2;
        imgView_User.clipsToBounds = true
        imgData = (UIImagePNGRepresentation(chosenImage) as Data?)!
        
        imgView_User.image = CommonFunctions.sharedInstance.cropToBounds(image: imgView_User.image!, width: 200, height: 200)
        
        if (imgView_User.image != nil)
        {
            imgData = UIImageJPEGRepresentation(imgView_User.image!, 0.3)!;
            print(imgData.count)
        }

        dismiss(animated: true, completion: nil)//5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - IBActions
    
    @IBAction func Register_Action(_ sender: Any)
    {
        UserDefaults.standard.set(false, forKey: KIsFb_Login)
        if (txtFld_Name.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
        {
            CommonFunctions.sharedInstance.showAlert(message: "Please fill your name", delegate: self)
        }
        else if (txtFld_Dob.text!.replacingOccurrences(of: " ", with: "").isEmpty)
        {
             CommonFunctions.sharedInstance.showAlert(message: "Please fill your date of birth", delegate: self)
        }
        else if (txtFld_MobileNum.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
        {
            CommonFunctions.sharedInstance.showAlert(message: "Please fill your mobile number", delegate: self)
        }
        else if (txtFld_Email.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
        {
            CommonFunctions.sharedInstance.showAlert(message: "Please fill your email address", delegate: self)
        }
       
        else if (txtFld_Password.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
        {
            CommonFunctions.sharedInstance.showAlert(message: "Please fill your password", delegate: self)
        }
        
        else if (txtFld_ConfirmPass.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
        {
            CommonFunctions.sharedInstance.showAlert(message: "Please fill your confirm password", delegate: self)
        }
        else if ((txtFld_MobileNum.text?.characters.count)!<10)
        {
         CommonFunctions.sharedInstance.showAlert(message: KMobilenumbershouldbebetween012digits, delegate: self)
        }
        else if !(txtFld_Email.text?.lowercased().isValidEmail())!
        {
   CommonFunctions.sharedInstance.showAlert(message: KInvalidEmailAddress, delegate: self)
            
        }
        else if (txtFld_Password.text?.characters.count)!<8
        {
      CommonFunctions.sharedInstance.showAlert(message: KPasswordshouldbeatleast6characters, delegate: self)
            
        }
        else if !(txtFld_Password.text == txtFld_ConfirmPass.text)
        {
      txtFld_ConfirmPass.text = ""
        CommonFunctions.sharedInstance.showAlert(message: KPassworddoesntmatch, delegate: self)
           }
       
        else
        {
            Register_Data.sharedInstance.name = txtFld_Name.text!
            Register_Data.sharedInstance.email = txtFld_Email.text!
          let aboutStr = CommonFunctions.sharedInstance.encode(txtView_AboutMe.text!)
            Register_Data.sharedInstance.aboutMe = aboutStr
            Register_Data.sharedInstance.mobileNumber = txtFld_MobileNum.text!
            Register_Data.sharedInstance.dob = txtFld_Dob.text!
            Register_Data.sharedInstance.password = txtFld_Password.text!
            if (imgData.count > 0)
            {
                Register_Data.sharedInstance.imgData = imgData
            }
            self.CheckEmail()
        }
    }
    
    @IBAction func AddImage_Action(_ sender: Any)
    {
        let pickImageOptions = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: KCamera, style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                CommonFunctions.sharedInstance.showAlert(message: KNocameraavailable, delegate: self)
            }
        })
        
        let deleteAction = UIAlertAction(title: KPhotoLibrary, style: .default , handler: {
            
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: KCancel, style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print(KCancel)
        })
        
        pickImageOptions.addAction(deleteAction)
        pickImageOptions.addAction(saveAction)
        pickImageOptions.addAction(cancelAction)
        self.present(pickImageOptions, animated: true, completion: nil)
        
    }
    
    @IBAction func btnShowPwdAction(_ sender: Any)
    {
        let image = UIImage(named: KShowPWD)
        btnShowHidePwdImg.setBackgroundImage(image, for: .normal)
        btnHidePwd.isHidden = false
        btnShowpwd.isHidden = true
        txtFld_Password.isSecureTextEntry = false
        txtFld_ConfirmPass.isSecureTextEntry = false
    }
    
    @IBAction func btnHidePwdAction(_ sender: Any)
    {
        let image = UIImage(named: KHidePWD)
        btnShowHidePwdImg.setBackgroundImage(image, for: .normal)
        
        btnHidePwd.isHidden = true
        btnShowpwd.isHidden = false
        txtFld_Password.isSecureTextEntry = true
        txtFld_ConfirmPass.isSecureTextEntry = true
    }
    
    @IBAction func FaceBook_Action(_ sender: Any)
    {
        //        UserDefaults.standard.set(true, forKey: KIsFb_Login)
        //        self.view.endEditing(true)
        //        fbLoginManager.logOut()
        //        fbLoginManager = FBSDKLoginManager()
        //        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
        //            if (error == nil){
        //                let fbloginresult : FBSDKLoginManagerLoginResult = result!
        //                if fbloginresult.grantedPermissions != nil {
        //                    if(fbloginresult.grantedPermissions.contains(KEmail))
        //                    {
        //                        self.getFBUserData()
        //                        self.fbLoginManager.logOut()
        //                    }
        //                }
        //            }
        //        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let objFacebook = Facebook()
        objFacebook.getFbData(self, selector: #selector(FBDatResponse))
        
    }
    
    func FBDatResponse(_ dict:AnyObject)  {
        
        print(dict)
        
        if(dict.value(forKeyPath: "response.code") as! String == "200") {
            
            // Save Profile Details Method
            saveProfileDetails(response: dict.value(forKeyPath: "response.result")! as AnyObject)
        }
        else {
            
            print("Unable to Login")
        }
        
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    //MARK:- Save Profile Details
    func saveProfileDetails(response:AnyObject)
    {
        
        let first_name      = String(describing: response.value(forKey: "first_name")!)
        let last_name       = String(describing: response.value(forKey: "last_name")!)
        let email           = String(describing: response.value(forKey: "email")!)
       // let gender          = String(describing: response.value(forKey: "gender")!)
        let imageUrlString  = String(describing: response.value(forKeyPath: "picture.data.url")!)
        
        // Convert profileImage into Data
        let img_url = NSURL.init(string: imageUrlString)
        let imageData : NSData = NSData.init(contentsOf: img_url as! URL)!
        let str64 = imageData.base64EncodedData(options: .lineLength64Characters)
        let image : UIImage = UIImage(data: imageData as Data)!
        self.imgView_User.image = image
        self.imgData = (UIImagePNGRepresentation(image) as Data?)!
        let dataDecoded : Data = Data(base64Encoded: str64, options: .ignoreUnknownCharacters)!

        Register_Data.sharedInstance.name = "\(first_name)"+"\(last_name)"
        Register_Data.sharedInstance.email = "\(email)"
        Register_Data.sharedInstance.aboutMe = ""
        Register_Data.sharedInstance.mobileNumber = ""
        Register_Data.sharedInstance.dob = ""
        Register_Data.sharedInstance.password = ""
        Register_Data.sharedInstance.imgData = dataDecoded
        self.txtFld_Name.text = "\(first_name)"+"\(last_name)"
        self.txtFld_Email.text = "\(email)"
        MBProgressHUD.hide(for: self.view, animated: true)
        
        
    }

    //MARK:- Other Methods
    
    func CheckEmail()
    {
        if Reach.isConnectedToNetwork() == true
        {
            var parmDic = [String : Any]()
            parmDic["email"] = Register_Data.sharedInstance.email
            print(parmDic)
            MBProgressHUD.showAdded(to: self.view, animated: true)
            ServerRequest.sharedInstance.delegate = self
            ServerRequest.sharedInstance.PostApi(urlStr: Kcheck_email_exist, parmDic)
        }
        else
        {
              MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
        }
    }
    
    
    func getFBUserData()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, gender,picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    var fbDataDic : [String:Any] = result as! [String : Any]
                    print(result!)
                    let pictureDic : [String:Any] =  fbDataDic[Kpicture] as! [String : Any]
                    let dataDic : [String:Any] =  pictureDic[Kdata] as! [String : Any]
                    let imgUrlStr = dataDic["url"] as! String
                    let url:NSURL = NSURL(string : imgUrlStr)!
                    let imageData : NSData = NSData.init(contentsOf: url as URL)!
                    let str64 = imageData.base64EncodedData(options: .lineLength64Characters)
                    let image : UIImage = UIImage(data: imageData as Data)!
                    self.imgView_User.image = image
                    self.imgData = (UIImagePNGRepresentation(image) as Data?)!
                    let dataDecoded : Data = Data(base64Encoded: str64, options: .ignoreUnknownCharacters)!
                    Register_Data.sharedInstance.faceBook_id = fbDataDic[Kid] as! String
                    Register_Data.sharedInstance.name = fbDataDic[KName] as! String
                    Register_Data.sharedInstance.email = fbDataDic[KEmail] as! String
                    Register_Data.sharedInstance.aboutMe = ""
                    Register_Data.sharedInstance.mobileNumber = ""
                    Register_Data.sharedInstance.dob = ""
                    Register_Data.sharedInstance.password = ""
                    Register_Data.sharedInstance.imgData = dataDecoded
                    self.txtFld_Name.text = fbDataDic[KName] as? String
                    self.txtFld_Email.text = fbDataDic[KEmail] as? String
                   // self.txtFld_Name.text = fbDataDic["name"] as? String
                   // self.txtFld_Name.text = fbDataDic["name"] as? String
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            })
        }
    }
    
    //MARK: - Status Bar Delegate
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
}
