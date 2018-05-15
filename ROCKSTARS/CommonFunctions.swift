//
//  CommonFunctions.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/4/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import MBProgressHUD


@objc protocol CounterDataSource {
   func requiredMethod()
    @objc optional var fixedIncrement: Int { get }
}


class CommonFunctions
{
    
     var delegate:CounterDataSource?
    static let sharedInstance = CommonFunctions()
    var defaultAddress = [String : Any]()
    var cardType = String()
    var cardString = String()
    var hasStripeToken = Bool()
    
    func showAlert(message : String, delegate : AnyObject)
    {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
			
			if message == "Ooops! Looks like this account has been banned, if you think this is an error please email help@rockstarapp.com"
			{
				let object  : DrawerViewController = DrawerViewController()
				object.LogoutApi()
			}
            print("You've pressed OK button");
        }
        
        alertController.addAction(OKAction)
        delegate.present(alertController, animated: true, completion:nil)
    }
   
    
    func addPaddingToTextField(textField : UITextField)
    {
        let paddingView = UIView(frame: CGRect(x:0, y:0, width:10, height:textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = UITextFieldViewMode.always
    }
    
    //MARK:- Center Crop Image
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x:posX, y:posY,width: cgwidth,height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    func encode(_ s: String) -> String {
        let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    func decode(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
    
    func findCoordinates(placeID:String, completionHandler: @escaping (_ address:String, _ lat:String, _ lng:String) ->(Void)) {
        
        
         let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&key=\(KGoogleKey)")
        
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
            
           do {
               if data != nil{
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as!  NSDictionary
                    print(dic)
                
                let dic1 = dic.value(forKey:"result") as! [String:Any]
				let address  = dic1["formatted_address"] as! String
                 let dic2 = dic1["geometry"] as! [String:Any]
                 let dic3 = dic2["location"] as! [String:Any]
                let latStr = dic3["lat"]
                let lngStr = dic3["lng"]
                print(latStr ?? "" )
                 print(lngStr ?? "" )
              //   let strlat = "\(String(describing: latStr))"
              //   let strlng = "\(String(describing: lngStr))"
              //  print(strlat ?? "" )
             //  print(strlng ?? "" )
			//	print(address)
                 completionHandler(address,"\(latStr!)","\(lngStr!)")
                
                }
                else {
							print("Error", error ?? "")
							completionHandler("","","")
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
	


}
