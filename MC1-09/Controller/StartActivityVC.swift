//
//  StartActivityVC.swift
//  MC1
//
//  Created by Alvian Gozali on 09/04/20.
//  Copyright © 2020 Alvian Gozali. All rights reserved.
//

import UIKit
import CoreData

class StartActivityVC: UIViewController {
    
    @IBOutlet weak var approxTimeLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var startActivityNavBar: UINavigationItem!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var workTimeLbl: UILabel!
    @IBOutlet weak var breakMenuLbl: UILabel!
    @IBOutlet weak var breakTimerLbl: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var startLbl: UILabel!
    @IBOutlet weak var breakBtn: UIButton!
    @IBOutlet weak var breakLbl: UILabel!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var finishLbl: UILabel!
    
    //mestinya untuk timer bikin class baru wkwkwkwk bar2
    private var workTimer = Timer()
    private var fractionWorkTimer = 0
    private var secondWorkTimer = 0
    private var minuteWorkTimer = 0
    private var hourWorkTimer = 0
    
    private var breakTimer = Timer()
    private var fractionBreakTimer = 0
    private var secondBreakTimer = 0
    private var minuteBreakTimer = 0
    private var hourBreakTimer = 0
    
    private var activity: Activity!
    private var section = 0
    private var row = 0
    
    private var breakTime = 0
    private var workTime = 0
    
    var finishedTaskArr = [FinishedTasks]()
    var taskDateArr = [TaskDates]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        breakBtnHiddenStatus(status: true)
        finishBtnHiddenStatus(status: true)
        breakTimerHiddenStatus(status: true)
        flag = false
        
        setData()
        // Do any additional setup after loading the view.
    }
    
    func setActivity(activity: Activity, section: Int, row: Int) {
        self.activity = activity
        self.section = section
        self.row = row
    }
    
    func setData() {
        startActivityNavBar.title = activity?.getTitle()
        startActivityNavBar.rightBarButtonItem?.isEnabled = true
        startActivityNavBar.rightBarButtonItem?.title = "Edit"
        descriptionLbl.text = activity?.getTitle()
        approxTimeLbl.text = ("\(activity!.getApproxTime()) Hours")
    }
    
    func startBtnHiddenStatus(status: Bool) {
        startButton.isHidden = status
        startLbl.isHidden = status
    }
    
    func breakBtnHiddenStatus(status: Bool) {
        breakBtn.isHidden = status
        breakLbl.isHidden = status
    }
    
    func finishBtnHiddenStatus(status: Bool) {
        finishBtn.isHidden = status
        finishLbl.isHidden = status
    }
    
    func breakTimerHiddenStatus(status: Bool) {
        breakMenuLbl.isHidden = status
        breakTimerLbl.isHidden = status
    }
    
    func toSecond(second: Int, minute: Int, hour: Int) -> Int {
        return second + (minute*60) + (hour*3600)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EditActivityVC {
            vc.initActivity(activity: activity, section: section, row: row)
        }
        if let vc = segue.destination as? HomeVC {
            vc.editActivity(activity: activity, sect: section, row: row)
        }
        if flag == true {
            if let vc = segue.destination as? HomeVC {
                vc.removeActivity(sect: section, row: row)
                
            }
        }
    }
    
    @objc func workTimerMethod() {
        fractionWorkTimer += 1
        if fractionWorkTimer > 99 {
            secondWorkTimer += 1
            fractionWorkTimer = 0
        }
        if secondWorkTimer == 60 {
            minuteWorkTimer += 1
            secondWorkTimer = 0
        }
        if minuteWorkTimer == 60 {
            hourWorkTimer += 1
            minuteWorkTimer = 0
        }
        
        let secondString = secondWorkTimer > 9 ? "\(secondWorkTimer)" : "0\(secondWorkTimer)"
        let minuteString = minuteWorkTimer > 9 ? "\(minuteWorkTimer)" : "0\(minuteWorkTimer)"
        let hourString = hourWorkTimer > 9 ? "\(hourWorkTimer)" : "0\(hourWorkTimer)"
        
        workTimeLbl.text = "\(hourString):\(minuteString):\(secondString)"
    }
    
    @objc func breakTimerMethod() {
        fractionBreakTimer += 1
        if fractionBreakTimer > 99 {
            secondBreakTimer += 1
            fractionBreakTimer = 0
        }
        if secondBreakTimer == 60 {
            minuteBreakTimer += 1
            secondBreakTimer = 0
        }
        if minuteBreakTimer == 60 {
            hourBreakTimer += 1
            minuteBreakTimer = 0
        }
        
        let secondString = secondBreakTimer > 9 ? "\(secondBreakTimer)" : "0\(secondBreakTimer)"
        let minuteString = minuteBreakTimer > 9 ? "\(minuteBreakTimer)" : "0\(minuteBreakTimer)"
        let hourString = hourBreakTimer > 9 ? "\(hourBreakTimer)" : "0\(hourBreakTimer)"
        
        breakTimerLbl.text = "\(hourString):\(minuteString):\(secondString)"
    }
    
    @IBAction func startButton(_ sender: Any) {
        startBtnHiddenStatus(status: true)
        breakBtnHiddenStatus(status: false)
        finishBtnHiddenStatus(status: false)
        editButton.isHidden = true
        
        workTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(StartActivityVC.workTimerMethod), userInfo: nil, repeats: true)
    }
    
    @IBAction func breakButton(_ sender: Any) {
        if breakLbl.text == "BREAK" {
            breakLbl.text = "RESUME"
            breakTimerHiddenStatus(status: false)
            
            breakTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(StartActivityVC.breakTimerMethod), userInfo: nil, repeats: true)
        }
        else {
            breakLbl.text = "BREAK"
            breakTimerHiddenStatus(status: true)
            breakTimer.invalidate()
        }
    }
    
    @IBAction func finishButton(_ sender: Any) {
        workTimer.invalidate()
        breakTimer.invalidate()
        
        workTime = toSecond(second: secondWorkTimer, minute: minuteWorkTimer, hour: hourWorkTimer)/60
        breakTime = toSecond(second: secondBreakTimer, minute: minuteBreakTimer, hour: hourBreakTimer)/60
        flag = true
        print("\(activity.getApproxTime()*3600)")
        print(workTime)
        
        let newFinishedActivity = FinishedTasks(context: context.self)
        newFinishedActivity.parentDeadline = TaskDates(context: context.self)

        newFinishedActivity.parentDeadline?.deadline = activity.getDeadline()
        newFinishedActivity.taskTitle = activity.getTitle()
        newFinishedActivity.approximatedTime = Int16(activity.getApproxTime()*3600)
        newFinishedActivity.workTime = Int16(workTime)
        newFinishedActivity.breakTime = Int16(breakTime)
        
        finishedTaskArr.append(newFinishedActivity)
        
        self.save()
        
        performSegue(withIdentifier: "backToHome", sender: self)
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        performSegue(withIdentifier: "goToEditActivity", sender: self)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        performSegue(withIdentifier: "backToHome", sender: self)
    }
    
    @IBAction func unwindBackToStartActivity(segue: UIStoryboardSegue) {
        //back to this VC
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
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
    
}
