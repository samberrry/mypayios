//
//  QRScannerVC.swift
//  mypay
//
//  Created by Hessam on 12/9/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerVC: UIViewController ,AVCaptureMetadataOutputObjectsDelegate{
    //MARK: Properties
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelStore: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()

        //QR-scanner initialization code
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        labelStore.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        if (captureSession?.isRunning == false) {
//            captureSession.startRunning();
//        }
        
        if  Store.state {
            let storename = Store.name
            let alertController = UIAlertController(title: "Message", message: "you are at: \(storename)", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "let's scann", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                print("OK")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            Store.state = false
            view.layer.addSublayer(previewLayer)
            captureSession.startRunning()
        }else if Store.name != nil{
            view.layer.addSublayer(previewLayer)
            captureSession.startRunning()
        }else {
            let alertController = UIAlertController(title: "Failure", message: "Location detection failed!", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "try later", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                print("OK")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            
            return
        }
        
        // Get the metadata object.(QR content)
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            
            if metadataObj.stringValue != nil {
                let qrData = metadataObj.stringValue
                let data: NSData = qrData!.data(using: String.Encoding.utf8)! as NSData
                do{
                    guard let receivedData = try JSONSerialization.jsonObject(with: data as Data,options: []) as? [String: Any] else {
                        // print("Could not get JSON from responseData as dictionary")
                        return
                    }
                    guard let goodsid = receivedData["goodsid"] as? Int else {
                        // print("Could not get resultcode as int from JSON")
                        return
                    }
                    guard let goodsname = receivedData["goodsname"] as? String else {
                        // print("Could not get resultcode as int from JSON")
                        return
                    }
                    guard let price = receivedData["price"] as? Int else {
                        // print("Could not get resultcode as int from JSON")
                        return
                    }
                    guard let description = receivedData["description"] as? String else {
                        // print("Could not get resultcode as int from JSON")
                        return
                    }
                    let goods = Goods(goodsid: goodsid, name: goodsname, price: price, description: description)
                    
                    //presenting alert
                    let alertController = UIAlertController(title: "\(goods.name)", message: "Price: \(goods.price)$ \n Description: \(goods.description)", preferredStyle: UIAlertControllerStyle.actionSheet)
                    
                    let okAction = UIAlertAction(title: "Discard", style: .default) { (action: UIAlertAction) -> Void in
                        alertController.dismiss(animated: true, completion: nil)
                    }
                    let cancelAction = UIAlertAction(title: "Add to list", style: .cancel) { (action: UIAlertAction) -> Void in
                    self.addItemToBillList(goods: goods)
                    }
                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }catch{}
            }
        }
    }
    
    func addItemToBillList(goods: Goods) {
        MainTableVC.goodsList.append(goods)
    }
    
    func found(code: String) {
        print(code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}
