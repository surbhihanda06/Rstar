//
//  ServerRequest.swift
//  DemoMVC
//
//  Created by Anuradha Sharma on 03/02/17.
//  Copyright © 2017 Anuradha Sharma. All rights reserved.
//

import UIKit
import Alamofire

@objc protocol ResponseProtcol
{
    func Response(Resposnedic : [String:Any])
    func Failure()
  }

class ServerRequest: NSObject
{
    var delegate:ResponseProtcol?
    
    static let sharedInstance = ServerRequest()
    var savedUrl = String()
    var savedSelector : Selector?
    var savedDelegate : AnyObject?
    var savedParameters = [String : Any]()
    var savedMethod = String()
    
    func GetApi(urlStr : String)
    {
        if Reach.isConnectedToNetwork() == true
        {
            let url = kBaseUrl + urlStr
            Alamofire.request(url, method : .get, parameters : nil).responseJSON(completionHandler: {
                response in
                print(response.result)
                // print(response.request!,param)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    if response.response?.statusCode == 200 {
                        self.delegate?.Response(Resposnedic: JSON as! [String : AnyObject])
                }
						/************************///Aman
					else if  response.response?.statusCode == 401 {
						
						 self.delegate?.Response(Resposnedic: JSON as! [String : AnyObject])
					}
						/***************************/
                    else
                    {
                        self.delegate?.Failure()
                    }
                    
                } else {
                    self.delegate?.Failure()
                }
            })
        }
        else
        {
              //MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
        }
        }
    
    func PostApi(urlStr : String,_ dict:[String:Any])
    {
         let url = kBaseUrl + urlStr
         print(dict)
         print(url)
        Alamofire.request(url, method : .post, parameters : dict).responseJSON(completionHandler: {
            response in
            print(response.request ?? "")
            // print(response.request!,param)
               
            print(response.result)
            print(response.result.description)
            print(response.data ?? "")
            print(response.request?.urlRequest ?? "")
            print(response.result.value ?? "")
            // self.delegate?.Response(dic: nil)
            if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print(json ?? "")
            }
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                //let responseJson = JSON as! [String: Any]
                if response.response?.statusCode == 200
				   {
                    self.delegate?.Response(Resposnedic: JSON as! [String : AnyObject])
				   }
				/****************************///Aman
				else if response.response?.statusCode == 401
				{
					self.delegate?.Response(Resposnedic: JSON as! [String : AnyObject])
				}
				/****************************/
                else
                {
					self.delegate?.Failure()
                }
                
            }
			else
            {
                    self.delegate?.Failure()
                  }
        }) }
    
    func UploadImageWithParam(urlStr : String,parameters : [String:Any], imgData:Data?) {
        
        print(parameters)
        print(imgData!)
        
          let time = Int(Date().timeIntervalSinceReferenceDate)
        let filename :String = "\(time).png"
        
        
        var headers =
            [
                "Content-Disposition": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
                "cache-control": "no-cache",
                ]
        if let strTemp : String = UserDefaults.standard.value(forKey: kSessionToken) as? String{
            headers["Authorization"] = "Bearer "+strTemp
        }
        let requestUrl = kBaseUrl + urlStr
        
        print(requestUrl)
        let URL = try! URLRequest(url: requestUrl, method: .post, headers: headers)
        
        Alamofire.upload(
            multipartFormData:  { (multipartFormData) in
                multipartFormData.append(imgData!, withName: "image", fileName: filename , mimeType: "text/plain")
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
        },
            with: URL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _,_):
                    upload.responseJSON { response in
                        debugPrint(response)
                        DispatchQueue.main.async {
                            
                            print(response.result)
                            print(response.result.description)
                            print(response.data ?? "")
                            print(response.request?.urlRequest ?? "")
                            print(response.result.value ?? "")

                            if response.response?.statusCode == 200 {
  
                            if let JSON = response.result.value
                            {
                                print("JSON: \(JSON)")
                                let responseDict = JSON as! [String: Any]
                              self.delegate?.Response(Resposnedic: responseDict)
                                
                            }
                            else
                            {
                                self.delegate?.Failure()
                              }
                            }
					/*****************************///Aman
							else if response.response?.statusCode == 401
							{
								if let JSON = response.result.value
								{
									let responseDict = JSON as! [String: Any]
									self.delegate?.Response(Resposnedic: responseDict)
								}
							}
				  /*****************************/
                            else
                            {
                                 self.delegate?.Failure()
                            }
                         }
                    }
                case .failure( _): break
                     self.delegate?.Failure()
                }
        }
        )
        }
    
    //MARK:- Post Method
    
    func postMethod(urlStr : String,parameters : [String:Any]){
        
        print(parameters)
        print(urlStr)
        if Reachability.isConnectedToNetwork() {
            
            Alamofire.request(urlStr, method : .post, parameters : parameters).responseJSON(completionHandler: {
                response in
                //print(response.result)
                print(response.result)
                print(response.result.description)
                print(response.data ?? "")
                print(response.request?.urlRequest ?? "")
                print(response.result.value ?? "")

                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    let responseJson = JSON as! [String: Any]
                    if response.response?.statusCode == 200 {
                    self.delegate?.Response(Resposnedic: responseJson)
                    }
					/************************///Aman
					else if  response.response?.statusCode == 401 {
						
						self.delegate?.Response(Resposnedic: responseJson)
					}
					/***************************/
                    else{
                        self.delegate?.Failure()
                    }
                } else {
                    self.delegate?.Failure()
                }
            }) } else
        {
            //  MBProgressHUD.hide(for: self.view, animated: true)
            CommonFunctions.sharedInstance.showAlert(message: KInternetConnectionLost, delegate: self)
        }    }
}
