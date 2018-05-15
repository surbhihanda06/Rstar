//
//  Facebook.swift
//  TravellerApp
//
//  Created by Amritpal Singh on 19/10/16.
//  Copyright © 2016 Amritpal Singh. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class Facebook: NSObject {

    //MARK: - variables
    
    var delegate :AnyObject!
    var handler :Selector? = nil

     func getFbData(_ target:AnyObject, selector:Selector)
     {
          delegate = target
        handler = selector
         fbLoginManager.logOut()
        fbLoginManager.loginBehavior = FBSDKLoginBehavior.browser
       
            fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: target as! UIViewController, handler: {(result, error) in
            if error != nil {
                print(error ?? "no Error") //If error occurs
                let errorim : [String:String] = ["code":"0","result":"error"]
                let dictResult :[String:AnyObject] = ["response":errorim as AnyObject]
                self.delegate.performSelector(onMainThread: self.handler!, with:dictResult, waitUntilDone: true)

            } else if (result?.isCancelled)! {   //If result cancelled
                let error : [String:AnyObject] = ["code":"1" as AnyObject,"result":"Cancelled" as AnyObject]
                let dictResult :[String:AnyObject] = ["response":error as AnyObject]
                self.delegate.performSelector(onMainThread: self.handler!, with:dictResult, waitUntilDone: true)
                
            } else {                            //If user succesfully login
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, picture.type(large), email, name, id, gender,location"]).start(completionHandler: {(connection, result, error) -> Void in
                    if error != nil{
                        print("Error : \(error.debugDescription)")
                    } else {
                        let dictResponse : [String:AnyObject] = ["code":"200" as AnyObject,"result":result! as AnyObject]
                        let dictResult :[String:AnyObject] = ["response":dictResponse as AnyObject]
                        print(dictResult)
                        self.delegate.performSelector(onMainThread: self.handler!, with:dictResult, waitUntilDone: true)
                    }
                })
            }
        })
    }
}
