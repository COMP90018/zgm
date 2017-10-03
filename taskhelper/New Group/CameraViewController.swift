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



enum PhotoType{
    case takeAPhoto
    case verifyThePhoto
}

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var button: UIButton!

    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    var photoType: PhotoType!
    var personImage: UIImage!
    var emptyImage: UIImage!
    
    var faceFromPhoto: MPOFace!
    var faceFromDoc: MPOFace!
    var imageURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
                            
                            cameraView.layer.addSublayer(previewLayer)
                            cameraView.addSubview(button)
                            
                            previewLayer.position = CGPoint(x: self.cameraView.frame.width/2, y: self.cameraView.frame.height/2)
                            previewLayer.bounds = cameraView.frame
                            
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
            print(error)
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
                
                if let image = UIImage(data: dataImage) {
                    
                    //display the photo
                    
                    let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
                    
                    photoVC.takenPhoto = image
                    
                    DispatchQueue.main.async {
                        self.present(photoVC, animated: true, completion: nil)
                    }
                }
                
            })
            
            captureSession.startRunning()
            previewLayer.removeFromSuperlayer()
            
        }
    }
    
    
    @IBAction func takePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.__availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType, kCVPixelBufferWidthKey as String: 160, kCVPixelBufferHeightKey as String:160]
        
        settings.previewPhotoFormat = previewFormat
        sessionOutput.capturePhoto(with: settings, delegate: self)
    }
    
    
}

