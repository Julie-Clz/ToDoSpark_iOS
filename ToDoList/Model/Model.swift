//
//  Model.swift
//  ToDoList
//
//  Created by Julie Collazos on 06/01/2023.
//

import Foundation

enum ReminderInterval: String, CaseIterable, Identifiable, Hashable {
    case oneDayBefore = "One Day before", twoDayBefore = "Two days before", oneHourBefore = "One hour before", twoHoursBefore = "Two hours before", onTime = "On ToDo time"
    var id: Self { self }
    
    var localized: String {
       return NSLocalizedString(self.rawValue, comment: "")
     }
    
    var reminderDate: Int {
        switch self {
        case .onTime:
            return 0
        case .oneDayBefore:
            return (-86400)
        case .twoDayBefore:
            return (-172800)
        case .oneHourBefore:
            return (-3600)
        case .twoHoursBefore:
            return (-7200)
        }
    }
}

enum Category: String, CaseIterable, Identifiable, Hashable {
    case home = "Home", personal = "Private", work = "Work", hobbies = "Hobbies"
    var id: Self { self }
    
    var localized: String {
       return NSLocalizedString(self.rawValue, comment: "")
     }
    
    var taskColor: (back: String, text: String) {
        switch self {
        case .home:
            return("oxblood", "white")
        case .personal:
            return("teal", "black")
        case .work:
            return("navy", "white")
        case .hobbies:
            return("lavender", "black")
        }
    }
}


enum Priority: String, CaseIterable, Identifiable {
    case none = "None", low = "Low", average = "Average", high = "High"
    var id: Self { self }
    
    var localized: String {
       return NSLocalizedString(self.rawValue, comment: "")
     }
    
    var priorityIcon: (String) {
        switch self {
        case .none:
            return("")
        case .low:
            return("exclamationmark")
        case .average:
            return("exclamationmark.2")
        case .high:
            return("exclamationmark.3")
        }
    }
    var priorityInt: (Int) {
        switch self {
        case .none:
            return(0)
        case .low:
            return(1)
        case .average:
            return(2)
        case .high:
            return(3)
        }
    }
}
