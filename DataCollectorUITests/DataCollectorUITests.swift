//
//  DataCollectorUITests.swift
//  DataCollectorUITests
//
//  Created by standard on 3/1/23.
//

import XCTest

final class DataCollectorUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func checkElements(app:XCUIApplication) {
        let okButton = app.buttons["OK"]
        XCTAssert(okButton.exists)
        let nameField = app.textFields["name"]
        XCTAssert(nameField.exists)
        let helloText = app.staticTexts["Hello, Anonymous"]
        XCTAssert(helloText.exists)

    }
    
    func checkName(app:XCUIApplication, name: String) {
        let nameField = app.textFields["name"]
        XCTAssert(nameField.exists)
        nameField.tap()
        nameField.typeText(name)
        let okButton = app.buttons["OK"]
        XCTAssert(okButton.exists)
        okButton.tap()
        let helloText = app.staticTexts["Hello, \(name)"]
        XCTAssert(helloText.exists)
    }
    
    func makeApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        return app
    }
    
    func testNameJohn() throws {
        let app = makeApp()
        checkElements(app: app)
        checkName(app: app, name: "John")
    }
    
    func testNameSamantha() throws {
        let app = makeApp()
        checkElements(app: app)
        checkName(app: app, name: "Samantha")
    }

}
