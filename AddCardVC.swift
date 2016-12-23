//
//  AddCardVC.swift
//  mypay
//
//  Created by Hessam on 12/21/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import UIKit

class AddCardVC: UIViewController,UITextFieldDelegate{

    //MARK: Properties
    @IBOutlet weak var textCardName: UITextField!
    @IBOutlet weak var textCardNumber: UITextField!
    @IBOutlet weak var textCvv2: UITextField!
    @IBOutlet weak var textExpDate: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var card: Card?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textCardName.delegate = self
        textCardNumber.delegate = self
        textCvv2.delegate = self
        textExpDate.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     */
    
    @IBAction func saveButtonIsClicked(_ sender: UIBarButtonItem) {
        if textCardName.text != nil && textCardNumber.text != nil && textCvv2 != nil && textExpDate != nil{
            let cardName = textCardName.text!
            let cardNumber = Int(textCardNumber.text!)
            let cvv2 = Int(textCvv2.text!)
            let expirationDate = textExpDate.text!
            card = Card(num: cardNumber!, crdName: cardName, exprdate: expirationDate, cvv2: cvv2!,bankName: "pasargad")
            self.performSegue(withIdentifier: "unwindtolist", sender: self)
        }
    }
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
