//
//  Activity.swift
//  MC1
//
//  Created by Alvian Gozali on 08/04/20.
//  Copyright © 2020 Alvian Gozali. All rights reserved.
//

import Foundation

class Activity {
    private var title: String
    private var description: String
    private var deadline: Date
    private var approxTime: Int
    private var id = 0
    
    init(title: String, description: String, deadline: Date, approxTime: Int) {
        self.title = title
        self.description = description
        self.deadline = deadline
        self.approxTime = approxTime
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    func setDescription(description: String) {
        self.description = description
    }
    func setDeadline(deadline: Date) {
        self.deadline = deadline
    }
    func setApproxTime(approxTime: Int) {
        self.approxTime = approxTime
    }
    func setId(id: Int){
        self.id = id
    }
    
    func getTitle() -> String {
        return title
    }
    func getDescription() -> String {
        return description
    }
    func getDeadline() -> Date {
        return deadline
    }
    func getApproxTime() -> Int {
        return approxTime
    }
    func getId() ->Int {
        return id
    }
    
    func getDeadlineString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: deadline)
        
        dateFormatter.dateFormat = "d"
        let dayOfMonth = dateFormatter.string(from: deadline)
        
        return "\(dayOfMonth)th \(nameOfMonth)"
    }
    
    func getDateWithFormat(format: String) -> Int{
        // d, MM, yyyy
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let temp = dateFormatter.string(from: deadline)
        return Int(temp)!
    }
    
}
