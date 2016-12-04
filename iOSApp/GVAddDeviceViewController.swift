//
//  GVAddDeviceViewController.swift
//  GiottoDataViewer
//
//  Created by Brandon Schmuck on 10/15/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

import UIKit

class GVAddDeviceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var sensorsTableView: UITableView!
    
    @IBOutlet weak var deviceNameField: UITextField!
    @IBOutlet weak var deviceIDField: UITextField!
    
    let sensors = ["Accelerometer", "EMI", "Mic", "Motion", "Temperature", "Barometer", "Humidity", "Wifi", "Color", "Illuminescence", "Geye", "Magnetometer"];
    
    let depotManager = GVBuildingDepotManager.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sensorsTableView.dataSource = self;
        self.sensorsTableView.delegate = self;
        self.navigationController?.navigationBar.tintColor = UIColor.blue
        self.navigationController?.navigationBar.isTranslucent = true
        deviceNameField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        deviceIDField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelDeviceCreation(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Generates a dictionary for a sequence of 231 data streams generated for
    //each SuperSensor.
    func generateSensorDict(deviceID: String, building: String, baseIdentifier: String) -> Array<Dictionary<String, String>> {
        
        var sensorDicts = Array<Dictionary<String, String>>();
        
        let sensorChannels = [
            "Accelerometer" : 3,
            "Microphone" : 1,
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
        
        let stats = ["Min", "Max", "Sum", "Avg", "Stdvar", "Range", "Centroid"]
        
        //Numbers for identifier key values
        let idDict = [
            "Min" : 0,
            "Max" : 1,
            "Sum" : 2,
            "Avg" : 3,
            "Stdvar" : 4,
            "Range" : 5,
            "Centroid" : 6,
            "Accelerometer" : 0,
            "Microphone" : 1,
            "EMI" : 2,
            "Temperature" : 4,
            "Barometer" : 5,
            "Humidity" : 6,
            "Illumination" : 7,
            "Color" : 8,
            "Magnetometer" : 9,
            "Wifi" : 10,
            "Motion" : 11,
            "Geye" : 12
        ]
        
        for sensor in sensorChannels {
            let channelCount = sensor.value
            for i in 0..<channelCount {
                for stat in stats {
                    let dict = [
                        "building" : building,
                        "identifier" : "\(baseIdentifier)_\((idDict[sensor.key])!)_\(i)_\((idDict[stat])!)",
                        "name" : "SuperSensor_\(deviceID)_\(sensor.key)_ch\(i)_\(stat)"
                    ]
                    sensorDicts.append(dict)
                }
            }
        }
        return sensorDicts;
    }
    


    @IBAction func addNewDevice(_ sender: AnyObject) {
        if let deviceID = deviceIDField.text, let deviceName = deviceNameField.text {
            
//            var sensorDicts = [Dictionary<String, String>]()
            
//            for i in 0..<231 {
//                let dict = [
//                    "building" : "Google Bldg SL100",
//                    "identifier" : \(deviceID)
//                ]
//            }
            
            let sensorDicts = generateSensorDict(deviceID: deviceID, building: "Wean", baseIdentifier: "23543rfd");
            
            for sensorDict in sensorDicts {
                let dict = ["data": sensorDict]
                let urlString = GVRequest.urlString(endpoint: "/sensor")
                let request = GVRequest.urlRequest(urlString: urlString, token: depotManager!.accessToken, httpMethod: .POST, data: dict as Dictionary<String, AnyObject>?)
                GVRequest.urlSession(request: request, callback: { (data, error) in
                    if((error) != nil) {
                        print("Error Occurred: \(error)")
                    } else {
                        print("Successfully enrolled sensor")
                        print(data)
                    }
                })
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.sensorsTableView.dequeueReusableCell(withIdentifier: "privacyCell") as! GVPrivacyTableViewCell
        let sensor = sensors[indexPath.row]
        cell.sensorLabel.text = sensor
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
