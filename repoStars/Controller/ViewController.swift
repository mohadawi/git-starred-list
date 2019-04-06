//
//  ViewController.swift
//  repoStars
// Mohammad Dawi April 6,2019

import UIKit

class ViewController: UIViewController {
    private let CollectionViewCellPadding: CGFloat = 10
    private let NumberOfCellsPerRow: Int = 1
    var collectionViewCellSize: CGFloat = 0.0
    private var delegate: AppDelegate?
    @IBOutlet var tableView: UITableView!
    
    var imageURLs = [URL]()
    var downloadImageOperationQueue: OperationQueue? = OperationQueue()
    var operations = NSMutableDictionary()
    var images = NSMutableDictionary()
    var repos = [Repository]()
    let httpClient = HTTPClient()
    var stringDate : String = "2017-11-22" // changes automatically
    var totalReposCount:Int = 0
    var currentReposCount:Int = 0
    var baseUrl:String = "https://api.github.com/search/repositories?q=created:>2017-10-22&sort=stars&order=desc" // changes automatically
    var currentPage:Int = 1 // changes automatically
    var pageCount:Int = 30 // changes automatically
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.shared.delegate as? AppDelegate
        //set the initial url for api call
        //set the date to 30 days backwards
        let today = Date()
        let past30Days = Calendar.current.date(byAdding: .day, value: -30, to: today)
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd"
        stringDate = date.string(from: past30Days!)
        baseUrl = "https://api.github.com/search/repositories?q=created:%3E" + stringDate + "&sort=stars&order=desc"
        //let url:String = "https://api.github.com/search/repositories?q=created:%3E" + stringDate + "&sort=stars&order=desc&page=2"
        getReposPerPage(pageNum: currentPage)
        
    }
    
    // get the list of repositories per page
    func getReposPerPage(pageNum : Int){
        var url:String
        if (pageNum<2){
             url = baseUrl
        }
        else{
            url = baseUrl + "&page=" + "\(pageNum)"
        }
        LibraryAPI.shared.getRepos(url:url,completion:{(myRepos)  in
            if(myRepos != nil){
                self.totalReposCount = LibraryAPI.shared.getReposTotalCount()
                self.repos.append(contentsOf: myRepos)
                self.currentReposCount = self.repos.count
                self.pageCount=myRepos.count
                self.populateModels2(myRepos.count)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    // MARK: Fill the avatars urls
    func populateModels2(_ count: Int) {
        //downloadImageOperationQueue = OperationQueue()
        var urlStr: String
        //Simulating initial load of content
        for counter in (repos.count-count)..<(repos.count) {
            //Simulating slow download using large images
            urlStr = repos[counter].thumbnailUrl// mutableArrayThumbnails[counter] as! String
            //add extension if needed
            //urlStr = urlStr + (".")
            //urlStr = urlStr + (mutableArrayThumbnailsExt[counter] as! String)
            let imageStringAdress = urlStr
            let imageURL = URL(string: imageStringAdress)
            if let imageURL = imageURL {
                imageURLs.append(imageURL)
            }
            else{
                imageURLs.append(URL(string: "https://avatars1.githubusercontent.com/u/1961952?v=4")!)
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
    
    // Do some configuration to the view
    func configureCollectionView() {
        let screenWidth = view.frame.width
        let cellsAreaOnSingleRow: CGFloat = screenWidth - ((CGFloat(NumberOfCellsPerRow) + 1) * CollectionViewCellPadding)
        collectionViewCellSize = cellsAreaOnSingleRow / CGFloat(NumberOfCellsPerRow)
        tableView.contentInset = UIEdgeInsets(top: CollectionViewCellPadding, left: CollectionViewCellPadding, bottom: CollectionViewCellPadding, right: CollectionViewCellPadding)
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
            let imageURL: URL? = imageURLs[indexPath.row]
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
            let imageURL: URL? = imageURLs[indexPath.row]
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
        cell.repoTitleLabel.text = repos[indexPath.row].name
        cell.repoOwnerLabel.text = repos[indexPath.row].ownerName
        cell.repoDescrpLabel.text = repos[indexPath.row].description
        let count = repos[indexPath.row].starCount
        let doubleCount = (count as NSString).doubleValue
        cell.starsCount.text = doubleCount.kmFormatted
        let imageURL: URL? = imageURLs[indexPath.row]
        if let imageURL = imageURL {
            if (images[imageURL] != nil) {
                cell.avatar?.image = images[imageURL] as! UIImage
                cell.activityIndicator.stopAnimating()
            } else {
                executeDownloadImageOperationBlock(for: indexPath)
            }
        }
        if (indexPath.row == self.imageURLs.count - 1) { // last cell
            currentPage += 1
            if (currentReposCount  < totalReposCount) { // more items to fetch
                getReposPerPage(pageNum: currentPage)
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

