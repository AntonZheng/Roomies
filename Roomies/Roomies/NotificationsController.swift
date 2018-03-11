//
//  NotificationsController.swift
//  Roomies
//
//  Created by Sarah Phillips on 3/11/18.
//  Copyright © 2018 Anton Zheng. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class NotificationController: UIViewController, UITableViewDelegate, UITableViewDataSource   {

    @IBOutlet weak var optionsTable: UITableView!
    let optionsList = ["Notifications"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = optionsList[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        optionsTable.dataSource = self 
        optionsTable.delegate = self
        optionsTable.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
