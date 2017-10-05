
import UIKit
import AVFoundation

class WaveViewController: UIViewController {
    var waveformView:SCSiriWaveformView!
    var recorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bounds = UIScreen.mainScreen().bounds
        
        waveformView = SCSiriWaveformView(frame: CGRectMake(0, 0, bounds.width, bounds.height))
        waveformView.waveColor = UIColor.whiteColor()
        waveformView.primaryWaveLineWidth = 3.0
        waveformView.secondaryWaveLineWidth = 1.0
        self.view.addSubview(waveformView)
        
        var url:NSURL = NSURL(fileURLWithPath: "/dev/null")!
        var settings:NSDictionary = [
            AVSampleRateKey: 44100.0,
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue
        ]
        
        var error:NSErrorPointer = NSErrorPointer()
        recorder = AVAudioRecorder(URL: url, settings: settings, error: error)
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, error: error)
        
        recorder.prepareToRecord()
        recorder.meteringEnabled = true
        recorder.record()
        
        var displayLink:CADisplayLink = CADisplayLink(target: self, selector: Selector("updateMeters"))
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func updateMeters() {
        recorder.updateMeters()
        let normalizedValue:CGFloat = pow(10, CGFloat(recorder.averagePowerForChannel(0))/20)
        waveformView.updateWithLevel(normalizedValue)
    }
}
