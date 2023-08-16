//
//  TaskVM.swift
//  ToDoList
//
//  Created by Julie Collazos on 02/03/2023.
//

import Foundation
import CoreData
import SwiftUI

@MainActor class TaskViewModel: ObservableObject {
    let notificationManager = NotificationManager()
    
    init() {}
    
    // MARK: load tasks
//    func loadData(vc: NSManagedObjectContext) -> [Task] {
//        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
//        do {
//            return try vc.fetch(fetchRequest)
//        } catch {
//            print("Echec de la mise à jour des ToDo: \(error)")
//            return []
//        }
//    }
    
    func reminderNotifScheduling(task: Task, vc: NSManagedObjectContext) {
        if !task.isDone {
            let notifId = scheduleNotification(triggerDate: task.dueDate!.addingTimeInterval(86400), taskContent: "\(task.title!): \(task.content!), \(dateFormatter(date: task.dueDate!)) @ \(timeFormatter(date: task.dueDate!))", taskPriority: task.priority!)
            task.notifId = notifId
            do {
                try vc.save()
                
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: Add task func
    func addTask(title: String, category: Category, priority: Priority, date: Date, content: String, taskColor: String, textColor: String, vc: NSManagedObjectContext) -> Task {
        withAnimation {
            let newTask = Task(context: vc)
            newTask.timestamp = Date()
            newTask.title = title
            newTask.category = category.rawValue
            newTask.priority = priority.priorityIcon
            newTask.dueDate = date
            newTask.content = content
            newTask.isDone = false
            newTask.taskColor = taskColor
            newTask.textColor = textColor
            // MARK: Notification send
            
            let notifId = scheduleNotification(triggerDate: newTask.dueDate!, taskContent: "\(newTask.title!): \(newTask.content!), \(dateFormatter(date: newTask.dueDate!)) @ \(timeFormatter(date: newTask.dueDate!))", taskPriority: newTask.priority!)
            newTask.notifId = notifId
            
            print("Notif ID save CD: \(notifId)")
            do {
                try vc.save()
                
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            return newTask
        }
    }
    
    // MARK: Notification create func
    func scheduleNotification(triggerDate: Date, taskContent: String, taskPriority: String) -> String {
        let notificationId = UUID()
        let content = UNMutableNotificationContent()
        content.title = "The ToDo App"
      
        if taskPriority == "exclamationmark.3" {
            let notifBody = NSLocalizedString("‼️🧨 Top Priority: \n", comment: "")
            content.body = "\(notifBody) \(taskContent)"
            content.sound = UNNotificationSound.defaultCritical
        } else if taskPriority == "exclamationmark.2"  {
            let notifBody = NSLocalizedString("‼️ High Priority: \n", comment: "")
            content.body = "\(notifBody) \(taskContent)"
            content.sound = UNNotificationSound.defaultRingtone
        } else if taskPriority == "exclamationmark"  {
            let notifBody = NSLocalizedString("❗️ Be carefull: \n", comment: "")
            content.body = "\(notifBody) \(taskContent)"
            content.sound = UNNotificationSound.default
        } else if taskPriority == ""  {
            let notifBody = NSLocalizedString("Reminder: \n", comment: "")
            content.body = "\(notifBody) \(taskContent)"
            content.sound = UNNotificationSound.default
        }
        content.userInfo = [
            "notificationId": "\(notificationId)" // additional info to parse if need
        ]
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: NotificationHelper.getTriggerDate(triggerDate: triggerDate)!,
            repeats: false
        )
        notificationManager.scheduleNotification(
            id: "\(notificationId)",
            content: content,
            trigger: trigger)
        
        print("Notif ID from Notif: \(notificationId)")
        return "\(notificationId)"
    }
    
    // MARK: Edit task func
    func editTask(task: Task, title: String, category: Category, priority: Priority, date: Date, content: String, taskColor: String, textColor: String, vc: NSManagedObjectContext) {
        withAnimation {
            task.title = title
            task.category = category.rawValue
            task.priority = priority.priorityIcon
            task.dueDate = date
            task.content = content
            task.isDone = false
            task.taskColor = category.taskColor.back
            task.textColor = category.taskColor.text
            
            notificationManager.removePendingNotification(id: task.notifId ?? "")
           
            let notifId = scheduleNotification(triggerDate: task.dueDate!, taskContent: "\(task.title!): \(task.content!), \(dateFormatter(date: task.dueDate!)) @ \(timeFormatter(date: task.dueDate!))", taskPriority: task.priority!)
            
            task.notifId = notifId
            do {
                try vc.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    //MARK: Done task func
    func doneTask(task: Task, vc: NSManagedObjectContext) {
        task.isDone = true
        notificationManager.removePendingNotification(id: task.notifId ?? "")
        do {
            try vc.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Save to CoreData func
//    func saveToCoreData(vc: NSManagedObjectContext) {
//        do {
//            try vc.save()
//        }
//        catch {
//            print(error.localizedDescription)
//        }
//    }
    
    // MARK: Delete task func
    func delete(task: Task, vc: NSManagedObjectContext) {
        notificationManager.removePendingNotification(id: task.notifId ?? "")
        vc.delete(task)
        do {
            try vc.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Delete task func with offsets
    //    func deleteTasks(offsets: IndexSet, vc: NSManagedObjectContext, tasks: FetchedResults<Task>) {
    //        withAnimation {
    //            let task = offsets.map { tasks[$0] }
    //            print(task)
    //            notificationManager.removePendingNotification(id: task.first!.notifId ?? "")
    //            offsets.map { tasks[$0] }.forEach(vc.delete)
    //
    //            do {
    //                try vc.save()
    //            } catch {
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
    
    // MARK: Move func
    //func moveTask(at sets:IndexSet, destination: Int, tasks: FetchedResults<Task>, vc: NSManagedObjectContext) {
    //    let itemToMove = sets.first!
    //
    //    if itemToMove < destination {
    //        var startIndex = itemToMove + 1
    //        let endIndex = destination - 1
    //        var startOrder = tasks[itemToMove].order
    //        while startIndex <= endIndex {
    //            tasks[startIndex].order = startOrder
    //            startOrder = startOrder + 1
    //            startIndex = startIndex + 1
    //        }
    //        tasks[itemToMove].order = startOrder
    //    }
    //    else if destination < itemToMove {
    //        var startIndex = destination
    //        let endIndex = itemToMove - 1
    //        var startOrder = tasks[destination].order + 1
    //        let newOrder = tasks[destination].order
    //        while startIndex <= endIndex{
    //            tasks[startIndex].order = startOrder
    //            startOrder = startOrder + 1
    //            startIndex = startIndex + 1
    //        }
    //        tasks[itemToMove].order = newOrder
    //    }
    //
    //    do {
    //        try vc.save()
    //    }
    //    catch {
    //        print(error.localizedDescription)
    //    }
    //}
}
