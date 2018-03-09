//
//  LandingTableViewController.swift
//  Roomies
//
//  Created by Govind Pillai on 3/8/18.
//  Copyright © 2018 Anton Zheng. All rights reserved.
//

import UIKit

class LandingTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var optionsTable: UITableView!
    let optionsList = ["Notifications", "My Chores", "Chores", "Bills"]
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
