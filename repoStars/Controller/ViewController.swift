//
//  ViewController.swift
//  repoStars
//
//  Created by Apple on 4/1/19.
//  Copyright © 2019 matic challenge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let CollectionViewCellPadding: CGFloat = 10
    private let NumberOfCellsPerRow: Int = 1
    var collectionViewCellSize: CGFloat = 0.0
    private var delegate: AppDelegate?
    @IBOutlet var tableView: UITableView!
    
    var imageURLs: [URL] = []
    var downloadImageOperationQueue: OperationQueue?
    var operations = NSMutableDictionary()// [URL : BlockOperation] = [:]
    var images = NSMutableDictionary()//[URL : UIImage] = [:]
    var webview: UIWebView?
    var repos = [Repository]()
    let httpClient = HTTPClient()
    //var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var backButtonItem = UIBarButtonItem(title: "Previous", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        delegate = UIApplication.shared.delegate as? AppDelegate
        //mutableArrayWikis = NSMutableArray()
        webview = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        //[self.view addSubview:_webview];
        //imageView = UIImageView(frame: CGRect(x: 0, y: 110, width: 100, height: 200))
        //imageView!.contentMode = .center
        //imageView!.contentMode = .scaleAspectFit
        LibraryAPI.shared.getRepos(completion:{(myRepos)  in
            if(myRepos != nil){
                self.repos = myRepos
                self.populateModels2(30)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        })
        
        //getRequestAPICall("f0b5d75500a2db859e1a152376fe2e65", hash: "a2c3fad843830de5e6c631ddbc41a0c9", ts: "2")
        
        configureCollectionView()
        //self.tableView.prefetchDataSource = self;
    }
    
    func getRequestAPICall(_ apikey: String?, hash: String?, ts: String?) {
        //get the date before 30 days
        let today = Date()
        let past30Days = Calendar.current.date(byAdding: .day, value: -30, to: today)
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd"
        let stringDate : String = date.string(from: past30Days!)
        httpClient.getRequestAPICall("https://api.github.com/search/repositories?q=created:%3E" + /*2019-01-01*/stringDate + "&sort=stars&order=desc",completion:{(error)  in
            if(error == nil){
                self.populateModels2(30)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        })
        }
    func populateModels2(_ count: Int) {
        downloadImageOperationQueue = OperationQueue()
        imageURLs = NSMutableArray() as! [URL]
        operations = NSMutableDictionary() //as! [URL : BlockOperation]
        images = NSMutableDictionary() //as! [URL : UIImage]
        var urlStr: String
        //Simulating initial load of content
        for counter in 0..<count {
            //Simulating slow download using large images
            urlStr = repos[counter].thumbnailUrl// mutableArrayThumbnails[counter] as! String
            //urlStr = urlStr + (".")
            //urlStr = urlStr + (mutableArrayThumbnailsExt[counter] as! String)
            let imageStringAdress = urlStr
            let imageURL = URL(string: imageStringAdress)
            if let imageURL = imageURL {
                imageURLs.append(imageURL)
                /*
                let imageData = try? Data(contentsOf: imageURL)
                var image: UIImage? = nil
                if let imageData = imageData {
                    image = UIImage(data: imageData)
                }
                images[imageURL] = image
                 */
            }
        }
    }
    
    // MARK: Utilities
    func executeDownloadImageOperationBlock(for indexPath: IndexPath?) {
        let url: URL? = imageURLs[indexPath?.row ?? 0]
        let blockOperation = BlockOperation()
        weak var weakBlockOperation: BlockOperation? = blockOperation
        weak var weakSelf = self
        blockOperation.addExecutionBlock({
            if (weakBlockOperation?.isCancelled)! {
                if let url = url {
                    weakSelf!.operations[url] = nil
                }
                return
            }
            //NSData *imageData = [NSData dataWithContentsOfURL:url];
            var imageData: Data? = nil
            if let url = url {
                imageData = try? Data(contentsOf: url)
            }
            var image: UIImage? = nil
            if let imageData = imageData {
                image = UIImage(data: imageData)
            }
            if let url = url {
                weakSelf!.images[url] = image
            }
            weakSelf!.operations[url!] = nil
            DispatchQueue.main.async(execute: {
                let visibleCellIndexPaths = weakSelf?.tableView.indexPathsForVisibleRows
                if let indexPath = indexPath {
                    if visibleCellIndexPaths!.contains(indexPath) {
                        let cell = weakSelf?.tableView.cellForRow(at: indexPath) as? MainCollectionViewCell
                        cell?.avatar!.image = image
                        cell?.activityIndicator.stopAnimating()
                    }
                }
            })
        })
        downloadImageOperationQueue?.addOperation(blockOperation)
        operations[url!] = blockOperation
        
    }
    func cancelDowloandImageOperationBlock(for indexPath: IndexPath?) {
        
        let imageURL: URL? = imageURLs[indexPath?.row ?? 0]
        if let imageURL = imageURL {
            if (operations[imageURL] != nil) {
                let blockOperation: BlockOperation? = operations.object(forKey: imageURL) as! BlockOperation
                blockOperation?.cancel()
                operations[imageURL] = nil
            }
        }
    }
    
    func configureCollectionView() {
        let screenWidth = view.frame.width
        let cellsAreaOnSingleRow: CGFloat = screenWidth - ((CGFloat(NumberOfCellsPerRow) + 1) * CollectionViewCellPadding)
        collectionViewCellSize = cellsAreaOnSingleRow / CGFloat(NumberOfCellsPerRow)
        
        tableView.contentInset = UIEdgeInsets(top: CollectionViewCellPadding, left: CollectionViewCellPadding, bottom: CollectionViewCellPadding, right: CollectionViewCellPadding)
        //tableView.prefetchDataSource = self
    }

}


