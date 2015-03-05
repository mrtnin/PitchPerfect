//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Martin on 05.03.15.
//  Copyright (c) 2015 martin. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioPlayer.prepareToPlay()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        session.overrideOutputAudioPort(.Speaker, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlow(sender: UIButton) {
        stopAndResetPlayerAndEngine()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

    @IBAction func playFast(sender: UIButton) {
        stopAndResetPlayerAndEngine()
        audioPlayer.rate = 1.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        var echoPreset = AVAudioUnitDistortionPreset.MultiEcho2
        var echoEffect = AVAudioUnitDistortion()
        echoEffect.loadFactoryPreset(echoPreset)
        echoEffect.wetDryMix = 50
        playAudioWithEffect(echoEffect)
        
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        var reverbPreset = AVAudioUnitReverbPreset.Cathedral
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(reverbPreset)
        reverbEffect.wetDryMix = 50
        playAudioWithEffect(reverbEffect)
        
    }
    
    func playAudioWithEffect(effect: AVAudioUnitEffect) {
        stopAndResetPlayerAndEngine()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.attachNode(effect)
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        stopAndResetPlayerAndEngine()
        
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAndResetPlayerAndEngine()
    }
    
    func stopAndResetPlayerAndEngine() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

}
