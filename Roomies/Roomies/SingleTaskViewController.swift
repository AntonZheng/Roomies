//
//  SingleTaskViewController.swift
//  Roomies
//
//  Created by Govind Pillai on 3/12/18.
//  Copyright © 2018 Anton Zheng. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SingleTaskViewController: UIViewController {
    var task = ""
    var group = ""
    var roomie = ""
    var taskRoomie = ""
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    var enable = false
    var dbReference : DatabaseReference?
    
    func incoming(group: String, roomie: String, task: String, taskRoomie: String) {
        self.group = group
        self.roomie = roomie
        self.task = task
        self.taskRoomie = taskRoomie
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbReference = Database.database().reference()
        taskLabel.text = self.task
        let refRoomies = dbReference?.child("groups").child(self.group).child("users")
        refRoomies?.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0 {
                let enumerator = snapshot.children
                while let obj = enumerator.nextObject() as? DataSnapshot {
                    let value = obj.value as! [String:Any]
                    let username = value["username"] as! String
                    if username == self.roomie {
                        if value["admin"] as! Bool {
                            self.enable = true
                        } else {
                            self.enable = false
                        }
                    }
                }
                self.reminderButton.isEnabled = self.enable
                if self.enable == false {
                    self.reminderButton.backgroundColor = .gray
                }
            }
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sendPushed(_ sender: Any) {
        dbReference?.child("groups").child(self.group).child("users").child(taskRoomie).child("notifications").childByAutoId().setValue(["notification": "Reminder to \(self.task)"])
    }
    
    @IBAction func completePushed(_ sender: Any) {
        var notifID = ""
        let refRoomies = dbReference?.child("groups").child(self.group).child("users")
        refRoomies?.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0 {
                let enumerator = snapshot.children
                while let obj = enumerator.nextObject() as? DataSnapshot {
                    let value = obj.value as! [String:Any]
                    let username = value["username"] as! String
                    if username == self.roomie {
                        if value["notifications"] != nil {
                            for (key, value) in value["notifications"] as! [String:Any] {
                                let val = value as! [String:Any]
                                if val["notification"] as! String == self.task {
                                    notifID = key
                                }
                            }
                        }
                    }
                }
            }
        })
        
        dbReference?.child("groups").child(self.group).child("users").child(self.roomie).child("notifications").child(notifID).removeValue()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier! {
        case "BackToTask":
        let destination = segue.destination as? TaskTableViewController
        destination?.incoming(group: self.group, roomie: self.roomie)
        default:
            NSLog("Unknown segue identifier -- " + segue.identifier!)
        }
    }

}
