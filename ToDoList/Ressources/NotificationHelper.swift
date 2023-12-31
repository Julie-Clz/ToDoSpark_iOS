//
//  NotificationHelper.swift
//  ToDoList
//
//  Created by Julie Collazos on 06/01/2023.
//

import Foundation
import SwiftUI
import UserNotifications

class NotificationHelper {
    static func getTriggerDate(triggerDate: Date) -> DateComponents? {
//        let triggerDate = Date().addingTimeInterval(10)
        return Calendar.current.dateComponents([.timeZone, .year, .month, .day, .hour, .minute, .second], from: triggerDate)
    }
}

