//
//  ViewController.swift
//  Productivity
//
//  Created by Quentin on 10/01/2024.
//

import UIKit
import SwiftData
import Foundation


var actualTask = [0,0]
let colorBrokenWhite = UIColor(red: 244/255, green: 237/255, blue: 219/255, alpha: 1)
let colorBlue = UIColor(red: 35/255, green: 43/255, blue: 85/255, alpha: 1)
let colorRed = UIColor(red: 231/255, green: 98/255, blue: 108/255, alpha: 1)

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource, UISheetPresentationControllerDelegate, MyDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewWork {
                // Retourner le nombre de lignes pour le tableau des tâches en cours
                return tasks.count
            } else if tableView == tableViewDone {
                // Retourner le nombre de lignes pour le tableau des tâches terminées
                return tasksDone.count
            }

            // Retourner une valeur par défaut ou gérer d'autres cas si nécessaire
            return 0
    }
    
    
    @IBOutlet weak var navbar: UINavigationBar!
    
    @IBOutlet weak var tableViewWork: UITableView!
    
    @IBOutlet weak var tableViewDone: UITableView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var selectedDate = Date.getCurrentDate()
    var container: ModelContainer?
    var context: ModelContext?
    var lastUse = [LastUse]()
    var tasks = [Task]()
    var tasksDone = [Task]()
    var CaseDone = [true,"Cancel"] as [Any]
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        let avc = UIAlertController(title: "Info", message: "Add new item", preferredStyle: .alert)
        avc.addTextField()
        avc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action  in
            if let taskName = avc.textFields?.first?.text{
                
                
                DatabaseService.shared.saveTask(taskName: taskName)
                self.fetchData()
            }
        }))
        self.present(avc, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableViewWork.delegate = self
        tableViewWork.dataSource = self
        navbar.topItem!.title = Date.getCurrentDate()
        
        
        self.fetchData()
        updateReccurency()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.fetchData()
    }
    
    func updateReccurency(){
        
        if (lastUse.count == 0){
            DatabaseService.shared.saveLastUse(lastUsedDate: Date())
        }
        fetchData()
        if Calendar.current.isDate(lastUse[0].date, equalTo: Date(),toGranularity: .day) {
            DatabaseService.shared.updateLastUse(LastUse: lastUse[0], newDateLastUse: Date())
            }
        else {
            DatabaseService.shared.updateLastUse(LastUse: lastUse[0], newDateLastUse: Date())
            for iTask in tasksDone {
                DatabaseService.shared.updateTaskFinished(task: iTask, newTaskDone: true)
            }
            fetchData()
        }
    }
    
    func fetchData(){
        DatabaseService.shared.fetchLastUse{ data, error in
            if let error{
                print(error)
            }
            if let data{
                self.lastUse = data
                
            }
        }
        DatabaseService.shared.fetchTasks { data , error  in
            if let error{
                print(error)
            }
            if let data{
                self.tasks = data
                self.tasksDone = data
                self.tasks = data.filter { $0.finished == true && ( Calendar.current.isDate($0.date, equalTo: Date(),toGranularity: .day) || $0.reccurency == true)}
                self.tasksDone = data.filter { $0.finished == false && ( Calendar.current.isDate($0.date, equalTo: Date(),toGranularity: .day) || $0.reccurency == true)}

                
                self.tableViewDone.reloadData()
                self.tableViewWork.reloadData()
                print(Float(self.tasksDone.count) / Float(self.tasksDone.count + self.tasks.count))
                self.progressBar.setProgress( Float(self.tasksDone.count) / Float(self.tasksDone.count + self.tasks.count), animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = TaskCell()
        
        
        if tableView == tableViewWork {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskCell
            
            cell.TitleLabel.text = self.tasks[indexPath.row].name
            if self.tasks[indexPath.row].reccurency == false {
                print(self.tasks[indexPath.row].reccurency)
                cell.DateLabel.text = convertDateToString(date: self.tasks[indexPath.row].date)
            }
            else {
                cell.DateLabel.text = "All Day"
            }
            
            
            if self.tasks[indexPath.row].finished == false {
                cell.CheckMark.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            }
            
            else {cell.CheckMark.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)}
            
            cell.buttonPressed = {
                if self.tasks[indexPath.row].finished == false {
                    self.CaseDone = [true,"Cancel"]
                }
                else {
                    self.CaseDone = [false,"Done"]
                }
                DatabaseService.shared.updateTaskFinished(task: self.tasks[indexPath.row], newTaskDone: self.CaseDone[0] as! Bool)
                self.fetchData()
            }
        }
        if tableView == tableViewDone {
            
            
            cell = tableView.dequeueReusableCell(withIdentifier: "cellDone", for: indexPath) as! TaskCell
            cell.TitleLabel.text = self.tasksDone[indexPath.row].name
            if self.tasksDone[indexPath.row].reccurency == false {
                print(self.tasksDone[indexPath.row].reccurency)
                cell.DateLabel.text = convertDateToString(date: self.tasksDone[indexPath.row].date)
            }
            else {
                cell.DateLabel.text = "All Day"
            }
            
            if self.tasksDone[indexPath.row].finished == false {
                cell.CheckMark.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            }
            
            else {cell.CheckMark.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)}
            
            cell.buttonPressed = {
                if self.tasksDone[indexPath.row].finished == false {
                    self.CaseDone = [true,"Cancel"]
                }
                else {
                    self.CaseDone = [false,"Done"]
                }
                DatabaseService.shared.updateTaskFinished(task: self.tasksDone[indexPath.row], newTaskDone: self.CaseDone[0] as! Bool)
                
                
                self.fetchData()
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var delete = UIContextualAction()
        if tableView == tableViewWork{
            delete = UIContextualAction(style: .destructive, title: "Delete") { ctx,_ , completion  in
                
                DatabaseService.shared.deleteTask(task: self.tasks[indexPath.row])
                self.fetchData()
            }
        }
        else if tableView == tableViewDone {
            delete = UIContextualAction(style: .destructive, title: "Delete") { ctx,_ , completion  in
                
                DatabaseService.shared.deleteTask(task: self.tasksDone[indexPath.row])
                self.fetchData()
            }
        }
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        return config
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        
        if tableView == tableViewWork{
            actualTask[0] = 0
            
        }
        if tableView == tableViewDone{
            
            actualTask[0] = 1
        }
        actualTask[1] = indexPath.row
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "TaskDetail") as! DetailViewController
                vc.delegate = self
        if let presentationController = vc.presentationController as? UISheetPresentationController {
                   presentationController.delegate = self
                   presentationController.detents = [.medium(), .large()]
               }
        present(vc, animated: true, completion: nil)
        
      }
}
