//
//  NewUserViewController.swift
//  Roomies
//
//  Created by Govind Pillai on 3/8/18.
//  Copyright © 2018 Anton Zheng. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewUserViewController: UIViewController {
    public var group : String = ""
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    var userCount = 1
    var dbReference: DatabaseReference?
    var dbHandle: DatabaseHandle?
    
    func incomingVars(group: String) {
        self.group = group
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dbReference = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPushed(_ sender: Any) {
        if userText.text!.count > 0 {
            if userCount == 1 {
                dbReference?.child("groups").child(self.group).child("users").child(userText.text!).setValue(["username": userText.text!, "admin": true])
            } else {
                dbReference?.child("groups").child(self.group).child("users").child(userText.text!).setValue(["username": userText.text!, "admin": false])
            }
            userText.text = ""
            userCount += 1
            userLabel.text = "User \(self.userCount)"
        }
    }
    
    @IBAction func nextPushed(_ sender: Any) {
        if userText.text!.count > 0 {
            if userCount == 1 {
                dbReference?.child("groups").child(self.group).child("users").child(userText.text!).setValue(["username": userText.text!, "admin": true])
            } else {
                dbReference?.child("groups").child(self.group).child("users").child(userText.text!).setValue(["username": userText.text!, "admin": false])
            }
        }
        performSegue(withIdentifier: "BillSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier! {
        case "BillSegue":
            let destination = segue.destination as? BillViewController
            destination?.incoming(group: self.group)
        default:
            NSLog("Unknown segue identifier -- " + segue.identifier!)
        }
    }

}
