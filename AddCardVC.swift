//
//  AddCardVC.swift
//  mypay
//
//  Created by Hessam on 12/21/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import UIKit

class AddCardVC: UIViewController {

    //MARK: Properties
    @IBOutlet weak var textCardName: UITextField!
    @IBOutlet weak var textCardNumber: UITextField!
    @IBOutlet weak var textCvv2: UITextField!
    @IBOutlet weak var textExpDate: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
