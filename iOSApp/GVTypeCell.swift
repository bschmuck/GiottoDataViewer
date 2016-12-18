//
//  GVTypeCell.swift
//  GiottoDataViewer
//
//  Created by Brandon Schmuck on 11/24/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

import UIKit

class GVTypeCell: UITableViewCell {
    @IBOutlet weak var sensorTypeLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var arrowImage: UIImageView!
    var isExpanded = false;

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
