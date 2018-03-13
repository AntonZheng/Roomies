//
//  BillViewController.swift
//  Roomies
//
//  Created by Govind Pillai on 3/10/18.
//  Copyright © 2018 Anton Zheng. All rights reserved.
//

import UIKit
import FirebaseDatabase

class BillViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var datePicker: UIPickerView!
    var roomies : [String] = []
    var dates : [Int] = []
    var dbReference: DatabaseReference?
    var group = ""
    @IBOutlet weak var billText: UITextField!
    var date = ""
    var billCount = 1
    
    func incoming(group: String) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.delegate = self
        self.datePicker.dataSource = self
        // Do any additional setup after loading the view.
        dbReference = Database.database().reference()
        dates = Array(1...31)
        self.date = "1"
        let refRoomies = dbReference?.child("groups").child(group).child("users")
        refRoomies?.observe(DataEventType.value, with: {(snapshot) in
            self.roomies.removeAll()
            if snapshot.childrenCount > 0 {
                let enumerator = snapshot.children
                while let obj = enumerator.nextObject() as? DataSnapshot {
                    let value = obj.value as! [String:Any]
                    self.roomies.append(value["username"] as! String)
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(dates[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.date = String(dates[row])
    }
    
    @IBAction func addPushed(_ sender: Any) {
        if billText.text!.count > 0 {
            dbReference?.child("groups").child(self.group).child("bills").child(billText.text!).setValue(["billName": billText.text!, "billDate": self.date])
            let date = Date()
            let newMonth = Calendar.current.component(.month, from: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            let monthName = dateFormatter.string(from: date)
            for roomie in self.roomies {
                dbReference?.child("groups").child(self.group).child("users").child(roomie).child("notifications").childByAutoId().setValue(["notification": "\(billText.text!) due on \(monthName) \(self.date)"])
            }
            billCount += 1
            billText.text = ""
            billLabel.text = "Bill \(billCount)"
        }
    }
    
    @IBAction func nextPushed(_ sender: Any) {
        if billText.text!.count > 0 {
            dbReference?.child("groups").child(self.group).child("bills").child(billText.text!).setValue(["billName": billText.text!, "billDate": self.date])
            let date = Date()
            let newMonth = Calendar.current.component(.month, from: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            let monthName = dateFormatter.string(from: date)
            for roomie in self.roomies {
            dbReference?.child("groups").child(self.group).child("users").child(roomie).child("notifications").childByAutoId().setValue(["notification": "\(billText.text!) due on \(monthName) \(self.date)"])
            }
        }
        performSegue(withIdentifier: "TaskSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "TaskSegue":
            let destination = segue.destination as? TaskViewController
            destination?.incoming(group: self.group, newGroup: true, user: "")
        default:
            NSLog("Unknown segue identifier -- " + segue.identifier!)
        }
    }
    
}
