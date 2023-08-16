//
//  ToDoListUITests.swift
//  ToDoListUITests
//
//  Created by Julie Collazos on 23/01/2023.
//

import XCTest

final class ToDoListUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testAAddingToDo() {
        let app = XCUIApplication()
        app.launch()
        
        // 0 - Check if list exist and nb of row inside before adding one element
        let list = app.collectionViews.element
        XCTAssertTrue(list.exists)
        let initialListRows = list.cells.count
        print("Nb ligne initiales: \(initialListRows)")
        
        // 1 - tap on button to open Add toDo sheet
        app.buttons["open Add ToDo"].tap()
        
        // 2 - Test 1st UI element: Title Textfield
        let enterToDoTitle = app.textFields.element
        XCTAssert(enterToDoTitle.exists)
        XCTAssertEqual(enterToDoTitle.placeholderValue, "Title")
        enterToDoTitle.tap()
        enterToDoTitle.typeText("Test")
        
        // 3 - Test 2nd & 3rd UI element: Date & Time Pickers
        let datePicker = app.datePickers["Date"]
        XCTAssert(datePicker.exists)
        let timePicker = app.datePickers["Time"]
        XCTAssert(timePicker.exists)
        
        // 4 - Test 4th UI element: Priority Picker
        let priorityPicker = app.buttons["Priority"]
        XCTAssert(priorityPicker.exists)
        let prioritySelection = app.collectionViews.staticTexts["None"]
        prioritySelection.tap()
        prioritySelection.tap()
        
        // 5 - Test 5th UI element: Description TextView
        let enterToDoContent = app.textViews.element
        XCTAssert(enterToDoContent.exists)
        XCTAssertEqual(enterToDoContent.placeholderValue, "")
        enterToDoContent.tap()
        enterToDoContent.typeText("Test content")
        
        // 6 - Test 6th UI element: Category Picker
        let catPicker = app.segmentedControls.element
        XCTAssert(catPicker.exists)
        XCTAssert(catPicker.buttons["Home"].isSelected)
        catPicker.buttons["Work"].tap()
        XCTAssert(catPicker.buttons["Work"].isSelected)
        
        // 7 - Test 7th UI element: Add button
        let addBtn = app.buttons["Create"]
        XCTAssertTrue(addBtn.exists)
        addBtn.tap()
        sleep(3)
        
        // 8 - Test adding new todo in list
        let finalListRows = list.cells.count
        XCTAssertTrue(list.exists)
        print("Nb ligne finales: \(finalListRows)")
        XCTAssert((initialListRows + 2) == finalListRows)
    }
    
    func testBEditingToDo() {
        let app = XCUIApplication()
        app.launch()
        
        // 0 - Check if list exist and nb of row inside before adding one element
        let list = app.collectionViews.element
        XCTAssertTrue(list.exists)
        let initialListRows = list.cells.count
        print("Nb ligne initiales: \(initialListRows)")
        
        // 1 - tap on a toDo to open edit screen
        list.cells.allElementsBoundByIndex[4].tap()
        
        // 2 - Test 1st UI element: Title Textfield
        let enterToDoTitle = app.textFields.element
        XCTAssert(enterToDoTitle.exists)
        XCTAssertEqual(enterToDoTitle.placeholderValue, "Title")
        enterToDoTitle.tap()
        enterToDoTitle.typeText(" Title edit")
        
        // 3 - Test 2nd & 3rd UI element: Date & Time Pickers
        let datePicker = app.datePickers["Date"]
        XCTAssert(datePicker.exists)
        let timePicker = app.datePickers["Time"]
        XCTAssert(timePicker.exists)
        
        // 4 - Test 4th UI element: Priority Picker
        let priorityPicker = app.buttons["Priority"]
        XCTAssert(priorityPicker.exists)
        let prioritySelection = app.collectionViews.staticTexts["None"]
        prioritySelection.tap()
        prioritySelection.tap()
        
        // 5 - Test 5th UI element: Description TextView
        let enterToDoContent = app.textViews.element
        XCTAssert(enterToDoContent.exists)
        XCTAssertEqual(enterToDoContent.placeholderValue, "")
        enterToDoContent.tap()
        enterToDoContent.typeText(" edited")
        
        // 6 - Test 6th UI element: Category Picker
        let catPicker = app.segmentedControls.element
        XCTAssert(catPicker.exists)
        XCTAssert(catPicker.buttons["Work"].isSelected)
        catPicker.buttons["Private"].tap()
        XCTAssert(catPicker.buttons["Private"].isSelected)
        
        // 7 - Test 7th UI element: Add button
        let addBtn = app.buttons["Edit"]
        XCTAssertTrue(addBtn.exists)
        addBtn.tap()
        sleep(3)
        
        // 8 - Test same number of row List
        let finalListRows = list.cells.count
        XCTAssertTrue(list.exists)
        print("Nb ligne finales: \(finalListRows)")
        XCTAssert((initialListRows) == finalListRows)
    }
    
    
    func testCDeleteToDoContentViewList() {
        let app = XCUIApplication()
        app.launch()
        
        // 0 - Check if list exist and nb of row inside before adding one element
        let list = app.collectionViews.element
        XCTAssertTrue(list.exists)
        let initialListRows = list.cells.count
        print("Nb ligne initiales: \(initialListRows)")
        
        // 1 - tap on a toDo to open edit screen
        list.cells.allElementsBoundByIndex[5].buttons["Delete ToDo"].tap()
        
        sleep(3)
        
        // 2 - Test deleting todo in list
        let finalListRows = list.cells.count
        XCTAssertTrue(list.exists)
        print("Nb ligne finales: \(finalListRows)")
        XCTAssert((initialListRows - 2) == finalListRows)
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
