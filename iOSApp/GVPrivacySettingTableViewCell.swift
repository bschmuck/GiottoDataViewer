//
//  GVPrivacySettingTableViewCell.swift
//  GiottoDataViewer
//
//  Created by Brandon Schmuck on 11/12/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

import UIKit


protocol GVPrivacySettingTableViewCellDelegate {
    func didTurnPrivacyOn(cell: GVPrivacySettingTableViewCell);
    func didTurnPrivacyOff(cell: GVPrivacySettingTableViewCell);
}

class GVPrivacySettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    var delegate: GVPrivacySettingTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func togglePrivacy(_ sender: Any) {
        let privacySetting = sender as? UISwitch
        if let state = privacySetting?.isOn {
            if state {
                self.delegate?.didTurnPrivacyOn(cell: self)
            } else {
                self.delegate?.didTurnPrivacyOff(cell: self)
            }
        }
    }
}
