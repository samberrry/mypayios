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
        let alertController = UIAlertController(title: "Notice", message: "Do you want to realy sign out?", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.signOut()
        }
        let cancelAction = UIAlertAction(title: "No,go back!", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("No,go back!")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func signOut() {
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
