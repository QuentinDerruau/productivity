//
//  manageDB.swift
//  Productivity
//
//  Created by Quentin on 17/01/2024.
//

import Foundation
import SwiftData
class DatabaseService{
    static var shared = DatabaseService()
    var container: ModelContainer?
    var context: ModelContext?
    
    init(){
        do{
            container = try! ModelContainer(for: Task.self, LastUse.self)
            if let container{
                context = ModelContext(container)
            }
        }
    }
    
    func saveTask(taskName: String?){
        guard let taskName else{return }
        if let context{
            let taskToBeSaved = Task(name: taskName)
            context.insert(taskToBeSaved)
        }
    }
    func saveLastUse(lastUsedDate : Date?){
        guard let lastUsedDate else{return }
        if let context{
            let lastUseToBeSaved = LastUse(date: lastUsedDate)
            context.insert(lastUseToBeSaved)
        }
    }
    
    func fetchTasks(onCompletion:@escaping([Task]?,Error?)->(Void)){
        let descriptor = FetchDescriptor<Task>(sortBy: [SortDescriptor<Task>(\.name)])
        if let context{
            do{
                let data = try context.fetch(descriptor)
                onCompletion(data,nil)
            }
            catch{
                onCompletion(nil,error)
            }
        }
    }
    func fetchLastUse(onCompletion:@escaping([LastUse]?,Error?)->(Void)){
        let descriptor = FetchDescriptor<LastUse>(sortBy: [SortDescriptor<LastUse>(\.date)])
        if let context{
            do{
                let data = try context.fetch(descriptor)
                onCompletion(data,nil)
            }
            catch{
                onCompletion(nil,error)
            }
        }
    }
    func updateLastUse(LastUse: LastUse,newDateLastUse: Date){
        let LastUseToBeUpdated = LastUse
        LastUseToBeUpdated.date = newDateLastUse
    }
    func updateTaskName(task: Task,newTaskName: String){
        let taskToBeUpdated = task
        taskToBeUpdated.name = newTaskName
    }
    func updateTaskDate(task: Task,newTaskDate: Date){
        let taskToBeUpdated = task
        taskToBeUpdated.date = newTaskDate
    }
    func updateTaskFinished(task: Task,newTaskDone: Bool){
        let taskToBeUpdated = task
        taskToBeUpdated.finished = newTaskDone
    }
    func updateTaskDetails(task: Task,newTaskDetails: String){
        let taskToBeUpdated = task
        taskToBeUpdated.details = newTaskDetails
    }
    func updateTaskPriority(task: Task,newTaskPriority: String){
        let taskToBeUpdated = task
        taskToBeUpdated.priority = newTaskPriority
    }
    func updateTaskReccurency(task: Task, newTaskReccurency: Bool){
        let taskToBeUpdated = task
        taskToBeUpdated.reccurency = newTaskReccurency
    }
    
    func deleteTask(task: Task){
        let taskToBeDeleted = task
        if let context{
            context.delete(taskToBeDeleted)
        }
    }
    
}
