//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Andreas Talg on 22.03.15.
//  Copyright (c) 2015 Andreas Talg. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading    the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Update user interface to state "Ready to record"
        stopButton.hidden = true
        recordingInProgress.text = "Tap to record ..."
        recordButton.enabled = true
    }

    // User touched record button -> record audio
    @IBAction func recordAudio(sender: UIButton) {
        
        // Update user interface to state "Recording in progress"
        recordingInProgress.text = "Recording in Progress ..."
        stopButton.hidden = false
        recordButton.enabled = false

        // Create file path to store recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        // Prepare play and record session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Prepare audio recorder and start recording
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()

    }

    // User finished recording by pressing stop button
    @IBAction func stopAudioRecording(sender: UIButton) {
        // User pressed stop button : stop recording and end audio session
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    // Recording finished -> proceed to play scene
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            // If successful recording create audio object and switch to play audio scene
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            // If recording not successful return to state "Ready to record"
            println("Recording was not successful")
            stopButton.hidden = true
            recordingInProgress.text = "Tap to record ..."
            recordButton.enabled = true
        }
    }
}

