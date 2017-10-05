//  SpeechViewController.swift
//  Author: Meng Qi
//  Declaration: the function was build based on the tutorials from the following sources:
//      Tutorial: https://www.youtube.com/watch?v=2gs5QTRC8Yk&t=101s
//      Source: https://bitbucket.org/team-devslopes/ios-10-speech-recognition-api
//      Tutorial: https://www.youtube.com/watch?v=FgCIRMz_3dE
//      Source: https://github.com/awseeley/Swift-Pop-Up-View-Tutorial
//      Tutorial: https://www.youtube.com/watch?v=hIW6atqmig0
//      Tutorial： https://www.youtube.com/watch?v=r-0YyveITWU&t=178s


import UIKit
import Speech
import AVFoundation

class SpeechViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet weak var buttonLabel: UIButton!
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    //@IBOutlet weak var transcriptionTextField: UITextView!
    
    
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
            
            myLabel.text = "Press the red button again to stop recording"
            
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
            
            buttonLabel.setTitle("Verifying Your Voice Code...", for: .normal)
            self.activitySpinner.stopAnimating()
            self.activitySpinner.isHidden = true
            
            let secondSpeech = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "secondSpeech") as! SecondSpeechViewController
            
            DispatchQueue.main.async {
                self.present(secondSpeech, animated: true, completion: nil)
            
            }
        }
    }
    
    // display an alert
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func verifyButton(_ sender: Any) {
        //make the spinner start spinning
        activitySpinner.isHidden = false
        activitySpinner.startAnimating()
        requestSpeechAuth()
    }
    
}