extension Double {
    var kmFormatted: String {
        
        if self >= 1000, self <= 999999 {
            return String(format: "%.1fK", locale: Locale.current,self/1000).replacingOccurrences(of: ".0", with: "")
        }
        if self > 999999 {
            return String(format: "%.1fM", locale: Locale.current,self/1000000).replacingOccurrences(of: ".0", with: "")
        }
        return String(format: "%.0f", locale: Locale.current,self)
    }
}
    

extension ViewController: UITableViewDataSource,UITabBarDelegate{//}, UITableViewDataSourcePrefetching {
    // MARK: <UITableViewDataSourcePrefetching>
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            
            // Updating upcoming CollectionView's data source. Not assiging any direct value
            // as this operation is expensive it is performed on a private queue
            var imageURL: URL? = imageURLs[indexPath.row]
            if let imageURL = imageURL {
                if (images[imageURL] == nil) {
                    executeDownloadImageOperationBlock(for: indexPath)
                    print("Prefetching data for indexPath: \(indexPath)")
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            //Unloading or data load operation cancellations should happend here
            var imageURL: URL? = imageURLs[indexPath.row]
            if let imageURL = imageURL {
                if (operations[imageURL] != nil) {
                    cancelDowloandImageOperationBlock(for: indexPath)
                    print("Unloading data fetch in progress for indexPath: \(indexPath)")
                }
            }
        }

    }
    
    // MARK: <UITableViewDataSource>
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainCollectionViewCell
        cell.repoTitleLabel.text = repos[indexPath.row].name// self.mutableArrayNames[indexPath.row] as! String
        cell.repoOwnerLabel.text = repos[indexPath.row].ownerName// self.mutableArrayOwnerNames[indexPath.row] as! String
        cell.repoDescrpLabel.text = repos[indexPath.row].description//self.mutableArrayDescriptions[indexPath.row] as! String
        
        let count = repos[indexPath.row].starCount
        let doubleCount = (count as NSString).doubleValue
        //let count = Double(self.repos[indexPath.row].starCount.string)// self.mutableArrayStars[indexPath.row] as! Double
        //let count = NumberFormatter().number(from: self.repos[indexPath.row].starCount)?.doubleValue
        cell.starsCount.text = doubleCount.kmFormatted
        var imageURL: URL? = imageURLs[indexPath.row]
        if let imageURL = imageURL {
            if (images[imageURL] != nil) {
                cell.avatar?.image = images[imageURL] as! UIImage
                cell.activityIndicator.stopAnimating()
            } else {
                executeDownloadImageOperationBlock(for: indexPath)
            }
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.imageURLs.count
    }
    
    // MARK: <UITableViewDelegate>
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelDowloandImageOperationBlock(for: indexPath)

    }

}

