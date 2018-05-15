//
//  RegisterEditVC.swift
//  ROCKSTARS
//
//  Created by Amandeep Kaur on 5/22/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD
import IQKeyboardManagerSwift


class RegisterEditVC: UIViewController,UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate,ResponseProtcol,UITextViewDelegate {

    //MARK: - Variables
    
    var imagePicker = UIImagePickerController()
    var imgData = Data()
    
     //MARK: - IBOutlets
    
    @IBOutlet var imgView_User: UIImageView!
    @IBOutlet var txtView_AboutMe: UITextView!
    @IBOutlet var lblCharCount: UILabel!
    @IBOutlet var txtFld_Email: B68UIFloatLabelTextField!
    @IBOutlet var txtFld_Name: B68UIFloatLabelTextField!
    @IBOutlet var txtFld_Dob: B68UIFloatLabelTextField!
    @IBOutlet var txtFld_MobileNum: B68UIFloatLabelTextField!

      override func viewDidLoad() {
        super.viewDidLoad()
        
        let skillArr = Register_Data.sharedInstance.arrSkills
        var selectedSkill_IDStr = ""
        for k in 0..<skillArr.count
        {
            let str = skillArr[k][Kid] as! Int
            print(selectedSkill_IDStr)
            if(selectedSkill_IDStr.characters.count == 0)
            {
                selectedSkill_IDStr = "\(selectedSkill_IDStr)" + "\(str)"
            }
            else
            {
                selectedSkill_IDStr = "\(selectedSkill_IDStr)" + "," + "\(str)"
            }
        }
        //}
        print(selectedSkill_IDStr)
        Register_Data.sharedInstance.skills_Selected = selectedSkill_IDStr
        print(imgData)
        IQKeyboardManager.sharedManager().enable = true
        let font = UIFont(name: KCairoRegular, size: 10)!
        lblCharCount.isHidden = true
          txtView_AboutMe.font = font
        txtView_AboutMe.textColor = UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        let attributes = [
            NSForegroundColorAttributeName: UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0),
            NSFontAttributeName : font]
        txtFld_Name.text = Register_Data.sharedInstance.name
        txtFld_Email.text = Register_Data.sharedInstance.email
        print(Register_Data.sharedInstance.dob)
        txtFld_Dob.text = Register_Data.sharedInstance.dob
        txtFld_MobileNum.text = Register_Data.sharedInstance.mobileNumber
        let aboutStr = CommonFunctions.sharedInstance.decode(Register_Data.sharedInstance.aboutMe
)
        txtView_AboutMe.text = aboutStr
        if(txtView_AboutMe.text.characters.count>0)
        {
            let font = UIFont(name: KCairoRegular, size: 14)!
            txtView_AboutMe.font = font
            txtView_AboutMe.textColor = UIColor.darkGray
        }
        
