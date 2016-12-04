//
//  GVDeviceViewController.swift
//  GiottoDataViewer
//
//  Created by Brandon Schmuck on 11/12/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

import UIKit

class GVDeviceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GVPrivacySettingTableViewCellDelegate {
    
    //var device: GVDevice?

    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var settingsTableView: UITableView!
    
    let privacySettings = ["Min", "Max", "Sum", "Avg", "Stdvar", "Range", "Centroid"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let deviceInfo = GVSelectedDeviceInfo.sharedInstance
        

   
        
        if let name = deviceInfo.deviceName, let sensor = deviceInfo.sensorType, let channel = deviceInfo.channel {
            deviceLabel.text = "SuperSensor_\(name)_\(sensor)_\(channel)"
        }
        
        settingsTableView.dataSource = self
        settingsTableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return privacySettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.settingsTableView.dequeueReusableCell(withIdentifier: "settingsCell") as! GVPrivacySettingTableViewCell
        cell.settingLabel.text = privacySettings[indexPath.row]
        let deviceInfo = GVSelectedDeviceInfo.sharedInstance

        if let name = deviceInfo.deviceName, let sensor = deviceInfo.sensorType, let channel = deviceInfo.channel {
            let deviceName = "SuperSensor_\(name)_\(sensor)_ch\(channel)_\(privacySettings[indexPath.row])"
            if let device = GVSelectedDeviceInfo.sharedInstance.deviceDict[deviceName] {
                let uuid = device.uuid
                GVNodeServerManager.sharedInstance.getPrivacySettings(deviceID: uuid!, completion: { (isAllowed) in
                    DispatchQueue.main.async {
                        cell.settingSwitch.isOn = isAllowed
                    }
                })
            }
        }
        
        
        cell.delegate = self
        return cell
    }
    
    func didTurnPrivacyOn(cell: GVPrivacySettingTableViewCell) {
        let index = self.settingsTableView.indexPath(for: cell)
        let deviceInfo = GVSelectedDeviceInfo.sharedInstance

        if let name = deviceInfo.deviceName, let sensor = deviceInfo.sensorType, let channel = deviceInfo.channel {
            let privacySetting = privacySettings[(index?.row)!] 
            let deviceName = "SuperSensor_\(name)_\(sensor)_ch\(channel)_\(privacySetting)"
            if let device = GVSelectedDeviceInfo.sharedInstance.deviceDict[deviceName] {
                let id = device.deviceID
                GVNodeServerManager.sharedInstance.updateConfig(deviceID: id!)
                let uuid = device.uuid
                GVNodeServerManager.sharedInstance.updatePrivacySetting(deviceID: uuid!, allow: true)
            }
        }
    }
    
    func didTurnPrivacyOff(cell: GVPrivacySettingTableViewCell) {
        let index = self.settingsTableView.indexPath(for: cell)
        let deviceInfo = GVSelectedDeviceInfo.sharedInstance
        
        if let name = deviceInfo.deviceName, let sensor = deviceInfo.sensorType, let channel = deviceInfo.channel {
            let privacySetting = privacySettings[(index?.row)!]
            let deviceName = "SuperSensor_\(name)_\(sensor)_ch\(channel)_\(privacySetting)"
            if let device = GVSelectedDeviceInfo.sharedInstance.deviceDict[deviceName] {
                let id = device.deviceID
                GVNodeServerManager.sharedInstance.updateConfig(deviceID: id!)
                let uuid = device.uuid
                GVNodeServerManager.sharedInstance.updatePrivacySetting(deviceID: uuid!, allow: false)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
