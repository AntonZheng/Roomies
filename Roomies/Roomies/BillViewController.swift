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
    
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var timePicker: UIDatePicker!
    var dates : [Int] = []
    var dbReference: DatabaseReference?
    var group = ""
    @IBOutlet weak var billText: UITextField!
    var date = ""
    var time = ""
    
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
    
    
    @IBAction func timePicked(_ sender: UIDatePicker) {
        let date = sender.date
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: date)
        time = String(describing: comp.hour) + ":" + String(describing: comp.minute)
    }
    
    @IBAction func addPushed(_ sender: Any) {
        if billText.text!.count > 0 {
            dbReference?.child("groups").child(self.group).child("bills").childByAutoId().setValue(["billName": billText.text!, "billDate": self.date, "billTime": self.time])
        }
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
