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

        //Prep for recording.
        prepareRecording()
        
        //Check to see if audioRecorder is recording. If it's not recording. Reset view.
        if !audioRecorder.recording {
            //Display a regular recordButton
            recordButton = regularRecordButton()
            //Hide the recording in progress label since audiorecorder is not recording.
            recordingInProgress.hidden = true
            
            stopButton.hidden = true;
            recordingHint.text = "tap to record"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareRecording() {
        /*
        This function handles all prepwork for the audioRecorder
        */
        
        //Finds the document directory in the app sandbox
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        //Sets the filename as current date and time.
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //referencing the shared instance AVAudioSession and sets a category
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //Inits the audioRecorder with the filepath url. Sets self as delegate of AVAudioRecorderDelegate
        //And runs the prepareToRecord() function.
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        
    }
    
    // MARK: IBActions
    
    @IBAction func toggleRecordPause(sender: UIButton) {
        /*
        This function handles the code for toggling of the record button between record and pause.
        When the button is pressed, the code will first check the state of the audioRecorder. If
        audioRecorder is not recording, start recording then present a pausebutton instead.
        If the audioRecorder is recording, then pause the recording and show the regular button.
        */
        
        if !audioRecorder.recording {
            //Start recording
            startRecording()
            //Display a pause button
            pauseRecordButton()
            
            //Set the text and unhide the recordingInProgress label
            recordingInProgress.text = "recording in progress"
            recordingInProgress.hidden = false
            
            //Show appropriate hint
            recordingHint.text = "tap to pause"
            stopButton.hidden = false
        } else {
        
            //Pause the recording
            audioRecorder.pause()
            //Display a regular button
            regularRecordButton()
            
            //Show appropriate hint
            recordingHint.text = "tap to record"
            recordingInProgress.text = "recording paused"
            recordingInProgress.hidden = false
            
        }

    }

    
    @IBAction func stopRecording(sender: UIButton) {
        /*
        This IBAction is connected to the stopButton.
        If pushed it hides the recordingInProgress label.
        It stoppes the recorder.
        And deactivatess the audioSession
        */
        recordingInProgress.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)

    }
    
    // MARK: Controls
    
    func startRecording() {
        //Calls the record() function of audioRecorder which starts recording to file.
        audioRecorder.record()
    }
    
    // MARK: Buttons
    func regularRecordButton()->UIButton {
        //Changes the image of the recordButton instead of disabling it.
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
            //If finishes successfully
            //Init an instance of A RecordedAudio class
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

