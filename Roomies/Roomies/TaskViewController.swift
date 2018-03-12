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
        return roomies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    
    // group that must be passed for firebase input
    var group = ""
    var roomies : [String] = []
    var roomie = ""
    var dbReference: DatabaseReference?
    
    func incoming(group: String) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.roomiePicker.delegate = self
        //self.roomiePicker.dataSource = self
        dbReference = Database.database().reference()
        let refRoomies = dbReference?.child("groups").child(group).child("users")
        refRoomies?.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0 {
                self.roomies.removeAll()
                print(snapshot.children)
            }
        })
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTask(_ sender: Any) {
        
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

