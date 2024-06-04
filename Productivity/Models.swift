//
//  Models.swift
//  Productivity
//
//  Created by Quentin on 17/01/2024.
//

import Foundation
import SwiftData

@Model
class Task {
    var name: String
    var date: Date
    var endDate: Date?
    var finished: Bool
    var details: String?
    var priority:String?
    var reccurency:Bool

    init(name: String, details: String, date: Date, priority: Int,reccurency : Bool) {
        self.name = name
        self.date = date
        self.finished = false
        self.details = details
        self.reccurency = reccurency
    }
    init(name:String){
        self.name = name
        self.finished = false
        self.date = Date()
        self.details = nil
        self.reccurency = false
    }
}
@Model
class LastUse {
    var date: Date
    
    init(date:Date){
        self.date = date
    }
}
