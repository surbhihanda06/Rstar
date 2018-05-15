//
//  FilterViewController.swift
//  ROCKSTARS
//
//  Created by Amrit on 15/05/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet var popView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        popView.addPikeOnView(side: .Top)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
