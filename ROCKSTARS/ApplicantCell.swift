//
//  ApplicantCell.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/30/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit

class ApplicantCell: UITableViewCell {
    @IBOutlet var btnMoreInfo: UIButton!
    @IBOutlet var lblJobTitle: UILabel!
     @IBOutlet var lblShift: UILabel!
    @IBOutlet var ImgView_User: UIImageView!
    @IBOutlet var viewRating: FloatRatingView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
