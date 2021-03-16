//
//  ViewController.swift
//  AudioRecorder
//
//  Created by Sandhya Kundapur on 08/02/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var recordButton: UIButton!
//    @IBOutlet var playButton: UIButton!
    
    @IBOutlet var helloLabel: UILabel!
    @IBOutlet var wordLabel: UILabel!
    
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    var timeLeft: TimeInterval = 30
    var endTime: Date?
    var timeLabel =  UILabel()
    var timer = Timer()
    // here you create your basic animation object to animate the strokeEnd
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    
    var analyzer: AudioAnalyzer?
    
    var score: Double = 0 {
        didSet {
            //UPDATE SCORE ON UI
            self.wordLabel.text = String(score)
        }
    }
    
    var isPlayingStateObservation: NSKeyValueObservation?
    
    var keywords = ["Road", "Bus", "Engine", "Bottle", "Car", "Microwave", "Tent", "Fire"]
    var keyword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        playButton.isEnabled = false
        keyword = keywords[Int.random(in: 0..<keywords.count)]
        
        recordButton.layer.cornerRadius = 30
        addTimeLabel()
    }
    
    func deg2rad(_ number: Double) -> CGFloat {
        return CGFloat(number * .pi / 180)
    }
    
    func drawBgShape() {
        let start = deg2rad(-90)
        let end = deg2rad(270)
   
        bgShapeLayer.path = UIBezierPath(
            arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY),
            radius: 100,
            startAngle: start,
            endAngle: end,
            clockwise: true
        ).cgPath
        
        bgShapeLayer.strokeColor = UIColor.init(white: 235/255, alpha: 1).cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 5
        view.layer.addSublayer(bgShapeLayer)
    }
    func drawTimeLeftShape() {
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius:
            100, startAngle: deg2rad(-90), endAngle: deg2rad(270), clockwise: true).cgPath
        timeLeftShapeLayer.strokeColor = UIColor.black.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = 5
        view.layer.addSublayer(timeLeftShapeLayer)
    }
    
    func addTimeLabel() {
        timeLabel = UILabel(frame: CGRect(x: view.frame.midX-50 ,y: view.frame.midY-25, width: 100, height: 50))
        timeLabel.textAlignment = .center
        timeLabel.text = ""
        view.addSubview(timeLabel)
    }
    
    func startRecording() {
        let audioAnalyzer = AudioAnalyzer()
        try! audioAnalyzer.startRecognition()
        recordButton.setTitle("Stop Recording", for: .normal)
        analyzer = audioAnalyzer
//        playButton.isEnabled = false
        
        UIView.animate(withDuration: 0.1) {
            self.recordButton.alpha = 0
        }
        
        helloLabel.text = "say as many similar words to"
        wordLabel.text = ["apple", "google", "amazon", "netflix"].randomElement()?.uppercased()
        
        drawBgShape()
        drawTimeLeftShape()
        timeLeft = 30
        // here you define the fromValue, toValue and duration of your animation
        strokeIt.fromValue = 0
        strokeIt.toValue = 1
        strokeIt.duration = timeLeft
        // add the animation to your timeLeftShapeLayer
        timeLeftShapeLayer.add(strokeIt, forKey: nil)
        // define the future end time by adding the timeLeft to now Date()
        endTime = Date().addingTimeInterval(timeLeft)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    
    func stopRecording() {
        if let result = analyzer?.stopRecognition(), let keyword = keyword {
            print(result)
            ///Separate into individual words
            score = CalculateScore().computeTotalDistance(keyword: keyword, userInput: result.split{$0 == " "}.map(String.init))
        }
        recordButton.setTitle("Start Recording", for: .normal)
//        playButton.isEnabled = true
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
    
    @objc func updateTime() {
        if timeLeft > 0 {
            timeLeft = endTime?.timeIntervalSinceNow ?? 0
            timeLabel.text = timeLeft.time
        } else {
            timeLabel.text = ""
            timer.invalidate()
            gameFinished()
        }
    }
    
    func gameFinished() {
        timeLabel.text = ""
        helloLabel.text = "congratz"
        wordLabel.text = "your score is 5 words"
        
        UIView.animate(withDuration: 0.1) {
            self.recordButton.alpha = 1
            self.recordButton.setTitle("Play again", for: .normal)
        }
    }
    
    
}

extension TimeInterval {
    var time: String {
        return String(format:"%02d:%02d", Int(self/60),  Int(ceil(truncatingRemainder(dividingBy: 60))) )
    }
}
extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}