            if let url = URL.init(string: Register_Data.sharedInstance.imgUrl) {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                DispatchQueue.global(qos: .background).async {
                    let imageData : NSData? = NSData.init(contentsOf: url as URL)
                    if(!(imageData?.length == 0) && imageData != nil)
                    {
                        DispatchQueue.main.async {
                            self.imgData = imageData as! Data
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                  }
                }
                imgView_User.layer.cornerRadius = imgView_User.frame.size.width / 2
                imgView_User.clipsToBounds = true
                imgView_User.layer.borderWidth = 0.0
               // imgView_User.layer.borderColor = UIColor.white.cgColor

                imgView_User.setShowActivityIndicator(true)
                imgView_User.setIndicatorStyle(.white)
                //imgView_User.sd_setImage(with: url)
                imgView_User.sd_setImage(with: url, placeholderImage: UIImage(named: "img"))
            }
      
       
        txtFld_Email.attributedPlaceholder = NSAttributedString(string: "EMAIL *",attributes:attributes)
        txtFld_Name.attributedPlaceholder = NSAttributedString(string: "NAME *",attributes:attributes)
        txtFld_MobileNum.attributedPlaceholder = NSAttributedString(string: "MOBILE NUMBER *",attributes:attributes)
        txtFld_Dob.attributedPlaceholder = NSAttributedString(string: "DOB *",attributes:attributes)
        
       // txtView_AboutMe.attributedPlaceholder = NSAttributedString(string: "ABOUT ME (300 characters max.)",attributes:attributes)
        
        
    

        
        imagePicker.delegate = self
        //Register_Data.sharedSampleSingletonClass()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
//        imgView_User.layer.cornerRadius = imgView_User.frame.size.width/2;
//        imgView_User.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    // MARK:- DatePicker Method
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        
        
        // dateLabel.text = formatter.string(from: sender.date)
        
        // dateFormatter.dateStyle = DateFormatter.Sty
        
        //  dateFormatter.timeStyle = DateFormatter.Style.NoStyle
        
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
            lblCharCount.isHidden = false
            lblCharCount.text = "\(300+1-charcter!)"+" left"
        }
        else
        {
            lblCharCount.isHidden = false
            lblCharCount.text = "\(300-1-charcter!)"+" left"
         }
         return  true
    }

    // MARK:- Textfield Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           
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
            if(string == "")
            {
            }
            else
            {
                
                if((textField.text?.characters.count)!>300)
                {
                    return  false
                }
               
            }
            
            
            
        }
        else if(textField == txtFld_Email)
        {
            
            if(string == "")
            {
            }
            else
            {
                
                if((textField.text?.characters.count)!>30)
                {
                    return  false
                }
            }
        }
      //  else if(textField == ven)
        
        
        //  println("While entering the characters this method gets called")
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField:UITextField)
    {
        
        if(textField == txtFld_Dob)
        {
             let datePickerView:UIDatePicker = UIDatePicker()
            let curentLocale: NSLocale = NSLocale.current as NSLocale
            datePickerView.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            datePickerView.backgroundColor = UIColor.white
            //            datePickerView.maximumDate = NSDate() as Date
            datePickerView.datePickerMode = UIDatePickerMode.date
            txtFld_Dob.inputView = datePickerView
            datePickerView.maximumDate = (Calendar.current as NSCalendar).date(byAdding: .year, value:-18, to: Date(), options: [])
            datePickerView.minimumDate = (Calendar.current as NSCalendar).date(byAdding: .year, value:-100, to: Date(), options: [])

            datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
   
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        //delegate method
        textField.resignFirstResponder()
        return true
    }
    func  textFieldDidEndEditing(_ textField: UITextField)
    {
        if(textField == txtView_AboutMe)
        {
            lblCharCount.isHidden = true
        }
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
        
        return "wewq"
    }
    
    @IBAction func SkillsAction(_ sender: Any)
    {
        let UpdateSkillsVC =  UIStoryboard(name: KDashboardUser, bundle: nil).instantiateViewController(withIdentifier: "UpdateSkillsVC") as! UpdateSkillsVC
        UpdateSkillsVC.user_ID = UserDefaults.standard.value(forKey: KuserID) as! String
        self.navigationController?.pushViewController(UpdateSkillsVC, animated: true)
    }
    @IBAction func RegisterAction(_ sender: Any) {
        // UserDefaults.standard.set(false, forKey: "IsFb_Login")
        
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
        else if ((txtFld_MobileNum.text?.characters.count)!<10)
        {
            
            CommonFunctions.sharedInstance.showAlert(message: KMobilenumbershouldbebetween012digits, delegate: self)
        }
        else if !(txtFld_Email.text?.lowercased().isValidEmail())!
        {
            
            // txtFld_Email.text = ""
            CommonFunctions.sharedInstance.showAlert(message: KInvalidEmailAddress, delegate: self)
            
        }
            
        else
        {
            Register_Data.sharedInstance.name = txtFld_Name.text!
            Register_Data.sharedInstance.email = txtFld_Email.text!
            let aboutStr = CommonFunctions.sharedInstance.encode(txtView_AboutMe.text!)
            Register_Data.sharedInstance.aboutMe = aboutStr
            Register_Data.sharedInstance.mobileNumber = txtFld_MobileNum.text!
            Register_Data.sharedInstance.dob = txtFld_Dob.text!
            // Register_Data.sharedInstance.password = txtFld_Password.text!
            if (imgData.count > 0)
            {
                Register_Data.sharedInstance.imgData = imgData
            }
            
            editProfileAPI()
            }
        
    }
 
    //MARK: - Response Delegates
    
    func Response(Resposnedic: [String:Any])
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
        let apiName : String = Resposnedic["api"] as! String
        
        if(apiName == "check_email_exist")
        {
            
            let msg : String = Resposnedic["message"] as! String
                  if(msg == "The email has already been taken.")
            {
                
                if(UserDefaults.standard.bool(forKey: "IsFb_Login") == true)
                {
                self.performSegue(withIdentifier: "mainToUser_Register", sender: self)
                CommonFunctions.sharedInstance.showAlert(message: "Logged in successfully", delegate: self)
                }
                else
                {
                CommonFunctions.sharedInstance.showAlert(message: msg, delegate: self)
                }
            }
            else
            {
                 editProfileAPI()
            }
            }
        else if(apiName == Kedit_profile)
        {
            
            let msg : String = Resposnedic[KMessage] as! String
            
            let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
             let OKAction = UIAlertAction(title: OK, style: .default) { (action:UIAlertAction) in
                 self.navigationController?.popViewController(animated: true)
            }
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
          }
	}
    }
    
    func Failure()
    {
          MBProgressHUD.hide(for: self.view, animated: true)
        CommonFunctions.sharedInstance.showAlert(message: Ksomethingwentwrong, delegate: self)
           print(div)
    }
    
    @IBAction func RemoveImgAction(_ sender: Any)
    {
        imgView_User.image = UIImage(named: "img")
        self.imgData = Data()
        
    }
    
    
    @IBAction func Back_Action(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func AddImage_Action(_ sender: Any)
    {
        let pickImageOptions = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "Camera", style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                CommonFunctions.sharedInstance.showAlert(message: "No camera available", delegate: self)
            }
        })
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default , handler: {
            
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default , handler: {
            
            (alert: UIAlertAction!) -> Void in
            self.imgView_User.image = UIImage(named: "img")
            self.imgData = Data()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        pickImageOptions.addAction(saveAction)
        pickImageOptions.addAction(photoAction)
         pickImageOptions.addAction(deleteAction)
        pickImageOptions.addAction(cancelAction)
        self.present(pickImageOptions, animated: true, completion: nil)
        
    }
    //MARK:- Other Action
    
    func editProfileAPI()
    {
        
 
        if Reach.isConnectedToNetwork() == true
        {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            let dict : [String:Any] = ["user_id":Register_Data.sharedInstance.userID,"role_type" :Register_Data.sharedInstance.roleType,"name" :Register_Data.sharedInstance.name,"mobile" :Register_Data.sharedInstance.mobileNumber,"dob" :Register_Data.sharedInstance.dob,"about_me" :Register_Data.sharedInstance.aboutMe,"cocktail_knowledge" :Register_Data.sharedInstance.rating_Time,"spirit_knowledge" :Register_Data.sharedInstance.rating_KeepSellin,/*"image" :Register_Data.sharedInstance.imgData,*/"skills" : Register_Data.sharedInstance.skills_Selected]
            MBProgressHUD.showAdded(to: self.view, animated: true)
               ServerRequest.sharedInstance.delegate = self
            ServerRequest.sharedInstance.UploadImageWithParam(urlStr: "editProfile", parameters: dict, imgData: imgData)

        }
        else
        {
              MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: "Internet connection lost.", delegate: self)
        }
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
        imgView_User.layer.borderWidth = 0.0
        imgView_User.layer.borderColor = UIColor.white.cgColor
        
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

 
    
    func CheckEmail()
    {
        if Reach.isConnectedToNetwork() == true
        {
            // Register_Data.sharedInstance.email = txtFld_Email.text as String
            
            //   MBProgressHUD.showAdded(to: self.view, animated: true)
            
            var parmDic = [String : Any]()
            
            //   var data = NSData()
            
            parmDic["email"] = Register_Data.sharedInstance.email
            
            
            
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            ServerRequest.sharedInstance.delegate = self
            ServerRequest.sharedInstance.PostApi(urlStr: "check_email_exist", parmDic)
        }
        else
        {
              MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: "Internet connection lost.", delegate: self)
        }
        
        
    }
    
   
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
}
