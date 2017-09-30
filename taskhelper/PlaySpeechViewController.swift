//
//  PlaySpeechViewController.swift
//  FaceIdentification
//
//  Created by 奇奇 on 2017/9/25.
//  Copyright © 2017年 MelbUni. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class PlaySpeechViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var path: URL!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSpeech(_ sender: Any) {
        //play the recording
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        self.path = docDir.appendingPathComponent("voice.m4a")
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: self.path)
            audioPlayer.play()
        }
        catch{
            print("error playing the recording")
        }
        
        
        //recognize the text in the speech
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized{

                let recognizer = SFSpeechRecognizer()

                let request = SFSpeechURLRecognitionRequest(url: self.path)
                recognizer?.recognitionTask(with: request){ (result, error) in
                    if let error = error{
                        print("There was an error in voiceCode: \(error)")
                    }else{
                        print(result?.bestTranscription.formattedString)
                        let writeString = result?.bestTranscription.formattedString as! String
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
        
    }    

}
