//
//  Register_Data.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/11/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit

class Register_Data: NSObject
{
      //MARK: Shared Instance
        static let sharedInstance : Register_Data =
            {
            let instance = Register_Data()
            return instance
        }()
    
    var name: String = ""
    var venue: String = ""
    var postcode: String = ""
    var mobileNumber: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var dob: String = ""
    var aboutMe: String = ""
    var rating_Time: String = ""
    var rating_KeepSellin: String = ""
    var imgData = Data()
    var skills_Selected: String = ""
    var faceBook_id: String = ""
    var arrSkills = Array<Dictionary<String,Any>>()
    var userID : String = ""
    var roleType : String = ""
    var rstarHired: String = ""
    var imgUrl: String = ""
    var VenueAddress: String = ""
    var lat: String = ""
    var lng: String = ""
     var bulidingNo: String = ""


}
