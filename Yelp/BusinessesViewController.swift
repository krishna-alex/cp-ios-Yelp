//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Krishna Alex on 4/6/17.
//  Copyright © 2017 Krishna Alex. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, FiltersTableViewControllerDelegate {
    
    @IBOutlet weak var businessTableView: UITableView!
    //@IBOutlet weak var searchBar: UISearchBar!
    
    private var _prototypeCell: BusinessTableViewCell?
    
    private var prototypeCell: BusinessTableViewCell {
        if (!(self._prototypeCell != nil)) {
            self._prototypeCell = self.businessTableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell") as? BusinessTableViewCell
        }
        return self._prototypeCell!
    }
    

  //  @IBOutlet weak var searchBar: UISearchBar!
    
    var businesses: [Business] = []
    var searchActive : Bool = false
  //  var businessesDict: [Business]!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessTableView.dataSource = self

        businessTableView.estimatedRowHeight = 200
        businessTableView.rowHeight = UITableViewAutomaticDimension
        
        createSearchBar()
        
        //Set Navigation bar color
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.74, green: 0.11, blue: 0.00, alpha: 1.0)
        navigationController?.navigationBar.barStyle = UIBarStyle.black


        Business.searchWithTerm(term: "Restaurants", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
          //  print(self.businesses!)
            self.businesses = businesses!
            self.businessTableView.reloadData()
            /* if let resultBusiness = businesses {
                print(resultBusiness)
                for business in resultBusiness {
                    print(business.ratingImageURL)
                    print(business.imageURL)
                    print(business.name!)
                    print(business.address!)
                    print(business.reviewCount)
                    print(business.categories)
                    print(business.distance)
                    
                }
               print(resultBusiness[0].address! as String)
                print(resultBusiness[0].name! as String)
            }*/
            
            }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
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
            print("Business Count \(self.businesses.count)")
            return self.businesses.count
    }
    
    func tableView(_ businessTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BusinessTableViewCell = businessTableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell") as! BusinessTableViewCell
        let resultBusiness:Business
        
        resultBusiness = self.businesses[indexPath.row]        
        cell.businessItem = resultBusiness
        print(resultBusiness)
        
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
        if (!searchActive) {
            self.businessTableView.reloadData()
            return;
        }
        
        //Yelp search
        print("SearchText")
        print(searchText.lowercased())
        Business.searchWithTerm(term: searchText.lowercased() as String, completion: { (businesses: [Business]?, error: Error?) -> Void in
         self.businesses = businesses!
         self.businessTableView.reloadData()
        
        })
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
      override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! filtersTableTableViewController
        filtersViewController.delegate = self
        
     } */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! filtersTableTableViewController
        filtersViewController.delegate = self
    }
    
    func filtersTableViewController(filtersTableViewController: filtersTableTableViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        let categories = filters["categories"] as! [String]?
        print("categories in delegate", categories)
        Business.searchWithTerm(term: "Restaurants", sort: nil, categories: categories, deals: nil, completion: { (businesses: [Business]?, error: Error? ) -> Void in
            self.businesses = businesses!
            self.businessTableView.reloadData()
        })
    }
    
}
