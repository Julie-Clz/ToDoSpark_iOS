//
//  AddTaskView.swift
//  ToDoList
//
//  Created by Julie Collazos on 04/01/2023.
//

import SwiftUI


struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var taskVM = TaskViewModel()
    
    @State var title = ""
    @State var content = ""
    @State var selectedCategory: Category = .home
    @State var selectedPriority: Priority = .none
    @State var date = Date.now

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Details") {
                        TextField("Title", text: $title)
                        DatePicker("Date", selection: $date, displayedComponents: [.date])
                            .accessibility(identifier: "Date")
                        DatePicker("Time", selection: $date, displayedComponents: [.hourAndMinute])
                            .accessibility(identifier: "Time")
                            .datePickerStyle(.compact)
                        
                        Picker("Priority", selection: $selectedPriority) {
                            ForEach(Priority.allCases, id: \.self) {
                                Text($0.localized)
                            }
                        }
                        .pickerStyle(.menu)
                        .accessibilityIdentifier("Priority")
                    }
                    Section("Content") {
                        TextEditor(text: $content)
                    }
                    Section("Category") {
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(Category.allCases, id: \.self) {
                                Text($0.localized)
                            }
                        }
                        .pickerStyle(.segmented)
                        .colorMultiply(Color("gold"))
                    }
                    //MARK: Add btn
                    Button {
                       let _ = taskVM.addTask(title: title, category: selectedCategory, priority: selectedPriority, date: date, content: content, taskColor: selectedCategory.taskColor.back, textColor: selectedCategory.taskColor.text, vc: viewContext)
                        dismiss()
                    } label: {
                        Text("Create")
                            .foregroundColor(Color("gold"))
                            .fontWeight(.heavy)
                            .font(.title3)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .disabled(title.isEmpty)
                }
            }
            .navigationBarTitle("New ToDo")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
