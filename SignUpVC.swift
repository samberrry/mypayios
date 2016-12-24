//
//  ViewController.swift
//  mypay
//
//  Created by Hessam on 12/5/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController,UITextFieldDelegate,URLSessionDelegate{
    
    //Mark: UI Properties
    
    @IBOutlet weak var textAge: UITextField!
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textPhoneNumber: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var switchTerms: UISwitch!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    //MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textEmail.delegate = self
        textPassword.delegate = self
        textUsername.delegate = self
        textPhoneNumber.delegate = self
        textAge.delegate = self
        buttonSend.isEnabled = false
        switchTerms.isOn = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func sliderChanged(_ sender: UISlider) {
        let val = Int(slider.value)
        textAge.text = String(val)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        buttonSend.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if !(textPassword.text!.isEmpty) && !(textUsername.text!.isEmpty) && switchTerms.isOn
        {
            buttonSend.isEnabled = true
        }
        return true;
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if switchTerms.isOn
        {
            if !(textPassword.text!.isEmpty) && !(textUsername.text!.isEmpty)
            {
                buttonSend.isEnabled = true
            }else
            {
                let alertController = UIAlertController(title: "Notice", message: "please, fill in the username and password fields", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                buttonSend.isEnabled = false
                switchTerms.isOn = false
            }
        }else {
            buttonSend.isEnabled = false
        }
    }
    
    @IBAction func buttonIsClicked(_ sender: UIButton) {
        indicator.startAnimating()
        let srvEndpoint: String = "http://hessam/smsverification"
        guard let srvURL = URL(string: srvEndpoint) else {
            return
        }
        var srvUrlRequest = URLRequest(url: srvURL)
        srvUrlRequest.httpMethod = "POST"

        let username = textUsername.text
        let password = textPassword.text
        let phone = textPhoneNumber.text
        let age = textAge.text
        let email = textEmail.text
        
        let body = BodyMaker()
        body.appednKeyValue(key: "username", value: username!)
        body.appednKeyValue(key: "password", value: password!)
        body.appednKeyValue(key: "phone", value: phone!)
        body.appednKeyValue(key: "email", value: email!)
        body.appednKeyValue(key: "age", value: age!)
        
        let bodyString  = body.getBody()
        srvUrlRequest.httpBody = bodyString?.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: srvUrlRequest) {
            (data, response, error) in
            var serverResultCode: Int?
            guard error == nil else {
                let alertController = UIAlertController(title: "Network Error", message: "Check your internet connection, or try later!", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "Try again", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                self.indicator.stopAnimating()
                //  print("error calling POST on /registration")
//                print(error)
                return
            }
            guard let responseData = data else {
                //  print("Error: did not receive data")
                return
            }
            
            //  parse the result as JSON, since that's what the API provides
            do {
                guard let receivedData = try JSONSerialization.jsonObject(with: responseData,options: []) as? [String: Any] else {
                    // print("Could not get JSON from responseData as dictionary")
                    return
                }
                
                guard let resutlCode = receivedData["resultcode"] as? Int else {
//                    print("Could not get resultcode as int from JSON")
                    
                    return
                }
                serverResultCode = resutlCode
                
            } catch  {
//                print("error parsing response from POST on /registration")
                return
            }
            if serverResultCode == 700
            {
                self.performSegue(withIdentifier: "goToVerificationVC", sender: self)
            }else if serverResultCode == 701 {
               print("parameter error-APIException")
                let alertController = UIAlertController(title: "Internal Error", message: "problem with SMS verification", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "Try again", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                print("SMS WebService error")
                let alertController = UIAlertController(title: "Internal Error", message: "problem with SMS verification", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "Try again", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            self.indicator.stopAnimating()
        }
        task.resume()
    }
    
}

