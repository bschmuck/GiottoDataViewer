//
//  GVSelectedDeviceInfo.swift
//  GiottoDataViewer
//
//  Created by Brandon Schmuck on 11/24/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

import UIKit

class GVSelectedDeviceInfo: NSObject {
    static let sharedInstance = GVSelectedDeviceInfo();
    
    var deviceName: String?
    var sensorType: String?
    var channel: Int?
    var stat: String?
    
    var deviceDict = [String : GVDevice]()
    
    class func getNumChannels(for sensor:String) -> Int {
        let sensorChannels = [
            "Accelerometer" : 3,
            "Mic" : 1,
            "EMI" : 1,
            "Temperature" : 1,
            "Barometer" : 1,
            "Humidity" : 1,
            "Illumination" : 1,
            "Color" : 3,
            "Magnetometer" : 3,
            "Wifi" : 1,
            "Motion" : 1,
            "Geye" : 16
        ]
        
        if let channels = sensorChannels[sensor] {
            return channels
        } else {
            return 0
        }
    }
}
