//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Julie Collazos on 02/01/2023.
//

import SwiftUI

@main
struct ToDoListApp: App {
    let persistenceController = PersistenceController.shared
    private let notificationManager = NotificationManager()

    init() {
        setupNotifications()
    }
    
    var body: some Scene {
        WindowGroup {
//            AddTaskViewCustom()
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    private func setupNotifications() {
        notificationManager.notificationCenter.delegate = notificationManager
        notificationManager.handleNotification = handleNotification
        
        requestNotificationsPermission()
    }
    
    private func handleNotification(notification: UNNotification) {
        print("<<<DEV>>> Notification received: \(notification.request.content.userInfo)")
    }
    
    private func requestNotificationsPermission() {
        notificationManager.requestPermission(completionHandler: { isGranted, error in
            if isGranted {
                print("User notification authorization: success ✅")
            }
            if let error = error {
                print("User notification authorization error: \(error.localizedDescription)")
                return
            }
        })
    }
}
