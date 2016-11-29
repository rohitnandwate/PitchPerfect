//
//  PlaySoundViewController.swift
//  PitchPerfect
//
//  Created by Nandwate, Rohit on 11/12/16.
//  Copyright © 2016 Nandwate, Rohit. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {


    @IBOutlet weak var stopButton: UIButton!    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var darthVaderButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!

    var recordingURL: NSURL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("PlaySoundViewController loaded")
        setupAudio()
        setupSoundButtons()
    }
    
    func setupSoundButtons() {
        stopButton.imageView?.contentMode = .scaleAspectFit
        snailButton.imageView?.contentMode = .scaleAspectFit
        rabbitButton.imageView?.contentMode = .scaleAspectFit
        darthVaderButton.imageView?.contentMode = .scaleAspectFit
        chipmunkButton.imageView?.contentMode = .scaleAspectFit
        echoButton.imageView?.contentMode = .scaleAspectFit
        reverbButton.imageView?.contentMode = .scaleAspectFit
    }
    
    // MARK: Actions
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        print("Play Sound Button Pressed")
        
        switch ButtonType(rawValue: sender.tag)! {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        print("Stop Audio Button Pressed")
        stopAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI(.notPlaying)
    }
}
