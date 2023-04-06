//
//  SearchViewControllerUITests.swift
//  bar-finderUITests
//
//  Created by Bruno Costa on 06/04/23.
//

import XCTest

@testable import bar_finder

class SearchViewControllerUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testSearchButton() throws {
        app.textFields["Qual é a sua localização?"].tap()
        app.textFields["Qual é a sua localização?"].typeText("123 Main St")
        app.textFields["Pizza, cerveja, hamburger..."].tap()
        app.textFields["Pizza, cerveja, hamburger..."].typeText("Pizza")
        app.buttons["Buscar"].tap()
        
        let businessListNavigationBar = app.navigationBars["Pizza em 123 Main St"]
        XCTAssertTrue(businessListNavigationBar.exists)
    }
    
    func testLocationTextField() throws {
        app.textFields["Qual é a sua localização?"].tap()
        app.textFields["Qual é a sua localização?"].typeText("123 Main St")
        XCTAssertTrue(app.textFields["Qual é a sua localização?"].value as! String == "123 Main St")
    }
    
    func testBusinessTypeTextField() throws {
        app.textFields["Pizza, cerveja, hamburger..."].tap()
        app.textFields["Pizza, cerveja, hamburger..."].typeText("Pizza")
        XCTAssertTrue(app.textFields["Pizza, cerveja, hamburger..."].value as! String == "Pizza")
    }
}
