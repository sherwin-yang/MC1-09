//
//  Task.swift
//  MC1-09
//
//  Created by Sherwin Yang on 10/04/20.
//  Copyright © 2020 Sherwin Yang. All rights reserved.
//

import Foundation

class FinishedTask {
    var deadline_MonthYear: Date
    var title: [String]
    var approximatedTime: [Int16]
    var workTime: [Int16]
    var breakTime: [Int16]
    
    init(deadline_MonthYear: Date, title: [String], approximatedTime: [Int16], workTime: [Int16], breakTime: [Int16]) {
        self.deadline_MonthYear = deadline_MonthYear
        self.title = title
        self.approximatedTime = approximatedTime
        self.workTime = workTime
        self.breakTime = breakTime
    }
}
