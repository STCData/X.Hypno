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

    
    
    func goTo(app:XCUIApplication, goTo: String) {
        let urlField = app.textFields["url"]
        XCTAssert(urlField.exists)
        urlField.tap()
        urlField.typeText(goTo)
        urlField.typeText("\n")
    }
    
    func clickOnTab(app:XCUIApplication, tabName: String) {
        let tab = app.staticTexts[tabName]
        XCTAssert(tab.exists)
        tab.tap()


    }
    
    
    func makeApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        return app
    }
    
    
    
    func testNameSamantha() throws {
        let app = makeApp()
        goTo(app: app, goTo: "some text")
        goTo(app: app, goTo: "http://facebook.com")
        goTo(app: app, goTo: "http://twitter.com")
        goTo(app: app, goTo: "http://twitch.com")
        clickOnTab(app: app, tabName: "http://facebook.com")
        clickOnTab(app: app, tabName: "http://twitter.com")
    }

}
