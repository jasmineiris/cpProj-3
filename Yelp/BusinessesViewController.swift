//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,FiltersViewControllerDelegate, UIScrollViewDelegate {
    
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    var searchBar: UISearchBar!
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    var selectedCategories: [String]?
    var loadMoreOffset = 20
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width,
            InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        

        Business.searchWithTerm("Restaurants", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredBusinesses = businesses
            self.tableView.reloadData()
            
           // for business in businesses {
             //   print(business.name!)
               // print(business.address!)
                
            //}
        })

     }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        /*if(filteredBusinesses == nil) {
            filteredBusinesses = businesses
        }*/
        if searchText.isEmpty {
            filteredBusinesses = businesses
        } else {
            filteredBusinesses = businesses.filter({(dataItem: Business) -> Bool in
                if dataItem.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
        
            })
            
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //table view function that runs when an item is selected
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        searchBar.endEditing(true)
        print("item selected")
        print(indexPath.row)
        performSegueWithIdentifier("BizToDetailView", sender: filteredBusinesses[indexPath.row])
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if  filteredBusinesses != nil {
            return filteredBusinesses!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = filteredBusinesses[indexPath.row]
        
            return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (!isMoreDataLoading) {
            
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        Business.searchWithTerm("Restaurants", offset: loadMoreOffset, sort: nil, categories: [], deals: false,  completion: { (businesses: [Business]!, error: NSError!) -> Void in
            
            if error != nil {
                self.delay(2.0, closure: {
                    self.loadingMoreView?.stopAnimating()
                    //TODO: show network error
                })
            } else {
                self.delay(0.5, closure: { Void in
                    self.loadMoreOffset += 20
                    self.filteredBusinesses.appendContentsOf(businesses)
                    self.tableView.reloadData()
                    self.loadingMoreView?.stopAnimating()
                    self.isMoreDataLoading = false
                })
                self.businesses = businesses
                self.filteredBusinesses = businesses
                self.tableView.reloadData()
                
            }
        })
    }
    
    func delay(delay: Double, closure: () -> () ) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure
        )
    }
    
    func setupInfiniteScrollView() {
        let frame = CGRectMake(0, tableView.contentSize.height,
            tableView.bounds.size.width,
            InfiniteScrollActivityView.defaultHeight
        )
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview( loadingMoreView! )
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        }
    
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "BizToFilters" {
            let navigationController = segue.destinationViewController as? UINavigationController
            let filtersViewController = navigationController!.topViewController as! FiltersViewController
            filtersViewController.delegate = self
        } else if (segue.identifier == "BizToMaps") {
            let navigationController = segue.destinationViewController as? UINavigationController
            let mapViewController = navigationController!.topViewController as! MapViewController
            print("Segue to maps")
            
        } else if (segue.identifier == "BizToDetailView") {
            if let sender = sender as? Business {
                let detailsViewController = segue.destinationViewController as! DetailsViewController
                detailsViewController.business = sender
            }
        }
    }

    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        let categories = filters["categories"] as? [String]
        
        selectedCategories = categories
        
        self.filteredBusinesses = []
        Business.searchWithTerm("Restaurants", sort: nil, categories: categories,deals: nil) {
            (businesses: [Business]!, error: NSError!) -> Void in
            self.filteredBusinesses = businesses
            self.tableView.reloadData()

        }
    }
}



