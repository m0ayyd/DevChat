//
//  UsersVC.swift
//  DevChat
//
//  Created by the Luckiest on 7/5/17.
//  Copyright © 2017 the Luckiest. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class UsersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    private var users: [User] = []
    private var selectedUsers : [String: User] = [:]
    
    private var _snapData: Data?
    private var _videoURL: URL?
    
    var snapData: Data? {
        set {
            _snapData = newValue
        }
        
        get {
            return _snapData
        }
    }
    
    var videoURL: URL? {
        set {
            _videoURL = newValue
        }
        
        get {
            return _videoURL
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource =  self
        tableView.allowsMultipleSelection = true
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        DataService.instance.usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = snapshot.value as? [String:Any] {
                for (key, value) in user {
                    
                    if let dict = value as? [String:Any] {
                        if let profile = dict["profile"] as? [String:Any] {
                            if let firstName = profile["firstName"] as? String {
                                let uid = key
                                let user = User(uid: uid, firstname: firstName)
                                self.users.append(user)
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
        })
    }
    
    @IBAction func sendPRBtnTapped(sender: Any) {
        if let url = videoURL {
            
            let videoName = "\(NSUUID().uuidString)\(url.lastPathComponent)"
            let ref = DataService.instance.videoStorageRef.child(videoName)
            
            _ = ref.putFile(from: url, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("Error uploading video \(String(describing: error?.localizedDescription))")
                } else {
                    let downloadURL = metadata?.downloadURL()
                    print(downloadURL ?? "error download url")
                    DataService.instance.sendMediaPullRequest(senderUID: (Auth.auth().currentUser?.uid)!, sendingTo: self.selectedUsers, mediaURL: downloadURL!, textSnippet:"Coding today was LEGIT")
                    
                    // save this somewhere
                    
                }
            })
            self.dismiss(animated: true, completion: nil)
        } else if let snap = snapData {
            let ref = DataService.instance.imagesStorageRef.child("\(NSUUID().uuidString).jpg")
            _ = ref.putData(snap, metadata: nil, completion: { (meta, error) in
                if error != nil {
                    print("Error uploading snapshot \(error?.localizedDescription)")
                } else {
                    let downloadURL = meta?.downloadURL()
                    
                }
            })
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: true)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = user
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: false)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = nil
        
        if selectedUsers.count <= 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        let user = users[indexPath.row]
        cell.updateUI(user: user)
        return cell
    }
    

}
