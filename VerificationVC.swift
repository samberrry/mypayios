//
//  VerificationVC.swift
//  mypay
//
//  Created by Hessam on 12/24/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import UIKit

class VerificationVC: UIViewController,UITextFieldDelegate {
    //MARK: Properties
    @IBOutlet weak var textVerification: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textVerification.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        verifyButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if !(textVerification.text!.isEmpty){
            verifyButton.isEnabled = true
        }
        return true
    }
    
    @IBAction func verifyIsClicked(_ sender: UIButton) {
        
        indicator.startAnimating()
        let srvEndpoint: String = "http://hessam/completesignup"
        guard let srvURL = URL(string: srvEndpoint) else {
            return
        }
        var srvUrlRequest = URLRequest(url: srvURL)
        srvUrlRequest.httpMethod = "POST"
        
        let random = textVerification.text!
        
        let body = BodyMaker()
        body.appednKeyValue(key: "random", value: random)
        
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
            if serverResultCode == 300
            {
                self.performSegue(withIdentifier: "goToMainVC", sender: self)
            }else {
                print("parameter error-APIException")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
