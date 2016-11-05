//
//  GVDeviceTableViewCell.swift
//  GiottoDataViewer
//
//  Created by Brandon Schmuck on 11/5/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

import UIKit

class GVDeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var sensorNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var deviceImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
