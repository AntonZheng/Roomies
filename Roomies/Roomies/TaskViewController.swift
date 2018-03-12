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
    func incoming(group: String) {
        self.group = group
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
            taskName.text = ""
            taskCount += 1
            taskLabel.text = "Task \(self.taskCount)"
        }
    }
    
    @IBAction func nextPushed(_ sender: Any) {
        if taskName.text!.count > 0 {
            dbReference?.child("groups").child(self.group).child("tasks").child(taskName.text!).setValue(["Roomie": roomie])
            dbReference?.child("groups").child(self.group).child("users").child(roomie).child("notifications").childByAutoId().setValue(["notification": taskName.text!])
        }
        performSegue(withIdentifier: "FinishSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

