//
//  HTTP_Request_MakerUITestsLaunchTests.swift
//  HTTP Request MakerUITests
//
//  Created by Anton Zyryanov on 16.06.2025.
//

import XCTest

final class HTTP_Request_MakerUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
