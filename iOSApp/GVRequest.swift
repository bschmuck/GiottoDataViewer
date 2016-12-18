//
//  GVRequest.swift
//  GiottoDataViewer
//
//  Created by Brandon Schmuck on 10/28/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

import UIKit

enum urlMethod {
    case GET
    case POST
    case PUT
}

class GVRequest: NSObject {
    
    //Re-authorize URL for requests
    
    
    //Generates a URL string for a given endpoint
    class func urlString(endpoint: String) -> String {
        let server = GVUserPreferences.sharedInstance().giottoServer
        let port = GVUserPreferences.sharedInstance().giottoPort
        let apiPrefix = GVUserPreferences.sharedInstance().apiPrefix
        let urlString = "http://google-demo.andrew.cmu.edu:81/api/sensor"
        //let urlString =  "\(server!):\(port!)\(apiPrefix!)\(endpoint)"
        return urlString
    }
    
    //Method to create a new URL request
    class func urlRequest(urlString: String, token: String?, httpMethod: urlMethod, data: Dictionary<String, AnyObject>?) -> NSMutableURLRequest {
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(url: url as URL)
        
        if let body = data {
            do {
                let body = try JSONSerialization.data(withJSONObject: body as NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                request.httpBody = body
                request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                
            }
        }
        
        switch httpMethod.self {
            case .GET:
                request.httpMethod = "GET"
                break
            case .POST:
                request.httpMethod = "POST"
                break
            case .PUT:
                request.httpMethod = "PUT"
                break
        }
        
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        
        if let token = token {
            let tokenHeader = "Bearer \(token)"
            request.setValue(tokenHeader, forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    //Method to start a URL session with a request
    class func urlSession(request: NSMutableURLRequest, callback: @escaping (NSDictionary?, Error?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            var dataDict: NSDictionary?
            if let data = data {
                let dataString = String(data: data, encoding: String.Encoding.utf8)
                print("DataString: " + dataString!)
                do {
                    dataDict = try JSONSerialization.jsonObject(with: data, options:.mutableLeaves) as? NSDictionary
                    callback(dataDict, error)
                }
                catch {
                }
            } else {
                callback(nil, error)
            }
        }
        task.resume()
    }
    
}
