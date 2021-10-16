//
//  ViewController.swift
//  Recorder
//
//  Created by Brian Marx on 10/16/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    var session: AVAudioSession!
    var recorder: AVAudioRecorder!
    var recording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        session = AVAudioSession.sharedInstance()

        do {
            try session.setCategory(.record, mode: .spokenAudio)
            try session.setActive(true)
            session.requestRecordPermission() {  allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Thank you")
                    } else {
                        print("I didn't like you anyway.")
                    }
                }
            }
        } catch {
            print("Failure")
        }
    }

    @IBAction func recordButtonPressed(_ sender: UIButton) {
        recording = !recording
        print(recording)
        if recording {
            startRecording()
            
            recordButton.setTitle("Recording", for: .normal)
            recordButton.backgroundColor = .red
        } else {
            finishRecording()
            recordButton.setTitle("Record", for: .normal)
            recordButton.backgroundColor = .black
        }
        
    }
    
    func startRecording() {
        let audioURL = getDocumentsDirectory().appendingPathComponent("recordingFileName.wav")
            print(audioURL.absoluteString)

        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: Int(441000),
            AVNumberOfChannelsKey: 1,
//            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            recorder = try AVAudioRecorder(url: audioURL, settings: settings)
            recorder.delegate = self
            recorder.prepareToRecord()
            recorder.record()
        } catch let error {
            print("recorder failure " + error.localizedDescription)
        }
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording()
        }
    }
    
    func finishRecording() {
        if let record = recorder {
                    if record.isRecording {
                        recorder?.stop()
//                        let audioSession = AVAudioSession.sharedInstance()
                        do {
                            try session.setActive(false)
                        } catch _ {
                        }
                    }
                }
        
        recorder.stop()
        recorder = nil
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}

