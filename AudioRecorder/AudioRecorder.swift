
import Foundation
import AVFoundation

class AudioRecorder {
    
    private var audioRecorder: AVAudioRecorder?
    var recording = false
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
     
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            let recorder = try AVAudioRecorder(url: audioFileURL(), settings: settings)
            recorder.record()
            audioRecorder = recorder
            recording = true
        } catch {
            print("Could not start recording")
        }
    }
    
    func stopRecording() {
        guard let recorder = audioRecorder else {
            return
        }
        recorder.stop()
        recording = false
    }
    
    func audioFileURL() -> URL {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("recording.m4a")
        return audioFilename
    }
    
    func deleteRecording(url: URL) {
        do {
           try FileManager.default.removeItem(at: url)
        } catch {
            print("File could not be deleted!")
        }
    }
}

import Speech

class AudioAnalyzer {
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var stringResult: String?
    var recording = false
    
    func startRecognition() throws {
        stringResult = nil
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        
        let recognizer = SFSpeechRecognizer()
        recognitionTask = recognizer?.recognitionTask(with: recognitionRequest) { [weak self] (result, error) in
            var isFinal = false
            
            if let result = result {
                isFinal = result.isFinal
                self?.stringResult = result.bestTranscription.formattedString
            }
            
            if error != nil || isFinal {
                self?.audioEngine.stop()
                self?.audioEngine.inputNode.removeTap(onBus: 0)

                self?.recognitionRequest = nil
                self?.recognitionTask = nil
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
        recording = true
    }
    
    func stopRecognition() -> String? {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)

        recognitionRequest = nil
        recognitionTask = nil
        
        recording = false
        
        return stringResult
    }
}
