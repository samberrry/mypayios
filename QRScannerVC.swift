//
//  QRScannerVC.swift
//  mypay
//
//  Created by Hessam on 12/9/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class QRScannerVC: UIViewController ,AVCaptureMetadataOutputObjectsDelegate,
    CLLocationManagerDelegate{
    //MARK: Properties
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelStore: UILabel!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "163EB541-B100-4BA5-8652-EB0C513FB0F4")! as UUID , identifier: "mypay")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        
        //captureSession.startRunning();
        
        labelStore.isEnabled = false
        //iBeacon initialization code
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoring(for: region)
        
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
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning();
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
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            
            if metadataObj.stringValue != nil {
                var myStr: String?
                myStr = metadataObj.stringValue
                let alertController = UIAlertController(title: "Metadata scanned", message: myStr, preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
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
    
    //MARK: iBeacon Ranging
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        labelLocation.isEnabled = false
        labelStore.isEnabled = true
        //
        let knownBeacon = beacons[0]
        let serverResult: String?
        serverResult = notifyEntryToServer(uuid: knownBeacon.proximityUUID.uuidString, major: knownBeacon.major.intValue, minor: knownBeacon.minor.intValue)
        if let currentStore = serverResult {
            labelStore.text = currentStore
            captureSession.startRunning();
            //**
        }else{
            let alertController = UIAlertController(title: "Server Error", message: "Beacon detection failed", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "try later", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                print("OK")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            dismiss(animated: true, completion: nil)
        }
    }
    
    //
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        let alertController = UIAlertController(title: "Failure", message: "Beacon monitoring failed!", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "try later", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)    }
    //
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alertController = UIAlertController(title: "Failure", message: "Location Manager failed!", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "try later", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    //
    func notifyEntryToServer(uuid: String,major: Int,minor: Int) -> String {
        return " "
    }
    
    func notifyExitToServer() -> Int? {
        return nil
    }
    
}
