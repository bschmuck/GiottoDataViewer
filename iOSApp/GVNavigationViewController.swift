//
//  GVNavigationViewController.swift
//  GiottoDataViewer
//
//  Created by Brandon Schmuck on 12/16/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

import UIKit

class GVNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = UIColor(hue: 205/360.0, saturation: 0.83, brightness: 0.73, alpha: 1)
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white];

        // Do any additional setup after loading the view.
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
