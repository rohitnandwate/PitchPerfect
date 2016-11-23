//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Nandwate, Rohit on 11/11/16.
//  Copyright © 2016 Nandwate, Rohit. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var startRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    var audioRecorder: AVAudioRecorder!
    
    enum RecordingState { case notRecording, recording}
    
    // MARK: Constants
    
    struct ConstantStrings {
        static let DismissAlert = "Dismiss"
        static let RecordingName = "recordedVoice.wav"
        static let RecordingInProgress = "Recording in progress"
        static let StartRecording = "Tap to Record"
        static let RecordingSuccess = "Recroding completed and saved"
        static let RecordingFailedMessage = "Something went wrong with your recording."
        static let AudioRecorderError = "Audio Recorder Error"
        static let AudioSessionError = "Audio Session Error"
        static let AudioRecordingError = "Audio Recording Error"
        static let AudioFileError = "Audio File Error"
        static let AudioEngineError = "Audio Engine Error"
    }
    
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
    let segueID = "stopRecordingSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(_ sender: AnyObject) {
        configureUI(.recording)
        
        let pathArray = [dirPath, ConstantStrings.RecordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }
    @IBAction func stopRecordingAudio(_ sender: AnyObject) {
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
        
        configureUI(.notRecording)
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print(ConstantStrings.RecordingSuccess)
            performSegue(withIdentifier: segueID, sender: recorder.url)
        } else {
            print(ConstantStrings.RecordingFailedMessage)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID {
            let playSoundsVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordingURL = recordedAudioURL
        }
    }
    
    // MARK: UI Functions
    
    func configureUI(_ recordingState: RecordingState) {
        switch(recordingState) {
        case .recording:
            recordingLabel.text = ConstantStrings.RecordingInProgress
            startRecordingButton.isEnabled = false
            stopRecordingButton.isEnabled = true
        case .notRecording:
            recordingLabel.text = ConstantStrings.StartRecording
            startRecordingButton.isEnabled = true
            stopRecordingButton.isEnabled = false

        }
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ConstantStrings.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

