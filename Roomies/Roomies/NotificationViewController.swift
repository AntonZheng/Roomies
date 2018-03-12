//
//  NotificationViewController.swift
//  Roomies
//
//  Created by Govind Pillai on 3/12/18.
//  Copyright © 2018 Anton Zheng. All rights reserved.
//

import UIKit
import FirebaseDatabase


class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var notificationsTable: UITableView!
    var dbReference: DatabaseReference?
    var group = "info200"
    var roomie = "govind"
    var notifications : [String] = []
    var bills : [(String, String)] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("numberOfRowsInSection called")
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.notifications[index]
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        dbReference = Database.database().reference()
        let refRoomies = dbReference?.child("groups").child(self.group)
        refRoomies?.observe(DataEventType.value, with: {(snapshot) in
            /*self.notifications.removeAll()
            if snapshot.childrenCount > 0 {
                let enumerator = snapshot.children
                while let obj = enumerator.nextObject() as? DataSnapshot {
                    let value = obj.value as! [String:Any]
                    let username = value["username"] as! String
                    if username == self.roomie {
                        if value["notifications"] != nil {
                            for (key, value) in value["notifications"] as! [String:Any] {
                                let val = value as! [String:Any]
                                self.notifications.insert(val["notification"] as! String, at:0)
                            }
                        }
                    }
                }
                self.notificationsTable.dataSource = self
                self.notificationsTable.delegate = self
                self.notificationsTable.tableFooterView = UIView()
            } */
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                self.notifications.removeAll()
                for snap in snapshots {
                    switch snap.key {
                    case "users":
                        let enumerator = snap.children
                        while let obj = enumerator.nextObject() as? DataSnapshot {
                            let value = obj.value as! [String:Any]
                            let username = value["username"] as! String
                            if username == self.roomie {
                                if value["notifications"] != nil {
                                    for (key, value) in value["notifications"] as! [String:Any] {
                                        let val = value as! [String:Any]
                                        self.notifications.insert(val["notification"] as! String, at: 0)
                                    }
                                }
                            }
                        }
                    case "bills":
                        let enumerator = snap.children
                        
                    default:
                        NSError()
                    }
                }
            }
            
        })
        // Do any additional setup after loading the view.
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
