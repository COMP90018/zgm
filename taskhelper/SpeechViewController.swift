//
//  SpeechViewController.swift
//  FaceIdentification
//
//  Created by 奇奇 on 2017/9/24.
//  Copyright © 2017年 MelbUni. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class SpeechViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var transcriptionTextField: UITextView!
    
    @IBOutlet weak var buttonLabel: UIButton!
    
    var audioPlayer: AVAudioPlayer!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var verifyString: String!
    var readString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activitySpinner.isHidden = true
        
        //setting up session
        recordingSession = AVAudioSession.sharedInstance()
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission{
                print("ACCEPTED")
            }
        }
    }    
    
    func requestSpeechAuth(){

        //check if we have an active recorder
        if audioRecorder == nil{
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let filename = docDir.appendingPathComponent("verify.m4a")
            
            //start recording
            do{
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                //change the title of the label
                buttonLabel.setTitle("Recording...", for: .normal)
            }catch{
                displayAlert(title: "Error", message: "Recording failed")
            }
        }
        else{
            //stoping recording
            audioRecorder.stop()
            audioRecorder = nil
            
            buttonLabel.setTitle("Verify Voice Code", for: .normal)
            self.activitySpinner.stopAnimating()
            self.activitySpinner.isHidden = true
        

        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized{
                
                let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
 
                //load the verifyCode file
                let verifyCode = docDir.appendingPathComponent("verify.m4a")
                
                let textPath = docDir.appendingPathComponent("Vtext")
  
                //recognize the verifyCode file
                let recognizer = SFSpeechRecognizer()
                let request = SFSpeechURLRecognitionRequest(url: verifyCode)
                recognizer?.recognitionTask(with: request){ (result, error) in
                    if let error = error{
                        print("There was an error in voiceCode: \(error)")
                    }else{
                        if (result?.isFinal)!{
                        let writeString = result?.bestTranscription.formattedString as! String
                            
                            do {
                                // Write to the file
                                try writeString.write(to: textPath, atomically: true, encoding: String.Encoding.utf8)
                            } catch {
                                print("writing Failed")
                            }
                        }
                    }
                }

                // Read the voiceCode
                let fileURL = docDir.appendingPathComponent("text")
                self.readString = ""
                self.verifyString = ""
                do {
                    self.readString = try String(contentsOf: fileURL)
                    self.verifyString = try String(contentsOf: textPath)
                    print("read:")
                    print(self.readString)
                    print("verify:")
                    print(self.verifyString)
                } catch{
                    print("reading Failed")
                }

                if self.readString == self.verifyString{
                    print("Speech Recognition Successful!")
                    
                    let verifySucc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verifySuccessfully") as! VerifySuccViewController
                    
                    DispatchQueue.main.async {
                        self.present(verifySucc, animated: true, completion: nil)
                    }
                    
                }else{
                    print("Speech Recognition unsuccessful. Please try again.")
                    
                    let verifyUnsucc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "voiceUnsuccessful") as! VerifyUnsuccViewController
                    
                    DispatchQueue.main.async {
                        self.present(verifyUnsucc, animated: true, completion: nil)
                    }
                    
                }
                }
            }
        }
    }
    
    // display an alert
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func playButton(_ sender: Any) {
        //make the spinner start spinning
        activitySpinner.isHidden = false
        activitySpinner.startAnimating()
        requestSpeechAuth()
    }
    
}
