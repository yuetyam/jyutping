//
//  JyutpingUITests.swift
//  JyutpingUITests
//
//  Created by Bing ZHEUNG on 2025-10-16 08:45.
//

import XCTest

final class JyutpingUITests: XCTestCase {

        override func setUpWithError() throws {
                // Put setup code here. This method is called before the invocation of each test method in the class.

                // In UI tests it is usually best to stop immediately when a failure occurs.
                continueAfterFailure = false

                // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        }

        override func tearDownWithError() throws {
                // Put teardown code here. This method is called after the invocation of each test method in the class.
        }

        @MainActor
        func testExample() throws {
                // UI tests must launch the application that they test.
                let app = XCUIApplication()
                app.launch()

                // Use XCTAssert and related functions to verify your tests produce the correct results.
        }

        @MainActor
        func testLaunchPerformance() throws {
                // This measures how long it takes to launch your application.
                measure(metrics: [XCTApplicationLaunchMetric()]) {
                        XCUIApplication().launch()
                }
        }

        @MainActor
        func testEnableJyutpingKeyboardAndFullAccess() throws {
                let settings = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
                settings.launchArguments = ["-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
                settings.launch()

                let general = settings.cells.staticTexts["General"]
                XCTAssertTrue(general.waitForExistence(timeout: 8), "General row not found")
                general.tap()

                let keyboard = settings.cells.staticTexts["Keyboard"]
                XCTAssertTrue(keyboard.waitForExistence(timeout: 8), "Keyboard row not found")
                keyboard.tap()

                let keyboards = settings.cells.staticTexts["Keyboards"]
                XCTAssertTrue(keyboards.waitForExistence(timeout: 8), "Keyboards row not found")
                keyboards.tap()

                let addNewKeyboard = settings.cells.staticTexts["Add New Keyboard…"]
                if addNewKeyboard.waitForExistence(timeout: 4) {
                        addNewKeyboard.tap()
                        let jyutpingToAdd = settings.cells.staticTexts["Jyutping"]
                        if jyutpingToAdd.waitForExistence(timeout: 8) {
                                jyutpingToAdd.tap()
                        } else {
                                settings.navigationBars.buttons.element(boundBy: 0).tap()
                        }
                }

                let jyutpingRow = settings.cells.staticTexts["Jyutping"]
                XCTAssertTrue(jyutpingRow.waitForExistence(timeout: 8), "Jyutping row not found after enabling")
                jyutpingRow.tap()

                let allowFullAccess = settings.switches["Allow Full Access"]
                XCTAssertTrue(allowFullAccess.waitForExistence(timeout: 8), "Allow Full Access switch not found")
                let value: String? = allowFullAccess.value as? String
                if value == "0" || value == "false" {
                        allowFullAccess.tap()
                }

                let attachment = XCTAttachment(screenshot: settings.screenshot())
                attachment.name = "Keyboard-Settings"
                attachment.lifetime = .keepAlways
                add(attachment)
        }
}
