//
//  GroupedActivity.swift
//  MC1
//
//  Created by Alvian Gozali on 08/04/20.
//  Copyright © 2020 Alvian Gozali. All rights reserved.
//

import Foundation

class GroupedActivities {
    private var dateGroup: String
    private var activities = [Activity]()
    
    init(dateGroup: String) {
        self.dateGroup = dateGroup
    }
    
    func setDateGroup(dateGroup: String){
        self.dateGroup = dateGroup
    }
    func getDateGroup() -> String{
        return dateGroup
    }
    func getActivities() -> [Activity]{
        return activities
    }
    
    func addActivity(activity: Activity) {
        activities.append(activity)
    }
    func removeActivity(index: Int) {
        activities.remove(at: index)
    }
}
