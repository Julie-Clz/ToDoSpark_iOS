//
//  EditTaskView.swift
//  ToDoList
//
//  Created by Julie Collazos on 04/01/2023.
//

import SwiftUI

struct EditTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var taskVM = TaskViewModel()
    var task: Task
    
    @State var title = ""
    @State var content = ""
    @State var selectedCategory: Category = .home
    @State var selectedPriority: Priority = .none
    @State var date = Date.now

    var body: some View {
        VStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $title)
                        .onAppear {
                            //MARK: define task values
                            title = task.title!
                            content = task.content!
                            date = task.dueDate!
                            if task.category! == Category.home.rawValue {
                                selectedCategory = .home
                            } else if task.category! == Category.hobbies.rawValue {
                                selectedCategory = .hobbies
                            } else if task.category! == Category.personal.rawValue {
                                selectedCategory = .personal
                            } else if task.category! == Category.work.rawValue {
                                selectedCategory = .work
                            }
                            if task.priority! == "" {
                                selectedPriority = .none
                            } else if task.priority! == "exclamationmark" {
                                selectedPriority = .low
                            } else if task.priority! == "exclamationmark.2" {
                                selectedPriority = .average
                            } else if task.priority! == "exclamationmark.3" {
                                selectedPriority = .high
                            }
                            print(task)
                        }
                    
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
                //MARK: Edit btn
                Button {
                    taskVM.editTask(task: task, title: title, category: selectedCategory, priority: selectedPriority, date: date, content: content, taskColor: selectedCategory.taskColor.back, textColor: selectedCategory.taskColor.text, vc: viewContext)
                    dismiss()
                } label: {
                    Text("Edit")
                        .foregroundColor(Color("gold"))
                        .fontWeight(.heavy)
                        .font(.title3)
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
        }
        .navigationBarTitle("Edit ToDo")
        .navigationBarTitleDisplayMode(.inline)
    }
}
// MARK: Preview
struct EditTaskView_Previews: PreviewProvider {
    static let persistence = PersistenceController.preview
    static var task: Task = {
        let context = persistence.container.viewContext
        let task = Task(context: context)
        task.title = "Titre Preview"
        task.content = "Ceci est le contenu de la todo "
        task.category = "loisirs"
        task.priority = "Elevée"
        task.dueDate = Date.now
        task.isDone = false
        return task
    }()
    static var previews: some View {
        NavigationView {
            EditTaskView(task: task)
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
