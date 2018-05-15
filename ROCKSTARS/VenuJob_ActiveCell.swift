//
//  VenuJob_ActiveCell.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/25/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit

class VenuJob_ActiveCell: UITableViewCell
{
    @IBOutlet var btnMoreInfo: UIButton!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblJobTitle: UILabel!
    @IBOutlet var ImgView_Venue: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
