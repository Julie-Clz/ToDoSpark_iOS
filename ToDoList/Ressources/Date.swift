//
//  Date.swift
//  ToDoList
//
//  Created by Julie Collazos on 06/01/2023.
//

import Foundation

func dateTimeFormatter(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/YY HH:mm"
    return dateFormatter.string(from: date)
}
func timeFormatter(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: date)
}
func dateFormatter(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YY/MM/dd"
    return dateFormatter.string(from: date)
}

let taskDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
let taskTimeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

//func noon() -> Date {
//    let calendar = Calendar.current
//    return calendar.date(bySettingHour: 12, minute: 00, second: 00, of: Date())!
//  }

//   func formatStringDate(date: String) -> String {
//       let dateFormatter = DateFormatter()
//       dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//       let newDate = dateFormatter.date(from: date)
//       dateFormatter.setLocalizedDateFormatFromTemplate("dd MMMM yyyy")
//       return dateFormatter.string(from: newDate ?? Date.now)
//   }
   
//   func formatStringDateShort(date: String) -> String {
//       let dateFormatter = DateFormatter()
//       dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//       let newDate = dateFormatter.date(from: date)
//       dateFormatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
//       return dateFormatter.string(from: newDate ?? Date.now)
//   }
   
//   func formatStringTime(date: String) -> String {
//       let dateFormatter = DateFormatter()
//       dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//       let newDate = dateFormatter.date(from: date)
//       dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
//       return dateFormatter.string(from: newDate ?? Date.now)
//   }
   
//   func formatTimeToString(date: Date) -> String {
//       let dateFormatter = DateFormatter()
//       dateFormatter.timeStyle = .short
//       //        let newDate = dateFormatter.date(from: date)
//       dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
//       return dateFormatter.string(from: date)
//   }

//let taskFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .short
//    return formatter
//}()


