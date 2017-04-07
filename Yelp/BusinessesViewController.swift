//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Krishna Alex on 4/6/17.
//  Copyright © 2017 Krishna Alex. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var businessTableView: UITableView!
    
    private var _prototypeCell: BusinessTableViewCell?
    
    private var prototypeCell: BusinessTableViewCell {
        if (!(self._prototypeCell != nil)) {
            self._prototypeCell = self.businessTableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell") as? BusinessTableViewCell
        }
        return self._prototypeCell!
    }
    

  //  @IBOutlet weak var searchBar: UISearchBar!
    
    var businesses: [Business] = []
  //  var businessesDict: [Business]!
   
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessTableView.dataSource = self
        businessTableView.estimatedRowHeight = 200
        businessTableView.rowHeight = UITableViewAutomaticDimension

        
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ businessTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       /* if(searchActive) {
            return filteredBusinesses.count
        }*/
        print("Business Count \(self.businesses.count)")
        return self.businesses.count
    }
    
    func tableView(_ businessTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BusinessTableViewCell = businessTableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell") as! BusinessTableViewCell
        
        let resultBusiness:Business
        
        //If search is active set the filtered movie else the whole list
      /*  if(searchActive){
            resultBusiness = self.filteredBusinesses[indexPath.row]
        } else {
            resultBusiness = self.businesses[indexPath.row]
        }
        */
        
        
        resultBusiness = self.businesses[indexPath.row]        
        cell.businessItem = resultBusiness
        print(resultBusiness)
        
        //Customize the highlight and selection effect of the cell
       /* let view = UIView()
        view.backgroundColor = UIColor.init(red: 0.09, green: 0.57, blue: 0.78, alpha: 1.0)
        cell.selectedBackgroundView = view*/
        
        return cell
        
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
     }
     */
    
}
