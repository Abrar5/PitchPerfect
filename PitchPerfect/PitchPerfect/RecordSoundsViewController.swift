//
//RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Abrar on 10/20/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
   
    

    func configureUI (recordingState: Bool){
      
        
        if recordingState == true
        {
             //RecordAudio
             recordingLabel.text = "recording in progress"
             stopRecordingButton.isEnabled = true
             recordButton.isEnabled = false
        }
        
         else if recordingState == false
        {
            //StopRecording
            recordingLabel.text = "Tap to Record"
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
       
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        
       super.viewWillAppear(animated)
       print("viewWillAppear called")
    }
    

    @IBAction func RecordAudio(_ sender: Any) {
   
        configureUI (recordingState: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    
    }

    @IBAction func StopRecording(_ sender: Any) {
        
        configureUI (recordingState: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
         try! audioSession.setActive(false)
    }
    
    // MARK: - Audio Recorder Delegate
    func audioRecorderDidFinishRecording (_ recorder:AVAudioRecorder, successfully flag: Bool)
    {
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
        print("recording was not successful")
        }
    }
    
    override func prepare (for Segue: UIStoryboardSegue, sender: Any?){
        if Segue.identifier == "stopRecording" {
        let playSoundsVC = Segue.destination as! PlaySoundsViewController
        let recordedAudioURL = sender as! URL
        playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
