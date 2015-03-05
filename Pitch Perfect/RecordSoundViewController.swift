//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Martin on 04.03.15.
//  Copyright (c) 2015 martin. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordingHint: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        println("view will appear")
        recordingInProgress.hidden = true
        
        stopButton.hidden = true;
        recordButton = regularRecordButton()
        recordingHint.text = "tap to record"
        prepareRecording()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleRecordPause(sender: UIButton) {
        
        
        if !audioRecorder.recording {
            pauseRecordButton()
            
            startRecording()
            
            recordingInProgress.hidden = false
            recordingInProgress.text = "recording in progress"
            recordingHint.text = "tap to pause"
            stopButton.hidden = false
        } else {
            regularRecordButton()
            audioRecorder.pause()
            recordingHint.text = "tap to record"
            recordingInProgress.hidden = false
            recordingInProgress.text = "recording paused"
        }

    }
    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden = false
        
        
        println(audioRecorder.recording)
        if audioRecorder.recording {
            let image = UIImage(named: "microphonePause") as UIImage!
            recordButton.setImage(image, forState: .Normal)
            
        } else {
            audioRecorder.pause()
        }
    }
    
    func prepareRecording() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        //audioRecorder.record()

    }
    
    func startRecording() {
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: UIButton) {

        recordingInProgress.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)

    }
    // MARK: Buttons
    func regularRecordButton()->UIButton {
        let image = UIImage(named: "microphone") as UIImage!
        recordButton.setImage(image, forState: .Normal)
        return recordButton
    }
    
    func pauseRecordButton()->UIButton {
        let image = UIImage(named: "microphonePause") as UIImage!
        recordButton.setImage(image, forState: .Normal)
        return recordButton
    }
    
    // MARK: AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, andTitle: recorder.url.lastPathComponent)
            self.performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
        }
        
    }
    
    
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecordingSegue") {
            let playSoundVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
}

