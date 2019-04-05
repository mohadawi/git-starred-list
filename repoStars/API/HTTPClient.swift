//
//  HTTPClient.swift
//  repoStars
//
//  Created by Apple on 4/5/19.
//  Copyright © 2019 matic challenge. All rights reserved.
//

import Foundation
import UIKit

class HTTPClient {
    var repos = [Repository]()
    
    func getRequestAPICall(_ apikey: String?, hash: String?, ts: String?,completion: @escaping (Error?) -> Void)
     {
        let todosEndpoint = "https://api.github.com/search/repositories?q=created:%3E2019-01-01&sort=stars&order=desc"
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request = NSMutableURLRequest()
        request.httpMethod = "GET"
        request.url = URL(string: todosEndpoint)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if error != nil {
                completion (error)
                return
            }
            var object: Any? = nil
            if let data = data {
                object = try? JSONSerialization.jsonObject(with: data, options: [])
            }
            var count: Int = 30
            var wiki: NSString
            if let object1 = object as? NSDictionary{
                if let characters = object1["items"] as? NSArray{
                    //for (obj) in characters {
                    //loop on the results per page response(request returns 30 repositories)
                    for i in 0..<count {
                        let obj = characters[i]
                        if let character = obj as? NSDictionary {
                            let tId = "\(character.value(forKey: "id"))"
                            //create a new repository with fetched id
                            guard let repo = Repository(repoId: tId, name: "", description: "", ownerName: "", thumbnailUrl: "", starCount: "", wiki: "") else {
                                fatalError("Unable to instantiate contact1")
                            }
                            repo.name = character.value(forKey: "name") as! String
                            repo.description = character.value(forKey: "description") as! String
                            //read the stars count as NSNumber then cast it to string
                            if let stars = character.value(forKey: "stargazers_count") as? NSNumber{
                                repo.starCount = stars.stringValue
                            }
                            if let thumb=character["owner"]as? NSDictionary {
                                repo.thumbnailUrl = thumb.value(forKey: "avatar_url") as! String
                                repo.ownerName = thumb.value(forKey: "login") as! String
                            }
                            wiki = character["html_url"] as! NSString
                            repo.wiki = character["html_url"] as! String
                            //add the created repository to the repositories array
                            self.repos.append(repo)
                        }
                    }
                }
            }
            completion (error)
            /*
            self.populateModels2(count)
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })*/
        })
        task.resume()
    }
    
    func downloadImage(_ url: String) -> UIImage? {
        let aUrl = URL(string: url)
        guard let data = try? Data(contentsOf: aUrl!),
            let image = UIImage(data: data) else {
                return nil
        }
        return image
    }
    
}
