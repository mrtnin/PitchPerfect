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
        
        //Init the audiPlayer with the url from the receivedAudio instance
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        
        audioPlayer.enableRate = true
        audioPlayer.prepareToPlay()
        //Init the audioEngine
        audioEngine = AVAudioEngine()
        //Fetch the audioFile using the filepathUrl
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        //Fetch the shared instance of AVAudioSession
        var session = AVAudioSession.sharedInstance()
        //Set the category of recording
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        //Override the output to be the phones loud speaker
        session.overrideOutputAudioPort(.Speaker, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: IBActions
    @IBAction func playSlow(sender: UIButton) {
        stopAndResetPlayerAndEngine()
        playAudioWithOptions(rate: 0.5, andTime: 0.0)
    }

    @IBAction func playFast(sender: UIButton) {
        stopAndResetPlayerAndEngine()
        playAudioWithOptions(rate: 2.0, andTime: 0.0)
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
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAndResetPlayerAndEngine()
    }
    
    // MARK: playback functions
    func stopAndResetPlayerAndEngine() {
        //This function stops and resets audioPlayer and audioEngine
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithOptions(#rate: Float!, andTime time:NSTimeInterval!) {
        //This function receives a float for the rate, and the start time for .currentTime
        //Then plays the audio.
        audioPlayer.rate = rate
        audioPlayer.currentTime = time
        audioPlayer.play()
    }
    
    // MARK: AVAudioEffects

    func playAudioWithVariablePitch(pitch: Float) {
        /*
        This functon accepts a float for the pitch. 
        It inits a class for the pitch effect.
        Then the function sets the pitch, and lastly it calls
        playAudioWithEffects using the changePitchEffect as argument.
        */
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        playAudioWithEffect(changePitchEffect)
    }
    
    func playAudioWithEffect(effect: AVAudioUnit) {
        /*
        First, we stop and reset the player and engine in case audio is currently playing.
        We create a audioPLayerNode, and attaches that to the audioEngine.
        This function accepts a AVAudioUnit as argument. I'm using AVAudioUnit since
        the pitch, reverb, echo effects are all subclasses of AVAudioUnit.
        */
        
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
    
}
