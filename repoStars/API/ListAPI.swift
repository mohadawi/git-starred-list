/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import UIKit

final class LibraryAPI {
    // 1
    static let shared = LibraryAPI()
    private let httpClient = HTTPClient()
    private let isOnline = false
    // 2
    
    func getRepos(completion: @escaping ([Repository]) -> Void){
        httpClient.getRepos(completion:{(error) in
            if(error == nil){
                completion(self.getRepos2())
            }
        })
    }
    
    func getRepos2() -> [Repository]{
        return httpClient.repos
    }
    
    /*
    @objc func downloadImage(with notification: Notification) {
        guard let userInfo = notification.userInfo,
            let imageView = userInfo["imageView"] as? UIImageView,
            let coverUrl = userInfo["coverUrl"] as? String,
            let filename = URL(string: coverUrl)?.lastPathComponent else {
                return
        }
        
        if let savedImage = httpClient.getImage(with: filename) {
            imageView.image = savedImage
            return
        }
        
        DispatchQueue.global().async {
            let downloadedImage = self.httpClient.downloadImage(coverUrl) ?? UIImage()
            DispatchQueue.main.async {
                imageView.image = downloadedImage
                self.httpClient.saveImage(downloadedImage, filename: filename)
            }
        }
    }*/
}
