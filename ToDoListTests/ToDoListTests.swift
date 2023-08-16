//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Julie Collazos on 01/03/2023.
//

import XCTest
import CoreData
import SwiftUI
@testable import ToDoList

final class ToDoListTests: XCTestCase {
    @ObservedObject var vm = TaskViewModel()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddTask() throws {
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        let title = "Test 1"
        let category = Category.hobbies
        let priority = Priority.low
        let date = Date.now
        let content = "Test description 1"
        let taskColor = "lavender"
        let textColor = "black"
        
        let task = vm.addTask(title: title, category: category, priority: priority, date: date, content: content, taskColor: taskColor, textColor: textColor, vc: viewContext)
        
        XCTAssertEqual(task.title, title)
        XCTAssertEqual(task.category, category.rawValue)
        XCTAssertEqual(task.priority, priority.priorityIcon)
        XCTAssertEqual(task.dueDate, date)
        XCTAssertEqual(task.content, content)
        XCTAssertEqual(task.taskColor, taskColor)
        XCTAssertEqual(task.textColor, textColor)
    }
    
    func testDoneTask() throws {
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        let title = "Test 1"
        let category = Category.work
        let priority = Priority.average
        let date = Date.now
        let content = "Test description 1"
        let taskColor = "navy"
        let textColor = "white"
        
        let task = vm.addTask(title: title, category: category, priority: priority, date: date, content: content, taskColor: taskColor, textColor: textColor, vc: viewContext)
        XCTAssertEqual(task.title, title)
        XCTAssertEqual(task.category, category.rawValue)
        XCTAssertEqual(task.priority, priority.priorityIcon)
        XCTAssertEqual(task.dueDate, date)
        XCTAssertEqual(task.content, content)
        XCTAssertEqual(task.taskColor, taskColor)
        XCTAssertEqual(task.textColor, textColor)
        
        vm.doneTask(task: task, vc: viewContext)
        XCTAssertEqual(task.isDone, true)
    }
    
    func testEditTask() throws {
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        let title = "Test 1"
        let category = Category.work
        let priority = Priority.average
        let date = Date.now
        let content = "Test description 1"
        let taskColor = "navy"
        let textColor = "white"
        
        let task = vm.addTask(title: title, category: category, priority: priority, date: date, content: content, taskColor: taskColor, textColor: textColor, vc: viewContext)
        XCTAssertEqual(task.title, title)
        XCTAssertEqual(task.category, category.rawValue)
        XCTAssertEqual(task.priority, priority.priorityIcon)
        XCTAssertEqual(task.dueDate, date)
        XCTAssertEqual(task.content, content)
        XCTAssertEqual(task.taskColor, taskColor)
        XCTAssertEqual(task.textColor, textColor)
        
        vm.editTask(task: task, title: "edit title", category: .home, priority: .high, date: date, content: "description modifiée", taskColor: "oxblood", textColor: "white", vc: viewContext)
        
        XCTAssertEqual(task.title, "edit title")
        XCTAssertEqual(task.category, "Home")
        XCTAssertEqual(task.priority, "exclamationmark.3")
        XCTAssertEqual(task.content, "description modifiée")
        XCTAssertEqual(task.taskColor, "oxblood")
        XCTAssertEqual(task.textColor, "white")
    }
    
    func testDeleteTask() throws {
        let viewContext = PersistenceController(inMemory: true).container.viewContext
        let task1 = vm.addTask(title: "Test delete", category: Category.personal, priority: Priority.none, date: Date.now, content: "Description de la tâche à supprimer", taskColor: "teal", textColor: "black", vc: viewContext)
        
        vm.delete(task: task1, vc: viewContext)
        
        XCTAssertNotEqual(task1.title, "Test delete")
        XCTAssertNotEqual(task1.content, "Description de la tâche à supprimer")

    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
