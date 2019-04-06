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
    //holds the rpeos list--consider moving it up level in listAPI class
    var repos = [Repository]()
    var totalCount:Int = 0
    
    init() {
        
    }
    //get the list of repos (request returns 30 results per page)
    func getRequestAPICall(_ apiUurl: String?,completion: @escaping (Error?) -> Void)
     {
        repos.removeAll()
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest()
        request.httpMethod = "GET"
        request.url = URL(string: apiUurl!)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if error != nil {
                completion (error)
                return
            }
            var object: Any? = nil
            if let data = data {
                object = try? JSONSerialization.jsonObject(with: data, options: [])
            }
            if let object1 = object as? NSDictionary{
                //get the total count
                if let total = object1.value(forKey: "total_count") as? NSNumber{
                    self.totalCount = total.intValue
                }
                if let characters = object1["items"] as? NSArray{
                    for (obj) in characters {
                    //loop on the results per page
                        if let character = obj as? NSDictionary {
                            //get the repo id, name, owner's name
                            let tId = "\(character.value(forKey: "id") ?? "")"
                            let name = character.value(forKey: "name") as! String
                            var login = ""
                            if let owner=character["owner"]as? NSDictionary {
                                login = owner.value(forKey: "login") as! String
                            }
                            //for testing purpose
                            /*
                            if (login == "996icu"){
                                login = ""
                            }
                            */
                            //create a new repository with fetched id, name and owner's name
                            guard let repo = Repository(repoId: tId, name: name, description: "", ownerName: login, thumbnailUrl: "", starCount: "", wiki: "") else {
                                print("Unable to instantiate contact1")
                                continue
                            }
                            
                            //fill description if any
                            if let description = character.value(forKey: "description") as? String
                            {
                                repo.description = description
                            }
                            else
                            {
                                repo.description = ""
                            }
                            //read the stars count as NSNumber then cast it to string
                            if let stars = character.value(forKey: "stargazers_count") as? NSNumber{
                                repo.starCount = stars.stringValue
                            }
                            //get the owner's avatar thumb
                            if let thumb=character["owner"]as? NSDictionary {
                                repo.thumbnailUrl = thumb.value(forKey: "avatar_url") as! String
                            }
                            repo.wiki = character["html_url"] as! String
                            //add the created repository to the repositories array
                            self.repos.append(repo)
                        }
                    }
                }
            }
            completion (error)
        })
        task.resume()
    }
    
    func getRepos(url:String?,completion: @escaping (Error?) -> Void) {
        getRequestAPICall(url,completion:{(error) in
            completion(error)
            if(error == nil){
                // do something if needed
            }
        })
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
