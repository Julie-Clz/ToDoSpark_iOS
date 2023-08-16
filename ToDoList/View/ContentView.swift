//
//  ContentView.swift
//  ToDoList
//
//  Created by Julie Collazos on 02/01/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: Core data variable
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Task.order, ascending: true),
            NSSortDescriptor(keyPath: \Task.dueDate, ascending: true),
            NSSortDescriptor(keyPath: \Task.priority, ascending: true)
        ], animation: .default) var tasks: FetchedResults<Task>
    // MARK: ViewModel
    @ObservedObject var taskVM = TaskViewModel()
    
    // MARK: filter & sorting variable
    @State var doneTasks = false
    @State var taskPriorityUp = false
    @State var taskPriorityDown = false
    @State var taskDueDateRecent = false
    @State var taskDueDateOlder = false
    @State var showHomeCategory = false
    @State var showWorkCategory = false
    @State var showPrivateCategory = false
    @State var showLeisureCategory = false
    
    var filteredTasks: [Task] {
        tasks.filter { task in
            (!showHomeCategory || task.category == Category.home.rawValue.localizedCapitalized)
        }
        .filter { task in
            (!showWorkCategory || task.category == Category.work.rawValue.localizedCapitalized)
        }
        .filter { task in
            (!showPrivateCategory || task.category == Category.personal.rawValue.localizedCapitalized)
        }
        .filter { task in
            (!showLeisureCategory || task.category == Category.hobbies.rawValue.localizedCapitalized)
        }
        .filter { task in
            (doneTasks || task.isDone == false )
        }
        .filter { task in
            (!doneTasks || task.isDone == true )
        }
        .sorted { task1, task2 in
            (!taskPriorityUp || task1.priority! < task2.priority!)
        }
        .sorted { task1, task2 in
            (!taskPriorityDown || task2.priority! > task1.priority!)
        }
        .sorted { task1, task2 in
            (!taskDueDateOlder || task2.dueDate! < task1.dueDate!)
        }
        .sorted { task1, task2 in
            (!taskDueDateRecent || task1.dueDate! > task2.dueDate!)
        }
    }
    
    // MARK: sheets variable
    @State var isAddTaskPresented = false
    @State var isEditTaskPresented = false
    
    // MARK: Localization swift variable
    var home = Category.home.localized
    var work = Category.work.localized
    var personal = Category.personal.localized
    var hobbies = Category.hobbies.localized
    
