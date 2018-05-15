//
//  SearchViewCell.swift
//  ROCKSTARS
//
//  Created by Amandeep Kaur on 5/8/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit

class SearchViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblJobPosition: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
