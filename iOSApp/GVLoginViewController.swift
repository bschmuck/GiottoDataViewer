//
//  GVLoginViewController.swift
//  GiottoDataViewer
//
//  Created by Brandon Schmuck on 11/5/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

import UIKit

class GVLoginViewController: UIViewController, GVBuildingDepotManagerDelegate {
    @IBOutlet weak var clientIDTextField: UITextField!
    @IBOutlet weak var clientSecretTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clientIDTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        clientSecretTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: AnyObject) {
        if let clientID = clientIDTextField.text, let clientSecret = clientSecretTextField.text {
            let bdManager = GVBuildingDepotManager.sharedInstance()
            bdManager?.delegate = self;
            bdManager?.fetchOAuthToken(clientID, forKey: clientSecret)
        }
    }
    
    func authenticationDidFail() {
        
    }
    
    func authenticationDidSucceed() {
        self.performSegue(withIdentifier: "loginDidSucceed", sender: nil)
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
