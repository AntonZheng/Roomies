//
//  ViewController.swift
//  Roomies
//
//  Created by Anton Zheng on 3/1/18.
//  Copyright © 2018 Anton Zheng. All rights reserved.
//
import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var groupName: UITextField!
    var dbReference: DatabaseReference?
    var groups: [String:[String]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dbReference = Database.database().reference()
        
    }

    @IBAction func signIn(_ sender: Any) {
        if(groupName.text == "") {
            let intAlert: UIAlertController = UIAlertController(title: "Please type in a group name!", message: "Make sure you enter a group!", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "ok", style: .cancel)
            intAlert.addAction(cancel)
            self.present(intAlert, animated: true, completion: nil)
        } else {
            dbReference?.child("groups").observe(DataEventType.value, with: {(snapshot) in
                if snapshot.hasChild(self.groupName.text!){
                    let snaps = snapshot.childSnapshot(forPath: self.groupName.text!)
                    if let snapshots = snaps.children.allObjects as? [DataSnapshot] {
                        for snap in snapshots {
                            if snap.key == "users" {
                                var exist = false
                                let enumerator = snap.children
                                while let obj = enumerator.nextObject() as? DataSnapshot {
                                    let value = obj.value as! [String:Any]
                                    let username = value["username"] as! String
                                    if username == self.userName.text {
                                        exist = true
                                    }
                                }
                                if exist {
                                    print("success!")
                                    self.performSegue(withIdentifier: "showLanding", sender: self)
                                } else {
                                    let intAlert: UIAlertController = UIAlertController(title: "User is not Registered!", message: "Make sure this user is registered in the listed group!", preferredStyle: .alert)
                                    let cancel = UIAlertAction(title: "ok", style: .cancel)
                                    intAlert.addAction(cancel)
                                    self.present(intAlert, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }else {
                    let intAlert: UIAlertController = UIAlertController(title: "Group is not Registered!", message: "Make sure you first register your group.", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "ok", style: .cancel)
                    intAlert.addAction(cancel)
                    self.present(intAlert, animated: true, completion: nil)
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "showLanding":
            let destination = segue.destination as? LandingTableViewController
            destination?.incoming(group: self.groupName.text!, username: self.userName.text!)
        case "GroupSegue":
            break
        default:
            NSLog("Unknown segue identifier -- " + segue.identifier!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
}
