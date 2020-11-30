//
//  AddActivityVC.swift
//  MC1
//
//  Created by Alvian Gozali on 13/04/20.
//  Copyright © 2020 Alvian Gozali. All rights reserved.
//

import UIKit
import CoreData

class AddActivityVC: UIViewController {
    
    @IBOutlet weak var titleTextBox: UITextField!
    @IBOutlet weak var descriptionTextBox: UITextField!
    @IBOutlet weak var deadLineLbl: UILabel!
    @IBOutlet weak var approxTimeLbl: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var stepperValue: UIStepper!
    
    private var approxTime = 0
    private var activity: Activity!
    
    var unfinishedTaskArr = [UnfinishedTasks]()
    var taskDateArr = [TaskDates]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deadLineLbl.text = getDateInString()
    }
    
    @IBAction func stepper(_ sender: Any) {
        approxTime = Int(stepperValue.value)
        approxTimeLbl.text = "\(approxTime)"
    }
    

    @IBAction func datePickerSelect(_ sender: Any) {
        deadLineLbl.text = getDateInString()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        let newActivity = UnfinishedTasks(context: self.context)
        
        let deadline = datePicker.date
        let title = titleTextBox.text!
        let description = descriptionTextBox.text!
        let act = Activity.init(title: title, description: description, deadline: deadline, approxTime: approxTime)
        activity = act
        
        newActivity.taskTitle = title
        newActivity.taskDescription = description
        newActivity.approximatedTime = Int16(approxTime)
        print(newActivity.objectID)
        
        let sameDateIndex = isThereSameDate(date: deadline)
        if sameDateIndex == -999 {
            let newTaskDate = TaskDates(context: self.context)
            newTaskDate.deadline = deadline
            
            newActivity.parentDeadline = newTaskDate
            self.taskDateArr.append(newTaskDate)
            self.unfinishedTaskArr.append(newActivity)
        }
        else {
            newActivity.parentDeadline = taskDateArr[sameDateIndex]
            self.unfinishedTaskArr.append(newActivity)
        }
        
        self.save()
        performSegue(withIdentifier: "backToHome", sender: self)
        dismiss(animated: true, completion: nil)
    }
    
    func isThereSameDate(date: Date) -> Int{
        for index in 0..<taskDateArr.count {
            if date == taskDateArr[index].deadline {
                return index
            }
        }
        return -999
    }
    
    func getDateInString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL, HH:mm"
        let nameOfMonth = dateFormatter.string(from: datePicker.date)
        
        dateFormatter.dateFormat = "d"
        let dayOfMonth = dateFormatter.string(from: datePicker.date)
        
        return "\(dayOfMonth)th \(nameOfMonth)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if activity != nil {
            if let vc = segue.destination as? HomeVC {
                vc.refreshTable()
                vc.loadActivity()
                //vc.addGroupedActivity(activity: activity)
            }
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
}
