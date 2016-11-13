//
//  GVPrivacySettingTableViewCell.swift
//  GiottoDataViewer
//
//  Created by Brandon Schmuck on 11/12/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

import UIKit

class GVPrivacySettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
