//
//  CameraViewController.swift
//  FaceIdentification
//
//  Created by 奇奇 on 2017/9/17.
//  Copyright © 2017年 MelbUni. All rights reserved.
//

import UIKit
import AVFoundation
import ProjectOxfordFace
import AZSClient
import MicrosoftAzureMobile




class VerifyViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var buttonLabel: UIButton!
    
    
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var verifyView: UIView!
    
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    

    var personImage: UIImage!
    var emptyImage: UIImage!
    
    var faceFromPhoto: MPOFace!
    var faceFromDoc: MPOFace!
    var imageURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activitySpinner.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let deviceSession = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInDuoCamera, .builtInTelephotoCamera, .builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified)
        
        for device in (deviceSession?.devices)!{
            
            if device.position == AVCaptureDevicePosition.front{
                
                do{
                    
                    let input = try AVCaptureDeviceInput(device:device)
                    
                    if captureSession.canAddInput(input){
                        
                        captureSession.addInput(input)
                        
                        if captureSession.canAddOutput(sessionOutput){
                            captureSession.addOutput(sessionOutput)
                            
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            previewLayer.connection.videoOrientation = .portrait
                            
                            verifyView.layer.addSublayer(previewLayer)
                            verifyView.addSubview(button)
                            verifyView.addSubview(activitySpinner)
                            
                            
                            previewLayer.position = CGPoint(x: self.verifyView.frame.width/2, y: self.verifyView.frame.height/2)
                            previewLayer.bounds = verifyView.frame
                            
                            captureSession.startRunning()
                            
                        }
                    }
                    
                }catch let avError{
                    print(avError)
                }
                
            }
        }
    }
    
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error{
            print(error.localizedDescription)
            return
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = photoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer){
            
            self.personImage = UIImage(data: dataImage)!
            
            let client = MPOFaceServiceClient(subscriptionKey: "9980ec7e4bf241579b5388433ea45436")!
            
            let data = UIImageJPEGRepresentation(self.personImage, 0.8)
            
            
            //Detect if the photo meet the requirements
            
            client.detect(with: data!, returnFaceId: true, returnFaceLandmarks: true, returnFaceAttributes: [], completionBlock: { (faces, error) in
                
                print("detecting faces")
                print(faces!.count)
                
                if error != nil{
                    print(error)
                    return
                }
                
                if(faces!.count)>1 || faces == nil{
                    print("too many faces")
                    return
                }
                
                
                /*
                if let image = UIImage(data: dataImage) {

                    //display the photo
                    
                    let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verifyPhoto") as! VerifyPhotoViewController
                    
                    photoVC.image = image
                    
                    DispatchQueue.main.async {
                        self.present(photoVC, animated: true, completion: nil)
                    }
                }
*/
                
            })
            
            captureSession.startRunning()
           // previewLayer.removeFromSuperlayer()
            
        }
        self.verify()
    }
    
    
    
    
    func verify(){
        
        let client = MPOFaceServiceClient(subscriptionKey: "9980ec7e4bf241579b5388433ea45436")!
        
        let data = UIImageJPEGRepresentation(self.personImage, 0.8)
        
        client.detect(with: data, returnFaceId: true, returnFaceLandmarks: true, returnFaceAttributes: [], completionBlock: { (faces, error) in
            
            if error != nil{
                print(error!)
                return
            }
            
            print(faces!.count)
            
            if(faces!.count) != 1{
                print("no face decteted or too many faces")
                return
            }
            
            self.faceFromPhoto = faces![0]
            
            //load the photo from the document directory
            
            let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            self.imageURL = docDir.appendingPathComponent("tmp.jpeg")
            
            
            let docPhoto = UIImage(contentsOfFile: self.imageURL.path)!
            let docData = UIImageJPEGRepresentation(docPhoto, 0.8)
            
            client.detect(with: docData, returnFaceId: true, returnFaceLandmarks: true, returnFaceAttributes: [], completionBlock: { (faces, error) in
                
                if error != nil{
                    print(error!)
                    return
                }
                
                self.faceFromDoc = faces![0]
                
                client.verify(withFirstFaceId: self.faceFromPhoto.faceId, faceId2: self.faceFromDoc.faceId, completionBlock: { (result, error) in
                    
                    if error != nil{
                        print(error!)
                        return
                    }
                    
                    if result!.isIdentical{
                        //same person
                        print("same person")
   
                        let verifySucc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verifySuccessfully") as! VerifySuccViewController
                        
                        DispatchQueue.main.async {
                            self.present(verifySucc, animated: true, completion: nil)
                        }
                        
                        self.activitySpinner.stopAnimating()
                        self.activitySpinner.isHidden = true
                        
                        
                    }else{
                        //not the same person
                        print("not the same person")
                        
                        let verifyUnsucc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verifyUnsuccessful") as! VerifyUnsuccViewController
                        
                        DispatchQueue.main.async {
                            self.present(verifyUnsucc, animated: true, completion: nil)
                        }
                        
                    }
                    
                })
                
            })
            
        })
    }
    
    
    
    @IBAction func verifyThePhoto(_ sender: Any) {
        buttonLabel.setTitle("Verifying......", for: .normal)
        activitySpinner.isHidden = false
        activitySpinner.startAnimating()
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.__availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType, kCVPixelBufferWidthKey as String: 160, kCVPixelBufferHeightKey as String:160]
        
        settings.previewPhotoFormat = previewFormat
        sessionOutput.capturePhoto(with: settings, delegate: self)
    }
    

    
}
