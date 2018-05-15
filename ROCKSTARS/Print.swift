//
//  Print.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 7/6/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import Foundation

func releasePrint(_ object: Any)
{
    Swift.print(object)
}

func print(_ object: Any)
{
    #if DEBUG
        Swift.print(object)
    #endif
}
