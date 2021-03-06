//
//  TaskTableViewController.swift
//  Roomies
//
//  Created by Govind Pillai on 3/12/18.
//  Copyright © 2018 Anton Zheng. All rights reserved.
//

import UIKit
import FirebaseDatabase



class TaskTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct Tasks {
        var name : String!
        var tasks : [String]!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskObjects[section].tasks.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskObjects[indexPath.section].tasks[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.section = taskObjects[indexPath.section].name
        self.row = taskObjects[indexPath.section].tasks[indexPath.row]
        performSegue(withIdentifier: "SingleTask", sender: self)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return taskObjects[section].name
    }
    
    var row = ""
    var section = ""
    var taskObjects : [Tasks] = []
    var dbReference: DatabaseReference?
    var group = ""
    var roomie = ""
    var task = ""

    @IBOutlet weak var taskTable: UITableView!
    
    func incoming(group: String, roomie: String) {
        self.group = group
        self.roomie = roomie
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbReference = Database.database().reference()
        let refRoomies = dbReference?.child("groups").child(self.group).child("users")
        refRoomies?.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.taskObjects.removeAll()
                let enumerator = snapshot.children
                var temptasks:[String] = []
                while let obj = enumerator.nextObject() as? DataSnapshot {
                    let value = obj.value as! [String:Any]
                    if value["tasks"] != nil {
                        for (key, value) in value["tasks"] as! [String:Any] {
                            let val = value as! [String:Any]
                            temptasks.append(val["task"] as! String)
                        }
                        let username = value["username"] as! String
                        self.taskObjects.append(Tasks(name: username, tasks: temptasks))
                        temptasks.removeAll()
                        print(self.taskObjects)
                    }
                }
                self.taskTable.dataSource = self
                self.taskTable.delegate = self
                self.taskTable.tableFooterView = UIView()
            }
            /*if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    let enumerator = snap.children
                    var temptasks:[String] = []
                    while let obj = enumerator.nextObject() as? DataSnapshot {
                        let value = obj.value as! [String:Any]
                        if value["tasks"] != nil {
                            for(key,value) in value[""]
                        }
                    }
                    
                }
            }*/
        })
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "SingleTask":
            let destination = segue.destination as? SingleTaskViewController
            destination?.incoming(group: self.group, roomie: self.roomie, task: self.row, taskRoomie: self.section)
        case "NewTask":
            let destination = segue.destination as? TaskViewController
            destination?.incoming(group: self.group, newGroup: false, user: self.roomie)
        case "Home":
            let destination = segue.destination as? LandingTableViewController
            destination?.incoming(group: self.group, username: self.roomie)
        default:
            NSLog("Unknown segue identifier -- " + segue.identifier!)
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
