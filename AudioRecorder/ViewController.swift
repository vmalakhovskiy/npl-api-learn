//
//  ViewController.swift
//  AudioRecorder
//
//  Created by Sandhya Kundapur on 08/02/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var playButton: UIButton!
    
    var analyzer: AudioAnalyzer?
    
    var isPlayingStateObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    func startRecording() {
        let audioAnalyzer = AudioAnalyzer()
        try! audioAnalyzer.startRecognition()
        recordButton.setTitle("Stop Recording", for: .normal)
        analyzer = audioAnalyzer
        playButton.isEnabled = false
    }
    
    func stopRecording() {
        let result = analyzer?.stopRecognition()
        print(result)
        recordButton.setTitle("Start Recording", for: .normal)
        playButton.isEnabled = true
    }
    
    @IBAction func record(sender: Any) {
        guard let analyzer = analyzer else {
            startRecording()
            return
        }
        analyzer.recording == true ? stopRecording() : startRecording()
    }
    
    @IBAction func play(sender: Any) {
//        guard let player = audioPlayer else {
//            startPlayback()
//            return
//        }
//        player.isPlaying == true ? stopPlayback() : startPlayback()
    }
    
    
}

