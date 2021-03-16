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
    
    var score: Double = 0 {
        didSet {
            //UPDATE SCORE ON UI
        }
    }
    
    var isPlayingStateObservation: NSKeyValueObservation?
    
    var keywords = ["Road", "Bus", "Engine", "Bottle", "Car", "Microwave", "Tent", "Fire"]
    var keyword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.isEnabled = false
        keyword = keywords[Int.random(in: 0..<keywords.count)]
    }
    
    func startRecording() {
        let audioAnalyzer = AudioAnalyzer()
        try! audioAnalyzer.startRecognition()
        recordButton.setTitle("Stop Recording", for: .normal)
        analyzer = audioAnalyzer
        playButton.isEnabled = false
    }
    
    func stopRecording() {
        if let result = analyzer?.stopRecognition(), let keyword = keyword {
            print(result)
            ///Separate into individual words
            score = CalculateScore().computeTotalDistance(keyword: keyword, userInput: result.split{$0 == " "}.map(String.init))
        }
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

