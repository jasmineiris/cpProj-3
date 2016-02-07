//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,FiltersViewControllerDelegate {
    
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    var searchBar: UISearchBar!
    

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
        

        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
                
            }
        })

     }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(filteredBusinesses == nil) {
            filteredBusinesses = businesses
        }
        if searchText.isEmpty {
            businesses = filteredBusinesses
        } else {
            businesses = businesses.filter({(dataItem: Business) -> Bool in
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if  businesses != nil {
            return businesses!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        
            return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            let navigationController = segue.destinationViewController as? UINavigationController
            let filtersViewController = navigationController!.topViewController as! FiltersViewController
            filtersViewController.delegate = self
    }
        
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        let categories = filters["categories"] as? [String]
        
         //selectedCategories = categories
        
        self.filteredBusinesses = []
        Business.searchWithTerm("Restaurants", sort: nil, categories: categories,deals: nil) {
            (businesses: [Business]!, error: NSError!) -> Void in
            self.filteredBusinesses = businesses
            self.businesses = businesses 
            self.tableView.reloadData()

        }
    }
}

//extension BusinessesViewController: UISearchResultsUpdating {func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
 //   searchBar.setShowsCancelButton(true, animated: true)
    
   // filteredBusinesses = searchText.isEmpty ? businesses : businesses.filter({
     //   $0.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
    //})
    //tableView.reloadData()
    //}
//}