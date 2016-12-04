//
//  GVSensorTypeTableViewController.swift
//  GiottoDataViewer
//
//  Created by Brandon Schmuck on 11/24/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

import UIKit

class GVSensorTypeTableViewController: UITableViewController {
    
    var sensorCells = ["Accelerometer", "EMI", "Mic", "Motion", "Temperature", "Barometer", "Humidity", "Wifi", "Color", "Illuminescence", "Geye", "Magnetometer"];

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sensorCells[indexPath.row].contains("Channel") {
            return 30;
        } else {
            return 60;
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sensorCells.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sensor = sensorCells[indexPath.row]
        
        //Channel sub-cell
        if sensor.contains("Channel") {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ChannelCell") as! GVChannelCell
            cell.channelNumberLabel.text = sensor
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "TypeCell") as! GVTypeCell
            cell.sensorTypeLabel.text = sensor
            cell.selectionStyle = .none

            if indexPath.row < sensorCells.count - 1 {
                let following = sensorCells[indexPath.row + 1]
                if following.contains("Channel") {
                    cell.isExpanded = true
                } else {
                    cell.isExpanded = false
                }
            } else {
                cell.isExpanded = false
            }
            let deviceImage = "\(sensor)Icon"
            if let image = UIImage(named: deviceImage) {
                cell.typeImage.image = image
            }
            cell.arrowImage.image = UIImage(named:"TableViewArrow")
            if cell.isExpanded {
                cell.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
            } else {
                cell.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(0));
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        GVSelectedDeviceInfo.sharedInstance.sensorType = sensors[indexPath.row]
//        GVSelectedDeviceInfo.sharedInstance.channels = GVSelectedDeviceInfo.getNumChannels(for: sensors[indexPath.row])
//        self.performSegue(withIdentifier: "showChannels", sender: nil)
        let cell = tableView.cellForRow(at: indexPath)!
        
        if let cell = cell as? GVTypeCell {
            let channelCount = GVSelectedDeviceInfo.getNumChannels(for: cell.sensorTypeLabel.text!)
            
            
            if cell.isExpanded {
                //Remove inserted channels
                for i in 0..<channelCount {
                    self.sensorCells.remove(at: indexPath.row + 1)
                }
                
                UIView.animate(withDuration: 0.25, animations: {
                    cell.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(0));
                }, completion: { (complete) in
                    self.tableView.reloadData()
                })
                cell.isExpanded = false;
            } else {
                //Insert channel names into array
                for i in 0..<channelCount {
                    self.sensorCells.insert("Channel \(i)", at: indexPath.row + i + 1)
                }
                UIView.animate(withDuration: 0.25, animations: {
                    cell.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
                }, completion: { (complete) in
                    self.tableView.reloadData()
                })
                
                cell.isExpanded = true;
            }
        } else if let cell = cell as? GVChannelCell {
            let deviceInfo = GVSelectedDeviceInfo.sharedInstance
            let channelString = cell.channelNumberLabel.text!
            let channelNum = channelString.components(separatedBy: " ")[1]
            deviceInfo.channel = Int(channelNum)
            var index = indexPath.row
            while(index >= 0) {
                if !(sensorCells[index].contains("Channel")) {
                    deviceInfo.sensorType = sensorCells[index]
                    break
                }
                index -= 1
            }
            
            self.performSegue(withIdentifier: "ShowDetails", sender: nil)
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
