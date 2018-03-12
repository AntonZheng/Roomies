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
    var group = ""
    var roomie = ""
    var notifications : [String] = []
    var bills : [(String, String)] = []
    
    func incoming(group: String, roomie: String) {
        self.group = group
        self.roomie = roomie
    }
    
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
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                self.notifications.removeAll()
                self.bills.removeAll()
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
                        while let obj = enumerator.nextObject() as? DataSnapshot {
                            if let value = obj.value as? [String:Any] {
                                self.bills.append((value["billName"] as! String, value["billDate"] as! String))
                            }
                        }
                        for bill in self.bills {
                            if day > Int(bill.1)! {
                                var newDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
                                let newMonth = Calendar.current.component(.month, from: newDate!)
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "LLLL"
                                let monthName = dateFormatter.string(from: newDate!)
                                self.notifications.insert("\(bill.0 as! String) due on \(monthName) \(bill.1)", at: 0)
                            }
                        }
                    default:
                        NSLog("No children")
                    }
                }
                self.notificationsTable.dataSource = self
                self.notificationsTable.delegate = self
                self.notificationsTable.tableFooterView = UIView()
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
