//
//  GVButton.swift
//  GiottoDataViewer
//
//  Created by Brandon Schmuck on 11/5/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

import UIKit
import QuartzCore

class GVButton: UIButton {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        self.backgroundColor = UIColor.clear
//        self.layer.cornerRadius = 5
//        self.layer.borderWidth = 3
//        self.layer.borderColor = UIColor.white.cgColor
    }
}
