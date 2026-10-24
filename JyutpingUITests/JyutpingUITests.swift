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
        func testTypeLyricsInInputTest() throws {
                let app = XCUIApplication()
                app.launch()

                let inputTestLink = app.buttons["InputTestLink"].firstMatch
                for _ in 0..<6 where !inputTestLink.exists {
                        app.swipeUp()
                }
                XCTAssertTrue(inputTestLink.waitForExistence(timeout: 12), "Input Test link not found")
                inputTestLink.tap()

                let inputField = app.textFields["InputTextField"]
                XCTAssertTrue(inputField.waitForExistence(timeout: 12), "Input text field not found")
                inputField.tap()

                let singleLineText = UITestLyrics.jayChou.replacingOccurrences(of: "\n", with: " ")
                inputField.typeText(singleLineText)

                let attachment = XCTAttachment(screenshot: app.screenshot())
                attachment.name = "LyricsInputTest"
                attachment.lifetime = .keepAlways
                add(attachment)
        }

        @MainActor
        func testTypeShuangpinLyricsInInputTest() throws {
                let messages = XCUIApplication(bundleIdentifier: "com.apple.MobileSMS")
                messages.launch()

                for buttonName in ["Not Now", "Cancel"] {
                        let button = messages.buttons[buttonName]
                        if button.waitForExistence(timeout: 2) {
                                button.tap()
                        }
                }

                var inputField = messages.searchFields.firstMatch
                if !inputField.waitForExistence(timeout: 5) {
                        inputField = messages.textFields.firstMatch
                }
                XCTAssertTrue(inputField.waitForExistence(timeout: 15), "Messages input field not found")
                inputField.tap()

                let nextKeyboard = messages.buttons["Next keyboard"]
                for _ in 0..<6 where nextKeyboard.exists {
                        nextKeyboard.tap()
                        Thread.sleep(forTimeInterval: 0.3)
                }

                let inputCode = UITestLyrics.shuangpinInput.replacingOccurrences(of: ";", with: "'")
                inputField.typeText(inputCode)
                Thread.sleep(forTimeInterval: 3.0)

                let attachment = XCTAttachment(screenshot: messages.screenshot())
                attachment.name = "MessagesShuangpinLyrics"
                attachment.lifetime = .keepAlways
                add(attachment)
        }

}
