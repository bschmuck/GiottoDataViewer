//
//  GVAddDeviceViewController.swift
//  GiottoDataViewer
//
//  Created by Brandon Schmuck on 10/15/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore

class GVAddDeviceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GVPrivacyTableViewCellDelegate, AVCaptureMetadataOutputObjectsDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var sensorsTableView: UITableView!
    
    @IBOutlet weak var deviceNameField: UITextField!
    @IBOutlet weak var buildingPickerView: UIPickerView!
    @IBOutlet weak var qrCameraView: UIView!
    @IBOutlet weak var deviceIDField: UITextField!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    let sensors = ["Accelerometer", "EMI", "Microphone", "Motion", "Temperature", "Barometer", "Humidity", "Wifi", "Color", "Illumination", "Geye", "Magnetometer"];
    var sensorsEnabled = ["Accelerometer" : true,
                   "EMI" : true,
                   "Microphone" : true,
                   "Motion" : true,
                   "Temperature" : true,
                   "Barometer" : true,
                   "Humidity" : true,
                   "Wifi" : true,
                   "Color" : true,
                   "Illumination" : true,
                   "Geye" : true,
                   "Magnetometer" : true];
    
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
    
    let reverseSensorDict = [
        "0" : "Accelerometer",
        "1" : "Microphone",
        "2" : "EMI",
        "4" : "Temperature",
        "5" : "Barometer",
        "6" : "Humidity",
        "7" : "Illumination",
        "8" : "Color",
        "9" : "Magnetometer",
        "10" : "Wifi",
        "11" : "Motion",
        "12" : "Geye"
    ]
    
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
    
    let depotManager = GVBuildingDepotManager.sharedInstance()
    
    var locations = ["Wean Hall", "Gates", "NSH", "Baker", "CUC"]
    
    var selectedBuilding = "Google Bldg SL100"


    override func viewDidLoad() {
        super.viewDidLoad()
        self.sensorsTableView.dataSource = self;
        self.sensorsTableView.delegate = self;
        
//        deviceNameField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        deviceIDField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        deviceNameField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);

        deviceIDField.delegate = self
        deviceNameField.delegate = self
        
        deviceIDField.attributedPlaceholder = NSAttributedString(string:"Enter Device ID", attributes: [NSForegroundColorAttributeName: UIColor.white])
        deviceNameField.attributedPlaceholder = NSAttributedString(string:"Enter Device Name", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        initQRCode()
        
        buildingPickerView.delegate = self
        self.buildingPickerView.backgroundColor = self.view.backgroundColor
        self.buildingPickerView.layer.masksToBounds = false;
        self.buildingPickerView.layer.shadowOffset = CGSize(width: -5, height: 2)
        self.buildingPickerView.layer.shadowRadius = 5;
        self.buildingPickerView.layer.shadowOpacity = 0.5;
        
        GVNodeServerManager.sharedInstance.getBuildings { (buildings) in
            self.locations = buildings
            DispatchQueue.main.async {
                self.selectedBuilding = self.locations[0]
                self.buildingPickerView.reloadAllComponents()
            }
        }
        
        self.deviceIDField.backgroundColor = self.view.backgroundColor
        self.deviceIDField.layer.masksToBounds = false;
        self.deviceIDField.layer.shadowOffset = CGSize(width: -5, height: 2)
        self.deviceIDField.layer.shadowRadius = 1;
        self.deviceIDField.layer.shadowOpacity = 0.2;
        
        self.deviceNameField.backgroundColor = self.view.backgroundColor
        self.deviceNameField.layer.masksToBounds = false;
        self.deviceNameField.layer.shadowOffset = CGSize(width: -5, height: 2)
        self.deviceNameField.layer.shadowRadius = 1;
        self.deviceNameField.layer.shadowOpacity = 0.2;
        
        // Do any additional setup after loading the view.
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locations.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedBuilding = self.locations[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var string = ""
        if locations.count > row {
            string = self.locations[row]
        }
        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.white])
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = .zero
            print("No QR code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            
            if metadataObj.stringValue != nil {
                print(metadataObj.stringValue)
                DispatchQueue.main.async {
                    self.deviceIDField.text = metadataObj.stringValue
                }
            }
        }
    }
    
    func initQRCode() {
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {
            granted in
            if granted {
                // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
                // as the media type parameter.
                let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
                
                // Get an instance of the AVCaptureDeviceInput class using the previous device object.
                
                do {
                    let input: AnyObject! = try AVCaptureDeviceInput(device: captureDevice)
                    
                    // Initialize the captureSession object.
                    self.captureSession = AVCaptureSession()
                    // Set the input device on the capture session.
                    self.captureSession?.addInput(input as! AVCaptureInput)
                    
                    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
                    let captureMetadataOutput = AVCaptureMetadataOutput()
                    self.captureSession?.addOutput(captureMetadataOutput)
                    
                    captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
                    
                    self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                    self.videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                    self.videoPreviewLayer?.frame = self.qrCameraView.frame
                    self.view.layer.addSublayer(self.videoPreviewLayer!)
                    
                    self.captureSession?.startRunning()
                    
                    // Initialize QR Code Frame to highlight the QR code
                    self.qrCodeFrameView = UIView()
                    self.qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
                    self.qrCodeFrameView?.layer.borderWidth = 2
                    
                    DispatchQueue.main.async {
                        self.view.addSubview(self.qrCodeFrameView!)
                        self.view.bringSubview(toFront: self.qrCodeFrameView!)
                    }
                    
                } catch {
                    
                }
            }
        })
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
        
 
        
        let stats = ["Min", "Max", "Sum", "Avg", "Stdvar", "Range", "Centroid"]
        
        
        for sensor in sensorChannels {
            let channelCount = sensor.value
            for i in 0..<channelCount {
                for stat in stats {
                    let dict = [
                        "building" : building,
                        "identifier" : "\(deviceID)_\((idDict[sensor.key])!)_\(i)_\((idDict[stat])!)",
                        "name" : "SuperSensor_\(baseIdentifier)_\(sensor.key)_ch\(i)_\(stat)"
                    ]
                    
                    sensorDicts.append(dict)
                }
            }
        }
        return sensorDicts;
    }
    
    func userToggledSensor(sensor: String, state: Bool) {
        sensorsEnabled[sensor] = state
    }
    
    func enrollDevice(sensorDict: Dictionary<String, String>) {
        let dict = ["data": sensorDict]
        let urlString = GVRequest.urlString(endpoint: "/sensor")
        let request = GVRequest.urlRequest(urlString: urlString, token: depotManager!.accessToken, httpMethod: .POST, data: dict as Dictionary<String, AnyObject>?)
        
        
        let deviceIDComps = sensorDict["identifier"]?.components(separatedBy: "_")
        let deviceNameComps = sensorDict["name"]?.components(separatedBy: "_")
        
        
        if let deviceID = deviceIDComps?[0], let sensorID = deviceIDComps?[1], let channelID = deviceIDComps?[2], let statID = deviceIDComps?[3], let deviceName = deviceNameComps?[1] {
            GVRequest.urlSession(request: request, callback: { (data, error) in
                if((error) != nil) {
                    print("Error Occurred: \(error)")
                } else {
                    let sensor = self.reverseSensorDict[sensorID]!
                    let access = self.sensorsEnabled[sensor]!
                    if let uuid = data?["uuid"] {
                        GVNodeServerManager.sharedInstance.initTagsDict(forDeviceID: uuid as! String, sensorID: sensorID, channelID: channelID, statID: statID, deviceName: deviceName, access: access)
                    }
                    print("Successfully enrolled sensor")
                }
            })
            //
        }
    }


    @IBAction func addNewDevice(_ sender: AnyObject) {
        if let deviceID = deviceIDField.text {
            
            let sensorDicts = generateSensorDict(deviceID: deviceID, building: self.selectedBuilding, baseIdentifier: self.deviceNameField.text!);
            
            for sensorDict in sensorDicts {
                enrollDevice(sensorDict: sensorDict)
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
        cell.delegate = self
        cell.selectionStyle = .none
        cell.sensorLabel.text = sensor
        return cell
    }
}