//    var customCategory: [String] = ["Home", "Private", "Work", "Hobbies"]
    var body: some View {
        NavigationStack {
            VStack {
                if tasks.isEmpty {
                    Spacer()
                    Text("You doesn't have any ToDo yet...")
                        .multilineTextAlignment(.center)
                        .font(.custom("Chalkduster", size: 24))
                        .foregroundColor(Color("gold"))
                    Spacer()
                } else {
                    // MARK: Picker Current / Done
                    Picker("Status", selection: $doneTasks) {
                        Text("In progress").tag(false)
                        Text("Done").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .colorMultiply(Color("gold"))
                    .padding(.horizontal)
                    .padding(.top, 30)
                    List {
                        ForEach(filteredTasks, id: \.self) { task in
                            NavigationLink {
                                EditTaskView(task: task)
                            } label: {
                                HStack(alignment: .firstTextBaseline) {
                                    VStack(alignment: .leading, spacing: 20) {
                                        Text(task.title?.capitalized ?? "")
                                            .font(.title3)
                                            .fontWeight(.heavy)
                                        Text(task.content ?? "")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                    }
                                    .padding(.vertical)
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 20) {
                                        Text("\(task.dueDate ?? Date.now, formatter: taskDateFormatter) @ \(task.dueDate ?? Date.now, formatter: taskTimeFormatter)")
                                            .font(.caption)
                                        Image(systemName: task.priority ?? "")
                                            .foregroundColor(Color("gold"))
                                            .fontWeight(.black)
                                            .font(.title3)
                                            .accessibilityLabel(Text("Priority"))
                                            .padding(.horizontal)
                                        
                                    }
                                }
                            }
                            .frame(minHeight: 80)
                            .foregroundColor(Color(task.textColor ?? "black"))
                            .listRowBackground(Color(task.taskColor ?? "poppy"))
                            HStack {
                                // MARK: Done Task btn
                                Button {
                                    // action dans le onTapGesture (conflit avec le navigation link)
                                } label: {
                                    Image(systemName: task.isDone ? "checkmark.circle" : "circle")
                                        .foregroundColor(Color("gold"))
                                        .fontWeight(.black)
                                        .font(.title3)
                                }
                                .onTapGesture {
                                    taskVM.doneTask(task: task, vc: viewContext)
                                }
                                // MARK: Delete Task btn
                                Button {
                                    // action dans le onTapGesture (conflit avec le navigation link)
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(Color("gold"))
                                        .fontWeight(.black)
                                        .font(.title3)
                                        .accessibilityLabel(Text("Delete ToDo"))
                                }
                                .onTapGesture {
                                    taskVM.delete(task: task, vc: viewContext)
                                }
                                
                                Spacer()
                                
                                // MARK: ShareLink
                                ShareLink(item: "\(task.title!): \(task.content!) le \(dateTimeFormatter(date: task.dueDate!))") {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(Color("gold"))
                                        .fontWeight(.black)
                                        .font(.title3)
                                        .accessibilityLabel(Text("Edit ToDo"))
                                }
                            }
                            .listRowBackground(Color(task.taskColor ?? "poppy"))
                            .listRowSeparator(.hidden)
                        }
                        //                        .onMove { indexSet, destination in
                        //                            taskVM.moveTask(at: indexSet, destination: destination, tasks: tasks, vc: viewContext)
                        //                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .listStyle(.inset)
                    .scrollIndicators(.hidden)
                }
            }
            .navigationTitle("ToDo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("logoToDo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .padding(.bottom, 8)
                }
                if !tasks.isEmpty {
                    // MARK: Sort button
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu {
                            Button {
                                taskPriorityUp.toggle()
                                if taskPriorityUp {
                                    taskPriorityDown = false
                                    taskDueDateOlder = false
                                    taskDueDateRecent = false
                                } else {
                                    taskPriorityDown = true
                                    taskDueDateOlder = false
                                    taskDueDateRecent = false
                                }
                            } label: {
                                if taskPriorityUp {
                                    Text("✓ Priority ↑")
                                } else if taskPriorityDown {
                                    Text("✓ Priority ↓")
                                } else {
                                    Text("Priority ↑↓")
                                }
                            }
                            
                            Button {
                                taskDueDateOlder.toggle()
                                if taskDueDateOlder {
                                    taskPriorityUp = false
                                    taskPriorityDown = false
                                    taskDueDateRecent = false
                                } else {
                                    taskDueDateRecent = true
                                    taskPriorityUp = false
                                    taskPriorityDown = false
                                }
                            } label: {
                                if taskDueDateOlder {
                                    Text("✓ Date ↓")
                                } else if taskDueDateRecent {
                                    Text("✓ Date ↑")
                                } else {
                                    Text("Date ↓↑")
                                }
                            }
                            Button {
                                taskDueDateOlder = false
                                taskPriorityUp = false
                                taskPriorityDown = false
                                taskDueDateRecent = false
                            } label: {
                                if !taskDueDateOlder && !taskPriorityUp && !taskPriorityDown && !taskDueDateRecent {
                                    Text("✓ None")
                                } else {
                                    Text("None")
                                }
                            }
                            
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .foregroundColor(Color("gold"))
                                .padding()
                        }
                    }
                    // MARK: Filter button
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            // Home filter
                            Button {
                                showHomeCategory.toggle()
                                if showWorkCategory || showPrivateCategory || showLeisureCategory  {
                                    showWorkCategory = false
                                    showPrivateCategory = false
                                    showLeisureCategory = false
                                }
                            } label: {
                                if showHomeCategory {
                                    Text("✓ \(home) 🪴")
                                        .tint(Color("gold"))
                                } else {
                                    Text("\(home) 🪴")
                                }
                            }
                            
                            // Work filter
                            Button {
                                showWorkCategory.toggle()
                                if showHomeCategory || showPrivateCategory || showLeisureCategory  {
                                    showHomeCategory = false
                                    showPrivateCategory = false
                                    showLeisureCategory = false
                                }
                            } label: {
                                if showWorkCategory {
                                    Text("✓ \(work) 💻")
                                } else {
                                    Text("\(work) 💻")
                                }
                                
                            }
                            
                            // Private filter
                            Button {
                                showPrivateCategory.toggle()
                                if showHomeCategory || showWorkCategory || showLeisureCategory  {
                                    showHomeCategory = false
                                    showWorkCategory = false
                                    showLeisureCategory = false
                                }
                            } label: {
                                if showPrivateCategory {
                                    Text("✓ \(personal) 👀")
                                } else {
                                    Text("\(personal) 👀")
                                }
                                
                            }
                            
                            // Leisure filter
                            Button {
                                showLeisureCategory.toggle()
                                if showHomeCategory || showWorkCategory || showPrivateCategory  {
                                    showHomeCategory = false
                                    showWorkCategory = false
                                    showPrivateCategory = false
                                }
                            } label: {
                                if showLeisureCategory {
                                    Text("✓ \(hobbies) 🏖️")
                                } else {
                                    Text("\(hobbies) 🏖️")
                                }
                                
                            }
                        } label: {
                            Image(systemName: "line.horizontal.3.decrease.circle.fill")
                                .foregroundColor(Color("gold"))
                                .padding()
                        }
                    }
                }
            }
            Spacer()
            // MARK: Add task view btn
            Button {
                isAddTaskPresented.toggle()
            } label: {
                Image(systemName: "plus.circle")
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                    .foregroundColor(Color("gold"))
                    .accessibility(identifier: "open Add ToDo")
            }
            .sheet(isPresented: $isAddTaskPresented) {
                AddTaskView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
