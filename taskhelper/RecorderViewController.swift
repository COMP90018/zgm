//
//  RecorderViewController.swift
//  FaceIdentification
//
//  Created by 奇奇 on 2017/9/24.
//  Copyright © 2017年 MelbUni. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class RecorderViewController: UIViewController, AVAudioRecorderDelegate{
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    var filename: URL!
    
    @IBOutlet weak var buttonLabel: UIButton!
    
    //@IBOutlet weak var buttonLabel: UIButton!
    
    @IBAction func record(_ sender: Any) {
        //check if we have an active recorder
        if audioRecorder == nil{
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            self.filename = docDir.appendingPathComponent("voice.m4a")
            
            //start recording
            do{
                audioRecorder = try AVAudioRecorder(url: self.filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                //change the title of the label
                buttonLabel.setTitle("Stop recording", for: .normal)
            }catch{
                displayAlert(title: "Error", message: "Recording failed")
            }
        }
        else{
            //stoping recording
            audioRecorder.stop()
            audioRecorder = nil
            
            buttonLabel.setTitle("Start Recording", for: .normal)
            
            
            
            //recognize the text in the speech
            SFSpeechRecognizer.requestAuthorization { authStatus in
                if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized{
                    
                    let recognizer = SFSpeechRecognizer()
                    
                    let request = SFSpeechURLRecognitionRequest(url: self.filename)
                    recognizer?.recognitionTask(with: request){ (result, error) in
                        if let error = error{
                            print("There was an error in voiceCode: \(error)")
                        }else{
                            print(result?.bestTranscription.formattedString)
                            let writeString = result?.bestTranscription.formattedString as! String
                            let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                            let textPath = docDir.appendingPathComponent("text")
                            
                            do {
                                // Write to the file
                                try writeString.write(to: textPath, atomically: true, encoding: String.Encoding.utf8)
                            } catch {
                                print("Failed")
                            }
                            
                        }
                        
                    }
                }
            }
            
            
            
            let secondRecord = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "secondRecord") as! SecondRecordViewController
            
            DispatchQueue.main.async {
                self.present(secondRecord, animated: true, completion: nil)
            }
            
            
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting up session
        recordingSession = AVAudioSession.sharedInstance()
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission{
                print("ACCEPTED")
            }
        }
    }
    
    // display an alert
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
}

