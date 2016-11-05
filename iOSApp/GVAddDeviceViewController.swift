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
    
    @IBOutlet weak var deviceIDField: UITextField!
    
    let sensors = ["Accelerometer", "EMI", "Mic", "Motion", "Temperature", "Barometer", "Humidity", "Wifi", "Color", "Luminescence", "Geye", "Magnometer"];
    
    let depotManager = GVBuildingDepotManager.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sensorsTableView.dataSource = self;
        self.sensorsTableView.delegate = self;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelDeviceCreation(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    


    @IBAction func addNewDevice(_ sender: AnyObject) {
        if let deviceID = deviceIDField.text {
            let dict = [
                "data" : [
                    "name" : "Test Sensor",
                    "identifier" : deviceID,
                    "building" : "Wean"
                    ]
                ]
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
