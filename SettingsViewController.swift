//
//  SettingsViewController.swift
//  mypay
//
//  Created by Hessam on 12/28/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutIsClicked(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "authenticated")
        defaults.set("", forKey: "username")
        defaults.set("", forKey: "password")
        performSegue(withIdentifier: "goToSignIn", sender: self)
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
