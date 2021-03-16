
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
