//
//  RegisterVenueVC.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/11/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import MBProgressHUD
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Alamofire

class RegisterVenueVC: UIViewController,UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate,ResponseProtcol,UITableViewDelegate,UITableViewDataSource {
	
	//MARK: - IBOutlets
	
	@IBOutlet var imgView_User: UIImageView!
	@IBOutlet weak var btnHidePwd: UIButton!
	@IBOutlet weak var btnShowPwd: UIButton!
	@IBOutlet weak var btnShowHidePwdImg: UIButton!
	@IBOutlet var txtFld_PostCode: UITextField!
	@IBOutlet var txtFld_Venue: UITextField!
	@IBOutlet var txtFld_buildingNo: UITextField!
	@IBOutlet var txtFld_ConfirmPass: B68UIFloatLabelTextField!
	@IBOutlet var txtFld_Password: B68UIFloatLabelTextField!
	@IBOutlet var txtFld_Email: B68UIFloatLabelTextField!
	@IBOutlet var txtFld_Name: B68UIFloatLabelTextField!
	@IBOutlet var txtFld_VenueAddress: UITextField!
	@IBOutlet var table_Places: UITableView!
	@IBOutlet var txtFld_MobileNum: B68UIFloatLabelTextField!
	
	//MARK: - Variables
	
	var strlat = ""
	var strlng = ""
	var locationArr = [AnyObject]()
	var locationArrID = [AnyObject]()
	var timer = Timer()
	var imagePicker = UIImagePickerController()
	var imgData = Data()
	var showTable = Bool()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		showTable = true
		table_Places.isHidden = true
		let font = UIFont(name: KCairoRegular, size: 10)!
		let attributes = [
			NSForegroundColorAttributeName: UIColor(red: 101.0/255.0, green: 23.0/255.0, blue: 101.0/255.0, alpha: 1.0),
			NSFontAttributeName : font]
		txtFld_PostCode.attributedPlaceholder = NSAttributedString(string: KPOSTCODESTAR,attributes:attributes)
		txtFld_Venue.attributedPlaceholder = NSAttributedString(string: KVENUESTAR,attributes:attributes)
		//  txtFld_buildingNo.attributedPlaceholder = NSAttributedString(string: KBUILIDING,attributes:attributes)
		txtFld_VenueAddress.attributedPlaceholder = NSAttributedString(string: KSTREETADDRESSSTAR,attributes:attributes)
		txtFld_ConfirmPass.attributedPlaceholder = NSAttributedString(string: KCONFIRMPASSWORDSTAR,attributes:attributes)
		txtFld_Password.attributedPlaceholder = NSAttributedString(string: KPASSWORDSTAR,attributes:attributes)
		txtFld_Email.attributedPlaceholder = NSAttributedString(string: KEMAILSTAR,attributes:attributes)
		txtFld_Name.attributedPlaceholder = NSAttributedString(string: KNAMESTAR,attributes:attributes)
		txtFld_MobileNum.attributedPlaceholder = NSAttributedString(string: KMOBILENUMBERSTAR,attributes:attributes)
		imagePicker.delegate = self
		
		// Do any additional setup after loading the view.
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
	
	
	override func viewWillAppear(_ animated: Bool) {
		btnHidePwd.isHidden = true
		let image = UIImage(named: KHidePWD)
		btnShowHidePwdImg.setBackgroundImage(image, for: .normal)
		txtFld_Password.isSecureTextEntry = true
		txtFld_ConfirmPass.isSecureTextEntry = true
		UIApplication.shared.statusBarStyle = .lightContent
	}
	
	// MARK:- Textfield Delegate
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		if(textField == txtFld_PostCode)
		{
			print(textField.text ?? "")
			
			if(textField.text?.characters.count == 1) && string == ""
			{
				if(timer.isValid) {
					timer.invalidate()
				}
				locationArr = [AnyObject]()
				locationArrID = [AnyObject]()
				table_Places.reloadData()
				table_Places.isHidden = true
			}
			else if((textField.text?.characters.count)! > 0) && string == ""
			{
				var newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
				
				newString = newString.replacingOccurrences(of: " ", with: "")
				
				if(timer.isValid)
				{
					timer.invalidate()
				}
				let dict : [String:String] = [Kplace:newString]
				timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(GetPlaces), userInfo:dict , repeats: false)
			}
			else
			{
				let aSet = NSCharacterSet(charactersIn:KCharecterSetSpace).inverted
				let compSepByCharInSet = string.components(separatedBy: aSet)
				let numberFiltered = compSepByCharInSet.joined(separator: "")
				if(string == numberFiltered)
				{
					var newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
					newString = newString.replacingOccurrences(of: " ", with: "")
					if(timer.isValid) {
						timer.invalidate()
					}
					let dict : [String:String] = [Kplace:newString]
					timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(GetPlaces), userInfo:dict , repeats: false)
				}
				
