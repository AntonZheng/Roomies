//
//  TaskViewController.swift
//  Roomies
//
//  Created by Anton Zheng on 3/11/18.
//  Copyright © 2018 Anton Zheng. All rights reserved.
//

import FirebaseDatabase
import UIKit

class TaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roomies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return roomies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(roomies)
        self.roomie = roomies[row]
        //print(roomie)
    }
    
    
    @IBOutlet weak var roomiePicker: UIPickerView!
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskLabel: UILabel!
    // group that must be passed for firebase input
    var group = ""
    var roomies : [String] = []
    var roomie = ""
    var dbReference: DatabaseReference?
    var taskCount = 1
    var newGroup : Bool = true
    var user = ""
    func incoming(group: String, newGroup: Bool, user: String) {
        self.group = group
        self.newGroup = newGroup
        self.user = user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbReference = Database.database().reference()
        let refRoomies = dbReference?.child("groups").child(group).child("users")
        refRoomies?.observe(DataEventType.value, with: {(snapshot) in
            self.roomies.removeAll()
            if snapshot.childrenCount > 0 {
                let enumerator = snapshot.children
                while let obj = enumerator.nextObject() as? DataSnapshot {
                    let value = obj.value as! [String:Any]
                    self.roomies.append(value["username"] as! String)
                }
                self.roomie = self.roomies[0]
                self.roomiePicker.dataSource = self
                self.roomiePicker.delegate = self
            }
        })
    }
    
    @IBAction func addTask(_ sender: Any) {
        if taskName.text!.count > 0 {
            dbReference?.child("groups").child(self.group).child("tasks").child(taskName.text!).setValue(["Roomie": roomie])
            dbReference?.child("groups").child(self.group).child("users").child(roomie).child("notifications").childByAutoId().setValue(["notification": taskName.text!])
            dbReference?.child("groups").child(self.group).child("users").child(roomie).child("tasks").childByAutoId().setValue(["task": taskName.text!])
            taskName.text = ""
            taskCount += 1
            taskLabel.text = "Task \(self.taskCount)"
        }
    }
    
    @IBAction func nextPushed(_ sender: Any) {
        if taskName.text!.count > 0 {
            dbReference?.child("groups").child(self.group).child("tasks").child(taskName.text!).setValue(["Roomie": roomie])
            dbReference?.child("groups").child(self.group).child("users").child(roomie).child("notifications").childByAutoId().setValue(["notification": taskName.text!])
            
            dbReference?.child("groups").child(self.group).child("users").child(roomie).child("tasks").childByAutoId().setValue(["task": taskName.text!])
        }
        if newGroup {
            performSegue(withIdentifier: "FinishSegue", sender: self)
        } else {
            performSegue(withIdentifier: "BackToHome", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "FinishSegue":
            break
        case "BackToHome":
            let destination = segue.destination as? LandingTableViewController
            destination?.incoming(group: self.group, username: self.user)
        default:
            NSLog("Unknown segue identifier -- " + segue.identifier!)
        }
    }
    
}

