//
//  GVNodeServerManager.swift
//  GiottoDataViewer
//
//  Created by Brandon Schmuck on 11/26/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

import UIKit

class GVNodeServerManager: NSObject {
    
    static let sharedInstance = GVNodeServerManager()
    
    var accessToken: String?
    
    func updateConfig(deviceID: String) {
        let dID = deviceID.replacingOccurrences(of: "-", with: "")
        if let accessToken = accessToken {
            let request = GVRequest.urlRequest(urlString: "http://128.2.113.41:8080/v1/update/\(dID)?access_token=\(accessToken)", token: nil, httpMethod: .PUT, data: nil)
            GVRequest.urlSession(request: request, callback: { (data, error) in
                if((error) != nil) {
                    print("Error Occurred: \(error)")
                } else {
                    print("Successfully updated settings")
                }
            })
        }
    }
    
    func getPrivacySettings(deviceID: String, completion: @escaping (Bool) -> Void) {
        let requestString = "http://google-demo.andrew.cmu.edu:81/api/sensor/\(deviceID)/tags"
        let depotManager = GVBuildingDepotManager.sharedInstance()
        let request = GVRequest.urlRequest(urlString: requestString, token: depotManager!.accessToken, httpMethod: .GET, data: nil as Dictionary<String, AnyObject>?)
        GVRequest.urlSession(request: request, callback: { (data, error) in
            if((error) != nil) {
                print("Error Occurred: \(error)")
            } else {
                print("Successfully retrieved privacy setting")
                print(data)
                
                if let tags = data?["tags_owned"] as? Array<NSDictionary> {
                    for tag in tags {
                        if((tag["name"] as! String) == "Access") {
                            if((tag["value"] as! String) == "Deny") {
                                completion(false)
                            } else {
                                completion(true)
                            }
                        }
                    }
                }
            }
        })
    }
    
    
//    {
//    'data': [{
//    'name': 'DeviceID',
//    'value': '3d001c000547343339373536'
//    }, {
//    'name': 'SensorID',
//    'value': '1'
//    }, {
//    'name': 'ChannelID',
//    'value': '0'
//    }, {
//    'name': 'StatID',
//    'value': '4'
//    }, {
//    'name': 'UserID',
//    'value': 'SuperSensor_SYN003'
//    }, {
//    'name': 'Access',
//    'value': 'Allow'
//    }]
//    }
//    
    
    func updateTags(with dict: Dictionary<String, AnyObject>, deviceID: String) {
        let requestString = "http://google-demo.andrew.cmu.edu:81/api/sensor/\(deviceID)/tags"
        
        let depotManager = GVBuildingDepotManager.sharedInstance()
        let request = GVRequest.urlRequest(urlString: requestString, token: depotManager!.accessToken, httpMethod: .POST, data: dict as Dictionary<String, AnyObject>?)
        GVRequest.urlSession(request: request, callback: { (data, error) in
        if((error) != nil) {
            print("Error Occurred: \(error)")
        } else {
            print("Successfully updated privacy setting")
            print(data)
        }
        })
    }
    
    func getBuildings(callback: @escaping ([String])->Void) {
        let requestString = "http://google-demo.andrew.cmu.edu:81/api/building/list"
        let depotManager = GVBuildingDepotManager.sharedInstance()
        let request = GVRequest.urlRequest(urlString: requestString, token: depotManager!.accessToken, httpMethod: .GET, data: nil)
        GVRequest.urlSession(request: request, callback: { (data, error) in
            if((error) != nil) {
                print("Error Occurred: \(error)")
            } else {
                print("Successfully updated privacy setting")
                if let buildings = data?["buildings"] as? [String] {
                    callback(buildings)
                }
            }
        })
    }
    
    //Initializes a tags dictionary on the server for a newly initialized sensor
    func initTagsDict(forDeviceID deviceID: String, sensorID: String, channelID: String, statID: String, deviceName: String, access: Bool) {
        
        var accessString: String?
        if !access {
            accessString = "Deny"
        } else {
            accessString = "Allow"
        }
        
        let tagsArray = [
            [
                "name" : "DeviceID",
                "value" : deviceID
            ],
            [
                "name" : "SensorID",
                "value" : statID
            ],
            [
                "name" : "ChannelID",
                "value" : channelID
            ],
            [
                "name" : "StatID",
                "value" : statID
            ],
            [
                "name" : "UserID",
                "value" : "SuperSensor_\(deviceName)"
            ],
            [
                "name" : "Access",
                "value" : accessString!
            ]
        ]
        
        let tagsDict = [
            "data" : tagsArray
        ]
        
        self.updateTags(with: tagsDict as Dictionary<String, AnyObject>, deviceID: deviceID)
        
        
    }
    
    //Toggles privacy setting for a sensor
    func updatePrivacySetting(deviceID: String, allow: Bool) {
        
        var allowString = "Allow"
        if !allow {
            allowString = "Deny"
        }
        
        let data = [ "data" : [["name" : "Access", "value" : allowString]]];
        
        self.updateTags(with: data as Dictionary<String, AnyObject>, deviceID: deviceID)
        
    }
    
    //Retrieves a token for communication with the node.js server
    func getToken() {
        let request = GVRequest.urlRequest(urlString: "http://128.2.113.41:8080/oauth/token", token: nil, httpMethod: .POST, data: nil)
        
        let post = "grant_type=password&username=synergylabscmu@gmail.com&password="
        
        var postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)
        let postLength = "\(postData?.count)"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData
        
        request.addValue("Basic cGFydGljbGU6cGFydGljbGU=", forHTTPHeaderField: "Authorization")
        GVRequest.urlSession(request: request, callback: { (data, error) in
            if((error) != nil) {
                print("Error Occurred: \(error)")
            } else {
                if let token = data?["access_token"] as? String {
                    GVNodeServerManager.sharedInstance.accessToken = token
                }
            }
        })
    }
    
}
