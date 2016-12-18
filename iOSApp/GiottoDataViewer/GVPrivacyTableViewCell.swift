//
//  GVPrivacyTableViewCell.swift
//  GiottoDataViewer
//
//  Created by Brandon Schmuck on 10/23/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

import UIKit

protocol GVPrivacyTableViewCellDelegate {
    func userToggledSensor(sensor: String, state: Bool)
}

class GVPrivacyTableViewCell: UITableViewCell {
    @IBOutlet weak var sensorLabel: UILabel!
    @IBOutlet weak var enable: UISwitch!
    
    var delegate: GVPrivacyTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func userToggledSensor(_ sender: Any) {
        self.delegate?.userToggledSensor(sensor: self.sensorLabel.text!, state: self.enable.isOn)
    }
}
