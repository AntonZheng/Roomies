//
//  GroupRegistrationViewController.swift
//  Roomies
//
//  Created by Govind Pillai on 3/8/18.
//  Copyright © 2018 Anton Zheng. All rights reserved.
//

import UIKit
import FirebaseDatabase

class GroupRegistrationViewController: UIViewController {

    @IBOutlet weak var groupText: UITextField!
    var dbReference: DatabaseReference?
    var group: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dbReference = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitPushed(_ sender: UIButton) {
        if groupText.text!.count > 0 {
            self.group = groupText.text!
            dbReference?.child("groups").childByAutoId().setValue(self.group)
            performSegue(withIdentifier: "NewUserSegue", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier! {
        case "NewUserSegue":
            let destination = segue.destination as? NewUserViewController
            destination!.incomingVars(group: self.group)
        default:
            NSLog("Unknown segue identifier -- " + segue.identifier!)
        }
    }

}
