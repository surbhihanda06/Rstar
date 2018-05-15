//
//  TutorialViewController.swift
//  ROCKSTARS
//
//  Created by Amandeep Kaur on 6/6/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
   
    var strTute = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnGotItAction(_ sender: Any)
    {
        if strTute == "Tutorial"
        {
             self.performSegue(withIdentifier: "MainToUser_Skills", sender: self)
        }
        else
        {

    self.navigationController?.popViewController(animated: false)
        }
    }
}
