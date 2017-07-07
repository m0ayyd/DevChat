//
//  ViewController.swift
//  DevChat
//
//  Created by the Luckiest on 7/3/17.
//  Copyright © 2017 the Luckiest. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class CameraVC: AAPLCameraViewController, AAPLCameraVCDelegate {

    @IBOutlet weak var previewView: AAPLPreviewView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    
    override func viewDidLoad() {
        
        self._previewView = self.previewView
        super.viewDidLoad()
        delegate = self
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard Auth.auth().currentUser != nil else {
            performSegue(withIdentifier: "LoginVC", sender: nil)
            return
        }
    }

    @IBAction func recordBtnTapped(_ sender: Any) {
        self.toggleMovieRecording()
    }
    @IBAction func changeCameraTapped(_ sender: Any) {
        self.changeCamera()
    }
    
    func shouldEnableCameraUI(_ enable: Bool) {
        cameraBtn.isEnabled = enable
    }
    
    func shouldEnableRecordUI(_ enable: Bool) {
        recordBtn.isEnabled = enable
    }
    
    func recordingHasStarted() {
        
    }
    
    func canStartRecording() {
        
    }
    
    func videoRecordingComplete(_ videoURL: URL!) {
        performSegue(withIdentifier: "UsersVC", sender: ["videoURL": videoURL])
    }
    
    func videoRecordingFailed() {
        
    }
    
    func snapshotTaken(_ snapshotData: Data!) {
        performSegue(withIdentifier: "UsersVC", sender: ["snapshotData": snapshotData])
    }
    
    func snapshotFailed() {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let usersVC = segue.destination as? UsersVC {
            if let videoDict = sender as? [String:URL] {
                let url = videoDict["videoURL"]
                usersVC.videoURL = url
            } else if let snapeDict = sender as? [String:Data] {
                let snapData = snapeDict["snapshotData"]
                usersVC.snapData = snapData
            }
        }
    }
    
}

