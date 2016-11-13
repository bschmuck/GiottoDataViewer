//
//  GVDeviceViewController.swift
//  GiottoDataViewer
//
//  Created by Brandon Schmuck on 11/12/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

import UIKit

class GVDeviceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var device: GVDevice?

    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var settingsTableView: UITableView!
    
    let privacySettings = ["Min", "Max", "Sum", "Average", "Standard Deviation", "Range", "Centroid"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let device = device {
            deviceLabel.text = device.name
            locationLabel.text = device.location
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
        return cell
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
