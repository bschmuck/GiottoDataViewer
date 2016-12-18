//
//  GVLoginViewController.swift
//  GiottoDataViewer
//
//  Created by Brandon Schmuck on 11/5/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

import UIKit
import QuartzCore

class GVLoginViewController: UIViewController, GVBuildingDepotManagerDelegate, UITextFieldDelegate {
    @IBOutlet weak var clientIDTextField: UITextField!
    @IBOutlet weak var clientSecretTextField: UITextField!
    
    @IBOutlet weak var loginSubview: UIView!
    
    @IBOutlet weak var modeToggle: UIButton!
    var shadowLayer: UIView?
    
    var isClientIDMode = true
    
    var clientID = "mnXaeQ39cyqOmzaJKpcfgju9Kwoe4CgMqRe2td8d"
    var clientSecret = "WZZWKq2zGEbuXSepas6dKohK5orAVXDu7d7shri7o4ah7gQ07J"
    var username = ""
    var password = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        clientIDTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        clientSecretTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        GVNodeServerManager.sharedInstance.getToken()
        self.loginSubview.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
        
        clientSecretTextField.attributedPlaceholder = NSAttributedString(string:"Enter Client ID", attributes: [NSForegroundColorAttributeName: UIColor.white])
        clientIDTextField.attributedPlaceholder = NSAttributedString(string:"Enter Client Secret", attributes: [NSForegroundColorAttributeName: UIColor.white])

        
        let indent: CGFloat = 10;
        let innerRect = CGRect(x: loginSubview.frame.origin.x + indent, y:loginSubview.frame.origin.y + indent, width: loginSubview.frame.size.width-2*indent, height: loginSubview.frame.size.height-2*indent)
        let shadowView = UIView(frame: innerRect)
        shadowView.backgroundColor = UIColor.clear
        shadowView.layer.masksToBounds = false;
        shadowView.layer.cornerRadius = 8; // if you like rounded corners
        shadowView.layer.shadowRadius = 5;
        shadowView.layer.shadowOpacity = 0.2;
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        shadowView.isUserInteractionEnabled = false
        view.addSubview(shadowView)
        
        self.clientSecretTextField.delegate = self
        self.clientIDTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    @IBAction func toggleMode(_ sender: Any) {
        if isClientIDMode {
            clientID = clientSecretTextField.text!
            clientSecret = clientIDTextField.text!
            isClientIDMode = false
            clientSecretTextField.attributedPlaceholder = NSAttributedString(string:"Enter Username", attributes: [NSForegroundColorAttributeName: UIColor.white])
            clientIDTextField.attributedPlaceholder = NSAttributedString(string:"Enter Password", attributes: [NSForegroundColorAttributeName: UIColor.white])
            clientSecretTextField.text = username
            clientIDTextField.text = password
            modeToggle.setTitle("Or Client ID", for: .normal)
        } else {
            username = clientSecretTextField.text!
            password = clientIDTextField.text!
            isClientIDMode = true
            clientSecretTextField.attributedPlaceholder = NSAttributedString(string:"Enter Client ID", attributes: [NSForegroundColorAttributeName: UIColor.white])
            clientIDTextField.attributedPlaceholder = NSAttributedString(string:"Enter Client Secret", attributes: [NSForegroundColorAttributeName: UIColor.white])
            clientSecretTextField.text = clientID
            clientIDTextField.text = clientSecret
            modeToggle.setTitle("Or User Account", for: .normal)

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
