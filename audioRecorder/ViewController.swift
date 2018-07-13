
import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    // MARK: - Properties
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var audioSession = AVAudioSession.sharedInstance()
    
    // File properties
    let fileName = "file.m4a"
    var filePath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1 - Setup your file name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddd HH:mm:ss"
        let dateTimeStamp = dateFormatter.string(from: Date())
        filePath = "recording-" + dateTimeStamp + "-" + fileName
        
        // 2 prepare a record session
        self.setupRecorder()
        
    }

    // MARK: - IBActions
    @IBAction func recordAudio(_ sender: Any) {
        do{
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
        }
        catch let err{
            print("Playback Error has occured: \(err)")
        }
        if recorder.isRecording{
            print("stopped recording")
            recorder.stop()
        }
        else{
            print("recording")
            recorder.record()
        }
        
    }
    
    @IBAction func playAudio(_ sender: Any) {
        do{
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch let err{
            print("Playback Error has occured: \(err)")
        }
        self.prepareAudioPlayer()
        
        if recorder.isRecording{
            recorder.stop()
        }
        
        if player.isPlaying{
            print("player is playing")
            player.currentTime = 0.0
        }
        else{
            print("player is playing")
            player.play()
        }
    }
}

extension ViewController{
    // MARK: - Helper functions
    func setupRecorder(){
        let settings = [AVFormatIDKey: kAudioFormatAppleLossless,
                        AVSampleRateKey: 12000,
                        AVNumberOfChannelsKey: 1,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue] as [String : Any]
        do {
            recorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
            recorder.record(forDuration: 30.0)
            recorder.delegate = self
        }
        catch let errr{
            print(errr)
        }
    }
    
    func getCacheDirectory() -> String{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return path[0]
    }
    
    func getFileUrl() -> URL{
        let fileUrl = URL(fileURLWithPath: getCacheDirectory()).appendingPathComponent(filePath)
        return fileUrl
    }
    
    func prepareAudioPlayer(){
        do {
            player = try AVAudioPlayer(contentsOf: getFileUrl())
            player.volume = 1.0
            player.delegate = self
        }
        catch let err{
            print("player errr \(err)")
        }
    }
}

