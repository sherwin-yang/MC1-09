//
//  ReportViewController.swift
//  MC1-09
//
//  Created by Sherwin Yang on 10/04/20.
//  Copyright © 2020 Sherwin Yang. All rights reserved.
//

import UIKit
import CoreData

class ReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlet
    @IBOutlet weak var reportTableView: UITableView!
    @IBOutlet weak var reportSegmentedControl: UISegmentedControl!
    
    // MARK: - Variable
    
    var segmentedControlValue = 0
    var selectedSection = 0
    var selectedRow = 0
    
    var finishedTaskArr = [FinishedTasks]()
    var taskDateArr = [TaskDates]()
    
    var sortedFinishedTask: [FinishedTasks] = []
    
    var toReportTask = [FinishedTask]()
    var finishedTask_MonthYear = [Date]()
    
    let dateFormatter = DateFormatter()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        prepareTasksToReport()
    }
    
    // MARK: - IBAction
    
    @IBAction func reportViewSegmentedControl(_ sender: Any) {
        if self.reportSegmentedControl.selectedSegmentIndex == 0 {
            self.segmentedControlValue = 0
        }
        else {
            self.segmentedControlValue = 1
        }
        self.reportTableView.reloadData()
    }
    
    // MARK: - User Built Functions

    func mergeSort_Task(tasks: [FinishedTasks]) -> [FinishedTasks] {
        guard tasks.count > 1 else {
            return tasks
        }
        
        let leftArr = Array(tasks[0..<tasks.count/2])
        let rightArr = Array(tasks[tasks.count/2..<tasks.count])
        
        return mergeTask(left: mergeSort_Task(tasks: leftArr), right: mergeSort_Task(tasks: rightArr))
    }
    
    func mergeTask(left: [FinishedTasks], right: [FinishedTasks]) ->[FinishedTasks] {
        
        var mergedArr: [FinishedTasks] = []
        var left = left
        var right = right
        
        while left.count > 0 && right.count > 0 {
            let leftDate: Date = (left.first?.parentDeadline?.deadline)!
            let rightDate: Date = (left.first?.parentDeadline?.deadline)!
            
            if leftDate > rightDate {
                mergedArr.append(left.removeFirst())
            }
            else {
                mergedArr.append(right.removeFirst())
            }
        }
        return mergedArr + left + right
    }
    
    func insertToFinalContainer() {
        var countMonth = 0
        dateFormatter.dateFormat = "MM yyyy"
        var previousFinishedTaskDeadline_MonthYear: String = ""
        for i in 0..<sortedFinishedTask.count {
            let currentFinishedTaskDeadline = sortedFinishedTask[i].parentDeadline?.deadline
            let currentFinishedTaskDeadline_MonthYear: String = dateFormatter.string(from: currentFinishedTaskDeadline!)
            
            if i == 0 {
                toReportTask.append(FinishedTask.init(deadline_MonthYear: currentFinishedTaskDeadline!, title: [sortedFinishedTask[i].taskTitle!], approximatedTime: [sortedFinishedTask[i].approximatedTime], workTime: [sortedFinishedTask[i].workTime], breakTime: [sortedFinishedTask[i].breakTime]))
                finishedTask_MonthYear.append(currentFinishedTaskDeadline!)
                previousFinishedTaskDeadline_MonthYear = dateFormatter.string(from: currentFinishedTaskDeadline!)
            }
            else if previousFinishedTaskDeadline_MonthYear == currentFinishedTaskDeadline_MonthYear {
                toReportTask[countMonth].title.append(sortedFinishedTask[i].taskTitle!)
                toReportTask[countMonth].approximatedTime.append(sortedFinishedTask[i].approximatedTime)
                toReportTask[countMonth].workTime.append(sortedFinishedTask[i].workTime)
                toReportTask[countMonth].breakTime.append(sortedFinishedTask[i].breakTime)
            }
            else if previousFinishedTaskDeadline_MonthYear != currentFinishedTaskDeadline_MonthYear {
                toReportTask.append(FinishedTask.init(deadline_MonthYear: currentFinishedTaskDeadline!, title: [sortedFinishedTask[i].taskTitle!], approximatedTime: [sortedFinishedTask[i].approximatedTime], workTime: [sortedFinishedTask[i].workTime], breakTime: [sortedFinishedTask[i].breakTime]))
                finishedTask_MonthYear.append(currentFinishedTaskDeadline!)
                previousFinishedTaskDeadline_MonthYear = dateFormatter.string(from: currentFinishedTaskDeadline!)
                countMonth += 1
            }
        }
    }
    
    func prepareTasksToReport() {
        self.load()
        self.sortedFinishedTask = mergeSort_Task(tasks: finishedTaskArr)
        self.insertToFinalContainer()
    }
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentedControlValue != 0 {
            return finishedTask_MonthYear.count
        }
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControlValue != 0 {
            return toReportTask[section].title.count
        }
        return sortedFinishedTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath) as! ReportTableViewCell
        if segmentedControlValue != 0 {
            cell.titleLabel?.text = toReportTask[indexPath.section].title[indexPath.row]
            cell.durationLabel?.text = "\((toReportTask[indexPath.section].workTime[indexPath.row] + toReportTask[indexPath.section].breakTime[indexPath.row])/60) hours, \((toReportTask[indexPath.section].workTime[indexPath.row] + toReportTask[indexPath.section].breakTime[indexPath.row])%60) minutes"
            if toReportTask[indexPath.section].approximatedTime[indexPath.row] > (toReportTask[indexPath.section].workTime[indexPath.row]) || toReportTask[indexPath.section].approximatedTime[indexPath.row] == (toReportTask[indexPath.section].workTime[indexPath.row] + toReportTask[indexPath.section].breakTime[indexPath.row]){
                cell.statusLabel?.text = "On Time"
                cell.statusLabel.textColor = UIColor(red: 118/256, green: 194/256, blue: 100/256, alpha: 1.0)
            }
            else {
                cell.statusLabel?.text = "Too Long"
                cell.statusLabel.textColor = UIColor(red: 250/256, green: 110/256, blue: 95/256, alpha: 1.0)
            }
        }
        else {
            cell.titleLabel.text = sortedFinishedTask[indexPath.row].taskTitle
            cell.durationLabel.text = "\((sortedFinishedTask[indexPath.row].workTime + sortedFinishedTask[indexPath.row].breakTime)/60) hours, \((sortedFinishedTask[indexPath.row].workTime + sortedFinishedTask[indexPath.row].breakTime)%60) minutes"
            if sortedFinishedTask[indexPath.row].approximatedTime > (sortedFinishedTask[indexPath.row].workTime) ||  sortedFinishedTask[indexPath.row].approximatedTime == (sortedFinishedTask[indexPath.row].workTime + sortedFinishedTask[indexPath.row].breakTime){
                cell.statusLabel?.text = "On Time"
                cell.statusLabel.textColor = UIColor(red: 118/256, green: 194/256, blue: 100/256, alpha: 1.0)
            }
            else {
                cell.statusLabel?.text = "Too Long"
                cell.statusLabel.textColor = UIColor(red: 250/256, green: 110/256, blue: 95/256, alpha: 1.0)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segmentedControlValue != 0 {
            dateFormatter.dateFormat = "MMMM yyyy"
            return dateFormatter.string(from: finishedTask_MonthYear[section])
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedSection = indexPath.section
        self.selectedRow = indexPath.row
        self.performSegue(withIdentifier: "reportDetail", sender: self)
    }
    
    // MARK: - Model Data Manipulation
    
    func load() {
        let requestFinishedTasks : NSFetchRequest<FinishedTasks> = FinishedTasks.fetchRequest()
        let requestTaskDates : NSFetchRequest<TaskDates> = TaskDates.fetchRequest()
        
        do {
            self.finishedTaskArr = try context.fetch(requestFinishedTasks)
            self.taskDateArr = try context.fetch(requestTaskDates)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    // MARK: - Prepare Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "reportDetail" {
                if let destination = segue.destination as? ReportDetailTableViewController {
                    if segmentedControlValue != 0 {
                        destination.workTime = Int(toReportTask[selectedSection].workTime[selectedRow])
                        destination.breakTime = Int(toReportTask[selectedSection].breakTime[selectedRow])
                        destination.approximatedTime = Int(toReportTask[selectedSection].approximatedTime[selectedRow])
                    }
                    else {
                        destination.workTime = Int(sortedFinishedTask[selectedRow].workTime)
                        destination.breakTime = Int(sortedFinishedTask[selectedRow].breakTime)
                        destination.approximatedTime = Int(sortedFinishedTask[selectedRow].approximatedTime)
                    }
                }
            }
        }
    }
}
