//
//  SignInVC.swift
//  mypay
//
//  Created by Hessam on 12/7/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    //MARK: properties
    @IBOutlet weak var textusername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var buttonSignin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textPassword.isEnabled = false
        textusername.isEnabled = false
        buttonSignin.isEnabled = false
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
