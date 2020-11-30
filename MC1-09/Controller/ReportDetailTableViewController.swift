//
//  ReportDetailTableViewController.swift
//  MC1-09
//
//  Created by Sherwin Yang on 10/04/20.
//  Copyright © 2020 Sherwin Yang. All rights reserved.
//

import UIKit

class ReportDetailTableViewController: UITableViewController {

    @IBOutlet weak var workTimeLabel: UILabel!
    @IBOutlet weak var breakTimeLabel: UILabel!
    @IBOutlet weak var approximatedTimeLabel: UILabel!
    @IBOutlet weak var totalMarginErrorLabel: UILabel!
    
    var workTime = 0
    var breakTime = 0
    var approximatedTime = 0
    var totalMarginError = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(workTime)
        print(breakTime)
        print(approximatedTime)
        
        showDetailReport()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - User Built Functions
    
    func showDetailReport() {
        workTimeLabel?.text = "\(workTime/60) hours, \(workTime%60) minutes"
        breakTimeLabel?.text = "\(breakTime/60) hours, \(breakTime%60) minutes"
        approximatedTimeLabel?.text = "\(approximatedTime/60) hours, \(approximatedTime%60) minutes"
        if approximatedTime - workTime - breakTime < 0 {
            totalMarginErrorLabel?.text = "- \(abs((approximatedTime - workTime - breakTime)/60)) hours, \(abs((approximatedTime - workTime - breakTime)%60)) minutes"
            totalMarginErrorLabel.textColor = UIColor(red: 250/256, green: 110/256, blue: 95/256, alpha: 1.0)
         
        }
        else {
            totalMarginErrorLabel?.text = "+ \(abs((approximatedTime - workTime - breakTime)/60)) hours, \(abs((approximatedTime - workTime - breakTime)%60)) minutes"
            totalMarginErrorLabel.textColor = UIColor(red: 118/256, green: 194/256, blue: 100/256, alpha: 1.0)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
