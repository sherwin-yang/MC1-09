//
//  ViewController.swift
//  MC1
//
//  Created by Alvian Gozali on 08/04/20.
//  Copyright © 2020 Alvian Gozali. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController{
    
    @IBOutlet weak var segmentedControlHome: UISegmentedControl!
    @IBOutlet weak var homeTableVIew: UITableView!
    
    var groupedActivities = [GroupedActivities]()
    var section = 0
    var currDate = Date()
    
    var unfinishedTaskArr = [UnfinishedTasks]()
    var taskDateArr = [TaskDates]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        load()
        
        initData()
    }
    
    @IBAction func segmentAction(_ sender: Any) {
        let segment = segmentedControlHome.selectedSegmentIndex
        section = segment
        homeTableVIew.reloadData()
    }
    
    @IBAction func addBtn(_ sender: Any) {
        performSegue(withIdentifier: "goToAddVC", sender: self)
    }
    
    func getCurrDate(format: String) ->Int{
        // d, MM, yyyy
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT+7")
        let temp = dateFormatter.string(from: currDate)
        return Int(temp)!
    }
    
    func removeActivity(sect: Int, row: Int) {
        delete(id: groupedActivities[sect].getActivities()[row].getId())
    }
    
    func refreshTable() {
        for i in 0..<groupedActivities[0].getActivities().count {
            //print("0 : \(i)")
            if i < groupedActivities[0].getActivities().count {
                groupedActivities[0].removeActivity(index: i)
            }
            
        }
        for i in 0..<groupedActivities[1].getActivities().count {
            //print("1 : \(i)")
            if i < groupedActivities[1].getActivities().count {
                groupedActivities[1].removeActivity(index: i)
            }
            
        }
        for i in 0..<groupedActivities[2].getActivities().count {
            //print("2 : \(i)")
            if i < groupedActivities[2].getActivities().count {
                groupedActivities[2].removeActivity(index: i)
            }
        }
    }
    
    func deleteTesting(activity: Activity) {
        context.delete(unfinishedTaskArr[activity.getId()])
    }
    
    func getRowCount() -> Int{
        return segmentedControlHome.selectedSegmentIndex
    }
    
    func initData() {
        groupedActivities.append(GroupedActivities.init(dateGroup: "today"))
        groupedActivities.append(GroupedActivities.init(dateGroup: "tomorrow"))
        groupedActivities.append(GroupedActivities.init(dateGroup: "upcoming"))
        loadActivity()
    }
    
    func loadActivity() {
        refreshTable()
        load()
        var activity: Activity!
        for i in 0..<unfinishedTaskArr.count {
            activity = Activity.init(title: unfinishedTaskArr[i].taskTitle!, description: unfinishedTaskArr[i].taskDescription!, deadline: (unfinishedTaskArr[i].parentDeadline?.deadline)!, approxTime: Int(unfinishedTaskArr[i].approximatedTime))
            activity.setId(id: i)
            addGroupedActivity(activity: activity)
            //print(activity.getId())
        }
        homeTableVIew.reloadData()
    }
    
    func addGroupedActivity(activity: Activity) {
        //print(activity.getDateWithFormat(format: "d")+1)
        //print(getCurrDate(format: "d"))
        if activity.getDateWithFormat(format: "d") == getCurrDate(format: "d") && activity.getDateWithFormat(format: "MM") == getCurrDate(format: "MM") && activity.getDateWithFormat(format: "yyyy") == getCurrDate(format: "yyyy") {
            //print("today")
            groupedActivities[0].addActivity(activity: activity)
        }
        else if activity.getDateWithFormat(format: "d") == getCurrDate(format: "d")+1 && activity.getDateWithFormat(format: "MM") == getCurrDate(format: "MM") && activity.getDateWithFormat(format: "yyyy") == getCurrDate(format: "yyyy") {
            //print("tmrw")
            groupedActivities[1].addActivity(activity: activity)
        }
        else {
            //print("up")
            groupedActivities[2].addActivity(activity: activity)
        }
        homeTableVIew.reloadData()
    }
    
    func editActivity(activity: Activity, sect: Int, row: Int) {
        //groupedActivities[sect].removeActivity(index: row)
        //addGroupedActivity(activity: activity)
        add(activity: activity)
        delete(id: groupedActivities[sect].getActivities()[row].getId())
        
        homeTableVIew.reloadData()
    }
    
    func add(activity: Activity) {
        let newActivity = UnfinishedTasks(context: self.context)
        newActivity.taskTitle = activity.getTitle()
        newActivity.taskDescription = activity.getDescription()
        newActivity.approximatedTime = Int16(activity.getApproxTime())
        print(newActivity.objectID)
        
        let sameDateIndex = isThereSameDate(date: activity.getDeadline())
        if sameDateIndex == -999 {
            let newTaskDate = TaskDates(context: self.context)
            newTaskDate.deadline = activity.getDeadline()
            
            newActivity.parentDeadline = newTaskDate
            self.taskDateArr.append(newTaskDate)
            self.unfinishedTaskArr.append(newActivity)
        }
        else {
            newActivity.parentDeadline = taskDateArr[sameDateIndex]
            self.unfinishedTaskArr.append(newActivity)
        }
        
        self.save()
    }
    
    func isThereSameDate(date: Date) -> Int{
        for index in 0..<taskDateArr.count {
            if date == taskDateArr[index].deadline {
                return index
            }
        }
        return -999
    }
    
    @IBAction func unwindBackToHome(segue: UIStoryboardSegue){
        //back button to home
    }
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedActivities[getRowCount()].getActivities().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableCell
        cell.activityTitleLbl.text = groupedActivities[getRowCount()].getActivities()[indexPath.row].getTitle()
        cell.approxTimeLbl.text = "\(groupedActivities[getRowCount()].getActivities()[indexPath.row].getApproxTime()) Hours"
        cell.deadlineLbl.text = groupedActivities[getRowCount()].getActivities()[indexPath.row].getDeadlineString()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "StartActivityVC") as? StartActivityVC
        vc?.setActivity(activity: groupedActivities[getRowCount()].getActivities()[indexPath.row], section: getRowCount(), row: indexPath.row)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //delete(groupedActivities[getRowCount()].getActivities()[indexPath.row].getId())
            delete(id: groupedActivities[getRowCount()].getActivities()[indexPath.row].getId())
        }
    }
    
    func load() {
        let requestUnfinishedTasks : NSFetchRequest<UnfinishedTasks> = UnfinishedTasks.fetchRequest()
        let requestTaskDates : NSFetchRequest<TaskDates> = TaskDates.fetchRequest()
        
        do {
            self.unfinishedTaskArr = try context.fetch(requestUnfinishedTasks)
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
    
    func delete(id: Int) {
        context.delete(unfinishedTaskArr[id])
        unfinishedTaskArr.remove(at: id)
        refreshTable()
        homeTableVIew.reloadData()
        loadActivity()
    }
}
