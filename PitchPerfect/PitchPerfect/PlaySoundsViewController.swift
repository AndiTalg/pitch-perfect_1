//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Andreas Talg on 22.03.15.
//  Copyright (c) 2015 Andreas Talg. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var receivedAudio: RecordedAudio!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create instance of audio player for playback with different rates
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        // Create instance of audio enginge for playback with different pitches
        audioEngine = AVAudioEngine()
        
        // Audiofile to play back by AVAudioEngine
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Play buttons
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio (0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudio (1.5)    
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
   
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    // Stop playing
    @IBAction func stopPlayingAudio(sender: UIButton) {
        stopAllOutputs()
    }
    
    // Play audio with different rates using AVAudioPlayer
    func playAudio (rate: Float) {
        
        // Stop previous playing of audio engine
        stopAllOutputs()
        // Restart audio player with new rate
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    // Play audio with pitch effect using AVAudioEngine
    func playAudioWithVariablePitch(pitch: Float) {
       
        // Stop previously playing
        stopAllOutputs()
        
        // Create standard player node
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Create node for pitch effect
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // Connect nodes to active audio chain
        audioEngine.connect(audioPlayerNode, to:changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // Schedule and start playing
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    // Stop all audio outputs
    func stopAllOutputs () {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
}
