//
//  EditActivityVC.swift
//  MC1
//
//  Created by Alvian Gozali on 13/04/20.
//  Copyright © 2020 Alvian Gozali. All rights reserved.
//

import UIKit

class EditActivityVC: UIViewController {
    
    @IBOutlet weak var titleTextbox: UITextField!
    @IBOutlet weak var descriptionTextbox: UITextField!
    @IBOutlet weak var deadlineLbl: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var approxTimeLbl: UILabel!
    @IBOutlet weak var stepperValue: UIStepper!
    
    
    private var approxTime = 0
    private var activity: Activity!
    private var section = 0
    private var row = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextbox.text = self.activity.getTitle()
        descriptionTextbox.text = self.activity.getDescription()
        deadlineLbl.text = self.activity.getDeadlineString()
        approxTime = self.activity.getApproxTime()
        stepperValue.value = Double(approxTime)
        approxTimeLbl.text = "\(approxTime)"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func stepper(_ sender: Any) {
        approxTime = Int(stepperValue.value)
        approxTimeLbl.text = "\(approxTime)"
    }
    
    @IBAction func datePickerSelect(_ sender: Any) {
        deadlineLbl.text = getDateInString()
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let deadline = datePicker.date
        let title = titleTextbox.text!
        let description = descriptionTextbox.text!
        let act = Activity.init(title: title, description: description, deadline: deadline, approxTime: approxTime)
        activity = act
        performSegue(withIdentifier: "unwindBackToStart", sender: self)
        dismiss(animated: true, completion: nil)
    }
    
    func getDateInString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL, HH:mm"
        let nameOfMonth = dateFormatter.string(from: datePicker.date)
        
        dateFormatter.dateFormat = "d"
        let dayOfMonth = dateFormatter.string(from: datePicker.date)
        
        return "\(dayOfMonth)th \(nameOfMonth)"
    }
    
    func initActivity(activity: Activity, section: Int, row: Int) {
        self.activity = activity
        self.section = section
        self.row = row
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? StartActivityVC {
            print(activity.getDeadline())
            vc.setActivity(activity: activity, section: section, row: row)
            vc.viewDidLoad()
        }
    }
}
