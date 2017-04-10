//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Krishna Alex on 4/6/17.
//  Copyright © 2017 Krishna Alex. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FiltersTableViewControllerDelegate {
    
    @IBOutlet weak var businessTableView: UITableView!
    private var _prototypeCell: BusinessTableViewCell?
    
    private var prototypeCell: BusinessTableViewCell {
        if (!(self._prototypeCell != nil)) {
            self._prototypeCell = self.businessTableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell") as? BusinessTableViewCell
        }
        return self._prototypeCell!
    }
    
    var businesses: [Business] = []
    var paginationTotal: Int = 0
    let paginationThreshold = 5 // items before next page is fetched.
    var searchActive : Bool = false
    var filters: [String: AnyObject] = [:]
    var isFetching: Bool = false
    var searchText: String = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessTableView.dataSource = self
        businessTableView.delegate = self
        
        //Automatically set the cell height
        businessTableView.estimatedRowHeight = 200
        businessTableView.rowHeight = UITableViewAutomaticDimension
        
        createSearchBar()
        
        //Set Navigation bar color
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.74, green: 0.11, blue: 0.00, alpha: 1.0)
        navigationController?.navigationBar.barStyle = UIBarStyle.black


        fetchNextPage(offset: 0)
    }
    
    func createSearchBar() {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Restaurants"
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ businessTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.businesses.count
    }
    
    func tableView(_ businessTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BusinessTableViewCell = businessTableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell") as! BusinessTableViewCell
        let resultBusiness:Business
        
        resultBusiness = self.businesses[indexPath.row]        
        cell.businessItem = resultBusiness
        
        //Customize the highlight and selection effect of the cell
       /* let view = UIView()
        view.backgroundColor = UIColor.init(red: 0.09, green: 0.57, blue: 0.78, alpha: 1.0)
        cell.selectedBackgroundView = view*/
        
        return cell
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchActive = (searchText.characters.count > 0)
        self.searchText = searchText
        self.fetchNextPage(offset: 0)
        self.businessTableView.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("remaining rows", indexPath.row, self.businesses.count, self.paginationTotal)
        if (self.businesses.count - indexPath.row < paginationThreshold && self.businesses.count < self.paginationTotal) {
            self.fetchNextPage(offset: self.businesses.count)
        }
    }
    
    func fetchNextPage(offset: Int) {
        if (isFetching) {
            return;
        }
        
        if (offset == 0) {
            self.businesses.removeAll()
            self.businessTableView.reloadData()
        }
        
        if (self.searchActive) {
            self.isFetching = true
            Business.searchWithTerm(term: self.searchText.lowercased() as String, offset: self.businesses.count, completion: { (total: Int?, businesses: [Business]?, error: Error?) -> Void in
                
                self.isFetching = false
                self.paginationTotal = total!
                
                if (offset == 0) {
                    self.businesses = businesses!
                }
                else {
                    self.businesses.append(contentsOf: businesses!)
                }
                
                self.businessTableView.reloadData()
            })
        }
        else if (filters.count > 0) {
            print("Fetching ", offset, "for a filtered view", filters)
            let categories = filters["categories"] as! [String]?
            let deal = filters["deals"] as! Bool?
            let distance = Int(filters["distancePreference"] as! String)
            let sortPref = Int(filters["sortPreference"] as! String)
            isFetching = true
            Business.searchWithTerm(term: "Restaurants", sort: sortPref, categories: categories, deals: deal, radius: distance, offset: self.businesses.count, completion: {(total: Int?, businesses: [Business]?, error: Error? ) -> Void in
                
                self.isFetching = false
                self.paginationTotal = total!
                
                if (offset == 0) {
                    self.businesses = businesses!
                }
                else {
                    self.businesses.append(contentsOf: businesses!)
                }
                self.businessTableView.reloadData()
            })
        }
        else {
            print("Fetching ", offset, "for plain view")
            isFetching = true
            Business.searchWithTerm(term: "Restaurants", offset: offset, completion: { (total: Int?, businesses: [Business]?, error: Error?) -> Void in
                    self.isFetching = false
                    self.paginationTotal = total!
                
                    if (offset == 0) {
                        self.businesses = businesses!
                    }
                    else {
                        self.businesses.append(contentsOf: businesses!)
                    }
                
                    self.businessTableView.reloadData()
                }
            )
        }
    }
    
     // MARK: - Navigation
    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! filtersTableTableViewController
        filtersViewController.delegate = self
    }
    
    func filtersTableViewController(filtersTableViewController: filtersTableTableViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        self.filters = filters
        fetchNextPage(offset: 0)
        
    }
    
}
