//
//  ViewController.swift
//  SimpsonsHousePulse
//
//  Created by Josh on 12/27/15.
//  Copyright © 2015 PubNub. All rights reserved.
//

import UIKit
import PubNub
import AVFoundation

class ViewController: UIViewController {
    let RAIN = 5
    let FIRE = 6
    let TRAFFIC = 1

    
    var client:PubNub?
    @IBOutlet weak var speakerConnectionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ad:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.client = ad.client
        subscribeForNotification()
        HMNDeviceGeneral.connectToMasterDevice()
        speakerConnectionLabel.text = "Speaker disconnected";
//        HMNLedPattern.setLedBrightness(0)
    }
    
    
    func subscribeForNotification() {
        Swift.print("subscibeForNotification")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceConnected", name: EVENT_DEVICE_CONNECTED, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceDisconnected", name: EVENT_DEVICE_DISCONNECTED, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceInfoReceived:", name: EVENT_DEVICE_INFO, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sensorCaptureColorReceived:", name: EVENT_SENSOR_CAPTURE_COLOR, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "patternReceived:", name: EVENT_PATTERN_INFO, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "versionReceived:", name: EVENT_VERSION, object: nil)
        
        
    }

    @IBAction func turnOnLight(sender: AnyObject) {
        HMNLedPattern.setLedBrightness(255)
    }
    
    @IBAction func turnOffLight(sender: AnyObject) {
        HMNLedPattern.setLedBrightness(0)
    }
    
    func deviceConnected() {
        Swift.print("deviceConnected")
        speakerConnectionLabel.text = "Speaker connected";
    }

    func deviceDisconnected() {
        print("deviceDisonnected")
        speakerConnectionLabel.text = "Speaker disconnected";
    }
    
    func sensorCaptureColorReceived(notification: NSNotification) {
        print("sensorCaptureColorReceived")
    }

    
    func deviceInfoReceived(notification: NSNotification) {
        print("deviceInfoReceived")
    }
    
    func patternReceived(notification: NSNotification) {
        print("patternReceived")
    }
    
    func versionReceived(notification: NSNotification) {
        print("versionReceived")
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func triggerArriveEvent(sender: AnyObject) {
        let obj = [ "type":"action", "action":"arrive"]
        self.client?.publish(obj, toChannel:"ch1", withCompletion: { (status) -> Void in
            if !status.error {
                print("no error sending")
            } else {
                print("yes error sending")
            }
        })
        HMNLedPattern.setLedBrightness(255)
        setLEDPattern(FIRE)
        playClip("fire",ext:"wav")
    }
    
    @IBAction func triggerPartyEvent(sender: AnyObject) {
        let obj = [ "type":"action", "action":"party"]
        self.client?.publish(obj, toChannel:"ch1", withCompletion: { (status) -> Void in
            if !status.error {
                print("no error sending")
            } else {
                print("yes error sending")
            }
        })
        setLEDPattern(TRAFFIC)
        playClip("party",ext:"m4a")
    }
    
    
    @IBAction func triggerSleepEvent(sender: AnyObject) {
        sendAction("sleep")
        setLEDPattern(RAIN)
        playClip("rain",ext:"m4a")
    }
    
    
    @IBAction func stepDoorClose(sender: AnyObject) {
        sendAction("stepDoorClose")
    }
    
    @IBAction func stepDoorOpen(sender: AnyObject) {
        sendAction("stepDoorOpen")
    }
    
    @IBAction func turnOff(sender: AnyObject) {
        HMNLedPattern.setLedBrightness(0)
        sendAction("shutdown")
    }

    @IBAction func turnOn(sender: AnyObject) {
    }
    func sendAction(action:String) {
        let obj = [ "type":"action", "action":action]
        self.client?.publish(obj, toChannel:"ch1", withCompletion: { (status) -> Void in
            if !status.error {
                print("no error sending")
            } else {
                print("yes error sending")
            }
        })
    }
    var backgroundMusicPlayer:AVAudioPlayer = AVAudioPlayer()
    
    func setLEDPattern(val:Int) {
        let g_ledPatternID = HMNPattern(rawValue: val)! //rain.  6 is ire
        HMNLedPattern.setLedPattern(g_ledPatternID)
    }

    func playClip(name:String, ext:String) {
        let path = NSBundle.mainBundle().pathForResource(name, ofType: ext)
        do {
            self.backgroundMusicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path!))
            self.backgroundMusicPlayer.play()
        } catch (let e){
            Swift.print("error playing the audio",e)
        }
    }
}

