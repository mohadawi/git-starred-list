//
//  Repository.swift
//  repoStars
//
//  Created by Apple on 4/4/19.
//  Copyright © 2019 matic challenge. All rights reserved.
//

import Foundation
import UIKit
class Repository {
    
    //MARK: Properties
    
    var repoId: String
    var name: String
    var description: String
    var ownerName: String
    var thumbnailUrl: String
    var starCount: String
    var wiki: String
    
    
    //MARK: Initialization
    
    init?(repoId: String, name: String, description: String, ownerName: String, thumbnailUrl: String, starCount: String, wiki: String) {
        
        // The repo ID must not be empty
        guard !repoId.isEmpty else {
            return nil
        }
        // The repo name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        // The repo login must not be empty
        guard !ownerName.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.repoId = repoId
        self.name = name
        self.description = description
        self.ownerName = ownerName
        self.thumbnailUrl = thumbnailUrl
        self.starCount = starCount
        self.wiki = wiki
        
    }
}
