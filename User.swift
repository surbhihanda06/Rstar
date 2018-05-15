//
//  User.swift
//  Plowz & Mowz
//
//  Created by Anuradha Sharma on 03/03/17.
//  Copyright © 2017 Softprodigy. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class User : NSObject
{
    //MARK: Shared Instance
    static let sharedInstance : User = {
        let instance = User()
        return instance
    }()
    
    var email: String = ""
    var name: String = ""
    var role_type: String = ""
    var user_id: String = ""
    var arrJobHistory = Array<Dictionary<String,Any>>()
    
   }
