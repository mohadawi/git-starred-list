//
//  repoStarsTests.swift
//  repoStarsTests
//
//  Created by Apple on 4/1/19.
//  Copyright © 2019 matic challenge. All rights reserved.
//
// Mohammad Dawi April 6,2019
import XCTest
@testable import repoStars

class repoStarsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRepositoryInitializationSucceeds() {
        
        // nil description
        let nullRepoDescription = Repository.init(repoId: "test1", name: "ReMe", description: "", ownerName: "login", thumbnailUrl: "", starCount: "", wiki: "")
        XCTAssertNotNil(nullRepoDescription)
        
    }
    
    // Confirm that the Contact initialier returns nil when passed an empty login or an empty name.
    func testContactInitializationFails() {
        
        // Empty Id
        let nullRepoId = Repository.init(repoId: "", name: "ReMe", description: "", ownerName: "login", thumbnailUrl: "", starCount: "", wiki: "")
        XCTAssertNil(nullRepoId)
        // Empty owner's name
        let nullRepoLogin = Repository.init(repoId: "test2", name: "ReMe", description: "", ownerName: "", thumbnailUrl: "", starCount: "", wiki: "")
        XCTAssertNil(nullRepoLogin)
        // Empty name
        let nullRepoName = Repository.init(repoId: "test2", name: "", description: "", ownerName: "login", thumbnailUrl: "", starCount: "", wiki: "")
        XCTAssertNil(nullRepoName)
        
    }


}
