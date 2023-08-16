//
//  Persistence.swift
//  ToDoList
//
//  Created by Julie Collazos on 02/01/2023.
//

import CoreData
import SwiftUI

struct PersistenceController {
    static let shared = PersistenceController()
 
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
     
//        for _ in 0..<10 {
//            let newTask = Task(context: viewContext)
//            newTask.timestamp = Date()
//        }
        let task1 = Task(context: viewContext)
        task1.timestamp = Date()
        task1.title = "Diner Noel"
//        task1.category = Category.home.rawValue.localizedCapitalized
        task1.category = "Home"
        task1.priority = Priority.low.priorityIcon
        task1.content = "Préparer le menu du diner de noel"
        task1.dueDate = Date()
        task1.isDone = false
        task1.taskColor = "lavender"
        task1.textColor = "black"
//        task1.isFavorite = false
        let task2 = Task(context: viewContext)
        task2.timestamp = Date()
        task2.title = "Ménage"
//        task2.category = Category.home.rawValue.localizedCapitalized
        task2.category = "Home"
        task2.priority = Priority.low.priorityIcon
        task2.content = "Ménage & rangement dans la chambre d'amis"
        task2.dueDate = Calendar.current.date(bySettingHour: 12, minute: 00, second: 00, of: Date())!
        task2.isDone = false
        task2.taskColor = "lavender"
        task2.textColor = "black"
        let task3 = Task(context: viewContext)
        task3.timestamp = Date()
        task3.title = "Mailys Website"
//        task3.category = Category.work.rawValue.localizedCapitalized
        task3.category = "Work"
        task3.priority = Priority.high.priorityIcon
        task3.content = "Terminer la refonte du site et chercher un hébergement"
        task3.dueDate = Date().addingTimeInterval(64000)
        task3.isDone = false
        task3.taskColor = "navy"
        task3.textColor = "white"
        let task4 = Task(context: viewContext)
        task4.timestamp = Date()
        task4.title = "Sofia's birthday"
//        task4.category = Category.personal.rawValue.localizedCapitalized
        task4.category = "Private"
        task4.priority = Priority.average.priorityIcon
        task4.content = "Organiser le retour & faire le sac"
        task4.dueDate = Date().addingTimeInterval(336000)
        task4.isDone = false
        task4.taskColor = "tan"
        task4.textColor = "black"
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
// 1 - from NSPersistentContainer to NSPersistentCloudKitContainer
    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "ToDoList")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
