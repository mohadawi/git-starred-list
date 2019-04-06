//
//  repoStarsUITests.swift
//  repoStarsUITests
//
//  Created by Apple on 4/1/19.
//  Copyright © 2019 matic challenge. All rights reserved.
//

import XCTest
@testable import repoStars

class repoStarsUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK: Repository Class Tests
    
    // Confirm that the Repo initializer returns a Repo object when passed valid parameters.
    
}
