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
    
    var audioRecorder: AudioRecorder?
    var audioPlayer: AudioPlayer?
    var isPlayingStateObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    func startRecording() {
        let recorder = AudioRecorder()
        recorder.startRecording()
        recordButton.setTitle("Stop Recording", for: .normal)
        audioRecorder = recorder
        playButton.isEnabled = false
        
    }
    
    func stopRecording(recorder: AudioRecorder) {
        recorder.stopRecording()
        recordButton.setTitle("Start Recording", for: .normal)
        playButton.isEnabled = true
    }
    
    func startPlayback() {
        guard let fileURL = audioRecorder?.audioFileURL() else {
            return
        }
        let player = AudioPlayer()
        player.startPlayback(audio: fileURL)
        playButton.setTitle("Stop Playback", for: .normal)
        audioPlayer = player
        isPlayingStateObservation?.invalidate()
        isPlayingStateObservation = player.observe(
            \.isPlaying,
            options: [.old, .new]
        ) { [weak self] object, change in
            guard let isPlaying = change.newValue else { return }
            if isPlaying == false {
                self?.updateStateAfterEndingPlayback()
            }
            
        }
        
    }
    
    func stopPlayback() {
        guard let player = audioPlayer else {
            return
        }
        player.stopPlayback()
        updateStateAfterEndingPlayback()
    }
    
    func updateStateAfterEndingPlayback() {
        playButton.setTitle("Start Playback", for: .normal)
        audioPlayer = nil
        isPlayingStateObservation?.invalidate()
    }
    
    @IBAction func record(sender: Any) {
        guard let recorder = audioRecorder else {
            startRecording()
            return
        }
        recorder.recording == true ? stopRecording(recorder: recorder) : startRecording()
    }
    
    @IBAction func play(sender: Any) {
        guard let player = audioPlayer else {
            startPlayback()
            return
        }
        player.isPlaying == true ? stopPlayback() : startPlayback()
    }
    
    
}

