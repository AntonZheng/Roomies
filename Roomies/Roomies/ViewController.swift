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
    
    var dbReference: DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dbReference = Database.database().reference()
        dbReference?.child("name").childByAutoId().setValue("Anton")
        dbReference?.child("name").childByAutoId().setValue("Govind")
        dbReference?.child("name").childByAutoId().setValue("Sarah")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

