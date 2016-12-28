//
//  SignInVC.swift
//  mypay
//
//  Created by Hessam on 12/7/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import UIKit

class SignInVC: UIViewController,UITextFieldDelegate {

    //MARK: properties
    @IBOutlet weak var textusername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var buttonSignin: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var username: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textPassword.delegate = self
        textusername.delegate = self
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        buttonSignin.isEnabled = true
        return true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        buttonSignin.isEnabled = false
    }
    
    @IBAction func signInClicked(_ sender: UIButton) {
        indicator.startAnimating()
        let srvEndpoint: String = "http://hessam/signin"
        guard let srvURL = URL(string: srvEndpoint) else {
            return
        }
        var srvUrlRequest = URLRequest(url: srvURL)
        srvUrlRequest.httpMethod = "POST"
        
        self.username = textusername.text
        self.password = textPassword.text
        let username = textusername.text
        let password = textPassword.text
        
        let body = BodyMaker()
        body.appednKeyValue(key: "username", value: username!)
        body.appednKeyValue(key: "password", value: password!)
        
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
                self.indicator.stopAnimating()
                self.present(alertController, animated: true, completion: nil)
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
                    //print("Could not get resultcode as int from JSON")
                    
                    return
                }
                serverResultCode = resutlCode
                
            } catch  {
                //print("error parsing response from POST on /registration")
                return
            }
            if serverResultCode == 200
            {
                let defaults = UserDefaults.standard
                defaults.set(true, forKey: "authenticated")
                defaults.set(self.username, forKey: "username")
                defaults.set(self.password, forKey: "password")
                self.performSegue(withIdentifier: "goToMainVC", sender: self)
            }else if serverResultCode == 101 {
                let alertController = UIAlertController(title: "Authentication Failed", message: "Your username or password is incorrect!", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "Try again", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.indicator.stopAnimating()
                self.present(alertController, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "Internal Error", message: "Check your internet connection, or try later!", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "Try again", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.indicator.stopAnimating()
                self.present(alertController, animated: true, completion: nil)
            }
        }
        task.resume()
    }

}