				return string == numberFiltered                //tableSearch.isHidden = false
			}
			return true
		}
		else if(textField == txtFld_MobileNum)
		{
			if(string != "")
			{
				if((textField.text?.characters.count)!>9)
				{
					return  false
				}
			}
		}
		else if(textField == txtFld_Password)
		{
			if(string != "")
			{
				if((textField.text?.characters.count)!>15)
				{
					return  false
				}
			}
		}
		else if(textField == txtFld_ConfirmPass)
		{
			if(string != "")
			{
				if((textField.text?.characters.count)!>15)
				{
					return  false
				}
			}
		}
		else if(textField == txtFld_ConfirmPass)
		{
			if(string != "")
			{
				if((textField.text?.characters.count)!>15)
				{
					return  false
				}
			}
		}
			
		else if(textField == txtFld_Venue)
		{
			
			if(string != "")
			{
				if((textField.text?.characters.count)!>30)
				{
					return  false
				}
			}
		}
		else if(textField == txtFld_PostCode)
		{
			if(string != "")
			{
				if((textField.text?.characters.count)!>4)
				{
					return  false
				}
				
			}
		}
		else if(textField == txtFld_Email)
		{
			if(string != "")
			{
				if((textField.text?.characters.count)!>40)
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
				let aSet = NSCharacterSet(charactersIn:KCharecterSetSpace).inverted
				let compSepByCharInSet = string.components(separatedBy: aSet)
				let numberFiltered = compSepByCharInSet.joined(separator: "")
				return string == numberFiltered
			}
		}
		guard let text = textField.text else { return true }
		let newLength = text.characters.count + string.characters.count - range.length
		
		if(textField == txtFld_Password || textField == txtFld_ConfirmPass) {
			
			return newLength <= 20
		}
		
		return true;
	}
	
	func textFieldDidBeginEditing(_ textField:UITextField)
	{
		if(textField == txtFld_PostCode)
		{
			showTable = true
			IQKeyboardManager.sharedManager().enable = false
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		//delegate method
		textField.resignFirstResponder()
		return true
	}
	func  textFieldDidEndEditing(_ textField: UITextField) {
		if(textField == txtFld_PostCode){
			if((txtFld_PostCode.text?.characters.count)!>0)
			{
				print(txtFld_PostCode.text ?? "")
					 if (strlat.replacingOccurrences(of: " ", with: "").isEmpty || strlng.replacingOccurrences(of: " ", with: "").isEmpty)
					{
			      	txtFld_PostCode.text = ""
				   }
				// if !(txtFld_PostCode.text?.isValidPostcode())!
				// {
				// CommonFunctions.sharedInstance.showAlert(message: KPostcode, delegate: self)
				//  txtFld_PostCode.text = ""
				// }
			}
		}
		else if(textField == txtFld_PostCode)
		{
			
			IQKeyboardManager.sharedManager().enable = true
		}
	}
	
	// MARK: - Picker Delegate
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 2
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return ""
	}
	//MARK: - Other Methods
	func GetPlaces(timer:Timer)
	{
		let userInfo : [String:String] = timer.userInfo as! [String:String]
		let strPlace : String = userInfo[Kplace]!
		
		let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(strPlace)&key=\(KGoogleKey)&components=country:au")
		//  let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(strPlace)&key=\(KGoogleKey)")
		
		print(url ?? "")
		
		let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
			// 3
			do {
				if data != nil{
					let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as!  NSDictionary
					print(dic)
					var arr = NSArray()
					arr = dic.value(forKey: Kpredictions) as! NSArray
					self.locationArr = [AnyObject]()
					self.locationArrID = [AnyObject]()
					if (arr.count >  0)
					{
						for dic in arr
						{
							print(dic)
							
							self.locationArr.append((dic as! NSDictionary).value(forKey: Kdescription) as AnyObject)
							self.locationArrID.append((dic as! NSDictionary).value(forKey: Kplace_id) as AnyObject)
						}
						print(self.locationArr)
						print(self.locationArrID)
						DispatchQueue.main.async {
							if(self.showTable == true)
							{
								self.table_Places.isHidden = false
								self.table_Places.reloadData()
							}
						}
					}
					else
					{
						DispatchQueue.main.async {
							
							self.strlat = ""
							self.strlng = ""
							self.table_Places.isHidden = true
							self.table_Places.reloadData()
						}
						
					}
					print(self.locationArr)
					print(self.locationArrID)
				}
				else {
					
					print("no data")
				}
			}catch {
				print("Error")
			}
		}
		// 5
		task.resume()
	}
	
	func GetCityName(lat:String,lng:String)
	{
		let lat = Double(lat)
		let lon = Double(lng)
		let longitude :CLLocationDegrees = lon!
		let latitude :CLLocationDegrees = lat!
		
		let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
		print(location)
		
		CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
			print(location)
			
			if error != nil {
				MBProgressHUD.hide(for: self.view, animated: true)
				print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
				return
			}
			
			if ((placemarks?.count)!) > 0 {
				let pm = (placemarks?[0])! as CLPlacemark
				print(pm.locality ?? "")
				// print(pm.placemarks)
				print(pm.country ?? "")
				print(pm.locality ?? "")
				print(pm.region ?? "")
				print(pm.subLocality
					?? "")
				print(pm.name
					?? "")
				print(pm.location
					?? "")
				print(pm.location
					?? "")
				let dic  = pm.addressDictionary as! [String:Any]
				print(dic)
				print("ZIP")
				
				var cityStr = ""
				var stateStr = ""
				var zipStr = ""
				var streetStr = ""
				
				if let city = dic["City"]
				{
					cityStr = city as! String
				}
				if let State = dic["State"]
				{
					stateStr = State as! String
				}
				if let ZIP = dic["ZIP"]
				{
					zipStr = ZIP as! String
				}
				
				print(pm.name!)
				print(pm.subLocality ?? "helo")
				
				if let Street = dic["Thoroughfare"]
				{
					streetStr = Street as! String
					//self.txtFld_VenueAddress.text = streetStr
				}
				else if let Street = dic["Street"]
				{
					streetStr = Street as! String
					//self.txtFld_VenueAddress.text = streetStr
				}
				else  if let sublocality = pm.subLocality,let name = pm.name
				{
					//self.txtFld_VenueAddress.text = "\(name)" + ", " + "\(sublocality)"
				}
				else if let name = pm.name
				{
					//self.txtFld_VenueAddress.text = "\(name)"
				}
				else
				{
					//self.txtFld_VenueAddress.text = "\(pm.subLocality!)"
				}
				
				self.txtFld_PostCode.text = cityStr + ", " + stateStr + ", " + zipStr
				MBProgressHUD.hide(for: self.view, animated: true)
			}
			else {
				MBProgressHUD.hide(for: self.view, animated: true)
				print("Problem with the data received from geocoder")
			}
		})
	}
	
	// MARK: - IBActions
	
	@IBAction func Register_Action(_ sender: Any)
	{
		IQKeyboardManager.sharedManager().enable = true
		self.view.endEditing(true)
		if (txtFld_Name.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
		{
			CommonFunctions.sharedInstance.showAlert(message: KPleasefillyourname, delegate: self)
		}
		else if (txtFld_Venue.text!.replacingOccurrences(of: " ", with: "").isEmpty)
		{
			CommonFunctions.sharedInstance.showAlert(message: KPleasefillyourvenue, delegate: self)
		}
			//  else if (txtFld_buildingNo.text!.replacingOccurrences(of: " ", with: "").isEmpty)
			//  {
			//       CommonFunctions.sharedInstance.showAlert(message: KPleasefillyourbuilding, delegate: self)
			//  }
		else if (txtFld_VenueAddress.text!.replacingOccurrences(of: " ", with: "").isEmpty)
		{
			CommonFunctions.sharedInstance.showAlert(message: KPleasefillyourstreetaddress, delegate: self)
		}
		else if (txtFld_PostCode.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
		{
			CommonFunctions.sharedInstance.showAlert(message: KPleasefillyourpostcode, delegate: self)
		}
		else if (txtFld_MobileNum.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
		{
			CommonFunctions.sharedInstance.showAlert(message: KPleasefillyourmobilenumber, delegate: self)
		}
		else if (txtFld_Email.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
		{
			CommonFunctions.sharedInstance.showAlert(message: KPleaseFillYourEmailAddress, delegate: self)
		}
			
		else if (txtFld_Password.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
		{
			CommonFunctions.sharedInstance.showAlert(message: KPleaseFillYourPassword, delegate: self)
		}
			
		else if (txtFld_ConfirmPass.text?.replacingOccurrences(of: " ", with: "").isEmpty)!
		{
			CommonFunctions.sharedInstance.showAlert(message: KPleasefillyourconfirmpassword, delegate: self)
		}
		else if ((txtFld_MobileNum.text?.characters.count)!<10)
		{
			
			CommonFunctions.sharedInstance.showAlert(message: KMobilenumbershouldbebetween012digits, delegate: self)
		}
		else if !(txtFld_Email.text?.lowercased().isValidEmail())!
		{
			//txtFld_Email.text = ""
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
			// else if !(txtFld_PostCode.text?.isValidPostcode())!
			///{
			//    CommonFunctions.sharedInstance.showAlert(message: KPostcode, delegate: self)
			// }
		else if (strlat.replacingOccurrences(of: " ", with: "").isEmpty || strlng.replacingOccurrences(of: " ", with: "").isEmpty)
		{
			//txtFld_VenueAddress.text = ""
			txtFld_PostCode.text = ""
			CommonFunctions.sharedInstance.showAlert(message: KPleasefillValidlocation, delegate: self)
		}
		else
		{
			if Reach.isConnectedToNetwork() == true
			{
				var parmDic = [String : Any]()
				
				parmDic[KEmail] = txtFld_Email.text
				parmDic[KPassword] = txtFld_Password.text
				parmDic[Krole_type] = "3"
				parmDic[KMobile] = txtFld_MobileNum.text
				parmDic[Kvenue] = txtFld_Venue.text
				parmDic[Kpostcode] = txtFld_PostCode.text
				parmDic[KName] = txtFld_Name.text
				parmDic[Klatitude] = strlat
				parmDic[Klongitude] = strlng
				parmDic[Klocation] = txtFld_VenueAddress.text
				
				//parmDic["building_number"] = txtFld_buildingNo.text
				
				print(parmDic)
				if (imgData.count > 0)
				{
					Register_Data.sharedInstance.imgData = imgData
				}
				parmDic[Kdevice_type] = Kiphone
				parmDic[Kdevice_token] = defaults.object(forKey: Kdevice_token) as! String
				MBProgressHUD.showAdded(to: self.view, animated: true)
				print(Register_Data.sharedInstance.imgData)
				ServerRequest.sharedInstance.delegate = self
				ServerRequest.sharedInstance.delegate = self
				ServerRequest.sharedInstance.UploadImageWithParam(urlStr: Kregister, parameters: parmDic, imgData: imgData)
			}
			else
			{
				MBProgressHUD.hide(for: self.view, animated: true)
				CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
			}
		}
	}
	
	@IBAction func AddImage_Action(_ sender: Any)
	{
		let pickImageOptions = UIAlertController(title: nil, message: KChooseOption, preferredStyle: .actionSheet)
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
		btnShowPwd.isHidden = true
		txtFld_Password.isSecureTextEntry = false
		txtFld_ConfirmPass.isSecureTextEntry = false
	}
	
	@IBAction func btnHidePwdAction(_ sender: Any)
	{
		let image = UIImage(named: KHidePWD)
		btnShowHidePwdImg.setBackgroundImage(image, for: .normal)
		
		btnHidePwd.isHidden = true
		btnShowPwd.isHidden = false
		txtFld_Password.isSecureTextEntry = true
		txtFld_ConfirmPass.isSecureTextEntry = true
	}
	
	@IBAction func Back_Action(_ sender: Any)
	{
		IQKeyboardManager.sharedManager().enable = true
		self.navigationController?.popViewController(animated: true)
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
		else if(msg == KTheemailhasalreadybeentaken)
		{
			let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
			let OKAction = UIAlertAction(title:OK, style: .default) { (action:UIAlertAction) in
			}
			alertController.addAction(OKAction)
			self.present(alertController, animated: true, completion:nil)
		}
		else if(msg == KTheemailmustbeavalidemailaddress)
		{
			let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
			let OKAction = UIAlertAction(title:OK, style: .default) { (action:UIAlertAction) in
			}
			alertController.addAction(OKAction)
			self.present(alertController, animated: true, completion:nil)
		}
		else
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
				UserDefaults.standard.set(User.sharedInstance.role_type, forKey: Krole_type)
				
				print("\(role_type)")
			}
			let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
			let OKAction = UIAlertAction(title: OK, style: .default)
			{ (action:UIAlertAction) in
				// self.performSegue(withIdentifier: KVenuToUserDashboard, sender: self)
				KappDelegate.InitilizeVenueHome()
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
		print()
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
	// MARK: - Table View
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return locationArr.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		var cell = tableView.dequeueReusableCell(withIdentifier: cCELL) as UITableViewCell!
		if !(cell != nil)
		{
			cell = UITableViewCell(style:.default, reuseIdentifier: cCELL)
		}
		cell?.textLabel!.text = locationArr[indexPath.row] as? String
		cell?.textLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)
		return cell!
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		return 40;
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		showTable = false
			if(timer.isValid) {
			timer.invalidate()
		}
		print(locationArr)
		table_Places.isHidden = true
		txtFld_PostCode.resignFirstResponder()
		MBProgressHUD.showAdded(to: self.view, animated: true)
		//		let str = locationArr[indexPath.row] as! String
		//		let strArr = str.components(separatedBy: ",")
		//		var addressStr = ""
		//		if strArr.count  == 3 || strArr.count > 3
		//		{
		//			for i in 0..<strArr.count
		//			{
		//				if(i != 0)
		//				{
		//					print(strArr)
		//					print(addressStr)
		//					addressStr = (i==1) ? strArr[i] : (addressStr + ", " + strArr[i])
		//					print(addressStr)
		//				}
		//			}
		//		}
		//		else if strArr.count  == 2
		//		{
		//		addressStr = strArr[0] + ", " + strArr[1]
		//		}
		//		else
		//		{
		//		addressStr = strArr[0]
		//		}
		//		//address1  = strArr[0]
		//		txtFld_PostCode.text = addressStr
		
		
		CommonFunctions.sharedInstance.findCoordinates(placeID: (locationArrID[indexPath.row] as? String)!) { (address,lat,lng) -> (Void) in
			
			DispatchQueue.main.async
				{
					self.strlat = lat
					self.strlng = lng
					if(address != "")
					{
						let strArr = address.components(separatedBy: ",")
						var addressStr = ""
						if strArr.count  == 3 || strArr.count > 3
						{
							for i in 0..<strArr.count
							{
								if(i != 0)
								{
									print(strArr)
									print(addressStr)
									addressStr = (i==1) ? strArr[i] : (addressStr + ", " + strArr[i])
									print(addressStr)
								}
							}
						}
						else if strArr.count  == 2
						{
							addressStr = strArr[0] + ", " + strArr[1]
						}
						else
						{
							addressStr = strArr[0]
						}
						self.txtFld_PostCode.text = addressStr
						MBProgressHUD.hide(for: self.view, animated: true)
					}
					else
					{
						//self.txtFld_VenueAddress.text = ""
						self.txtFld_PostCode.text = ""
						CommonFunctions.sharedInstance.showAlert(message: KPleasefillValidlocation, delegate: self)
						MBProgressHUD.hide(for: self.view, animated: true)
						
					}
			}
		}
	}
	
	func getAddress(lat : String, lng : String)
	{
		let lattitue = Double(lat)
		let longitude = Double(lng)
		
		//  http://maps.googleapis.com/maps/api/geocode/json?latlng=-37.8162175,144.9640682&sensor=true
		let url = NSURL(string: "http://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(lng)&sensor=true")
		
		let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
			
			do {
				if data != nil{
					let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as!  NSDictionary
					print(dic)
					
					var address1    = ""
					var address2    = ""
					var Addstr = ""
					if  let AddArr = dic.value(forKey:"results")
					{
						let  AddressArr  =  AddArr as! [[String:Any]]
						if let Adddic : [String:Any] = AddressArr[0]
						{
							let Addressdic = Adddic
							if let Adstr = Addressdic["formatted_address"]
							{
								Addstr = Adstr as! String
								
							}
							
						}
						
					}
					
					print(Addstr ?? "" )
					
					let strArr = Addstr.components(separatedBy: ",")
					address1  = strArr[0]
					for i in 0...strArr.count-1
					{
						print(i)
						if i == 1
						{
							address2 = address2 + strArr[i]
						}
						else  if i == 0
						{
							// address2 = address2 + strArr[i]
						}
						else
						{
							address2 = address2 + ", " + strArr[i]
							
						}
						
					}
					print(address2)
					print(address1)
					
					DispatchQueue.main.async {
						//self.txtFld_VenueAddress.text = address1
						self.txtFld_PostCode.text = address2
						MBProgressHUD.hide(for: self.view, animated: true)
					}
					
					
					
					//  let latStr = dic3["lat"]
					//  let lngStr = dic3["lng"]
					// print(latStr ?? "" )
					// print(lngStr ?? "" )
					// let strlat = "\(String(describing: latStr))"
					//  let strlng = "\(String(describing: lngStr))"
					//  print(strlat ?? "" )
					//   print(strlng ?? "" )
					//   completionHandler("\(latStr!)","\(lngStr!)")
					
				}
				else {
					
					print("Error", error ?? "")
					//  completionHandler("","")
					
				}
			}catch {
				Swift.print(KError)
			}
		}
		task.resume()
		/////////////////////
		//        let address = placeID
		//        let geocoder = CLGeocoder()
		//        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
		//            if((error) != nil){
		//                print("Error", error ?? "")
		//                completionHandler("","")
		//            }
		//            if let placemark = placemarks?.first {
		//                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
		//                print("lat", coordinates.latitude)
		//                print("long", coordinates.longitude)
		//                completionHandler("\(coordinates.latitude)","\(coordinates.longitude)")
		//            }
		//        })
	}
	
	//    func getAddress(lat : String, lng : String){
	//
	//       // let infoWindow = Bundle.mainBundle().loadNibNamed("InfoWindowCurrent", owner: self, options: nil)[0] as! InfoWindowCurrent
	//        let geocoder = GMSGeocoder()
	//        let coordinate = CLLocationCoordinate2DMake(Double(lat)!,Double(lng)!)
	//
	//
	//        var currentAddress = String()
	//
	//        geocoder.reverseGeocodeCoordinate(coordinate)
	//        { response , error in
	//            if let address = response?.firstResult()
	//            {
	//                 if let address1 = response?.results()
	//                 {
	//                    print(address1)
	//
	//                }
	//              //  print(response)
	//                print(address)
	//
	//                var cityStr = ""
	//                var stateStr = ""
	//                var zipStr = ""
	//                var streetStr = ""
	//               // let lines = address.lines! as [String]
	//                if let city = address.locality
	//                {
	//                    cityStr = "\(city)"
	//                }
	//                if let State = address.administrativeArea
	//                {
	//                    stateStr = "\(State)"
	//                }
	//                if let ZIP = address.postalCode
	//                {
	//                    zipStr = "\(ZIP)"
	//                }
	//
	//              //  print(pm.name!)
	//               // print(pm.subLocality ?? "helo")
	//
	//                if let Street = address.thoroughfare
	//                {
	//                    streetStr = "\(Street)"
	//                    self.txtFld_VenueAddress.text = streetStr
	//                }
	//                else if let Street =  address.subLocality
	//                {
	//                    streetStr = "\(Street)"
	//                    self.txtFld_VenueAddress.text = streetStr
	//                }
	//                else
	//                {
	//                    self.txtFld_VenueAddress.text = "\(String(describing: address.locality))"
	//                }
	//
	//                self.txtFld_PostCode.text = cityStr + ", " + stateStr + ", " + zipStr
	//                MBProgressHUD.hide(for: self.view, animated: true)
	//
	//                //currentAddress = lines.joined(separator: "\n")
	//
	//               // currentAdd(currentAddress)
	//            }
	//            else
	//            {
	//                 MBProgressHUD.hide(for: self.view, animated: true)
	//            print(error ?? "")
	//            }
	//        }
	//    }
	
}
