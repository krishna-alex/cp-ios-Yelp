//
//  filtersTableTableViewController.swift
//  Yelp
//
//  Created by Krishna Alex on 4/7/17.
//  Copyright © 2017 Krishna Alex. All rights reserved.
//

import UIKit

@objc protocol FiltersTableViewControllerDelegate {
    @objc optional func filtersTableViewController(filtersTableViewController: filtersTableTableViewController, didUpdateFilters filters: [String: AnyObject])
}

class filtersTableTableViewController: UITableViewController, SwitchCellDelegate {
    
      var sectionSet = [ ["caption": "Deals Offered",
                        "key": "deals",
                        "type": "Switch"],
                       ["caption": "Distance",
                        "key": "distance",
                        "type": "List"],
                       ["caption": "Sort By",
                        "key": "sort",
                        "type": "List"],
                       ["caption": "Category",
                        "key": "category",
                        "type": "Switch"]]
    

    @IBOutlet var filtersTableView: UITableView!
    var categories: [[String:String]]!
    var distanceList: [[String:String]]!
    var sortList: [[String:String]]!
    weak var delegate: FiltersTableViewControllerDelegate?
    var categoryStates = [Int:Bool]()
    var dealState = Bool()
    var distancePreference = String()
    var sortPreference = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filtersTableView.dataSource = self
        filtersTableView.estimatedRowHeight = 30
        filtersTableView.rowHeight = UITableViewAutomaticDimension
        categories = categoryOptions()
        distanceList = distanceOptions()
        sortList = sortOptions()
        
        filtersTableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    @IBAction func onSearchButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        var filters = [String:AnyObject]()
        var selectedCategories = [String]()
        print("categoryStates" , categoryStates)
        for(row, isSelected) in categoryStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject?
        }
        
        filters["deals"] = dealState as AnyObject?
        filters["distancePreference"] = distancePreference as AnyObject?
        filters["sortPreference"] = sortPreference as AnyObject?
        
        delegate?.filtersTableViewController?(filtersTableViewController: self, didUpdateFilters: filters)
    }

    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in filtersTableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return self.section.count
        print("numberOfSections")
        print(self.sectionSet.count)
        return self.sectionSet.count
    }
    
    
    override func tableView(_ filtersTableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return self.section[section]
        print("titleForHeaderInSection")
        print(self.sectionSet[section]["caption"] ?? "DefaultTitle")
        return self.sectionSet[section]["caption"] 
        
        //return self.settingSections[section]
        
    }
    
    override func tableView(_ filtersTableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return tableView.sectionHeaderHeight * 2
        }
        return tableView.sectionHeaderHeight
    }

    override func tableView(_ filtersTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let filterItem : NSDictionary = sectionSet[section] as NSDictionary
        print("filterItem : \(filterItem)")
        let key = filterItem.value(forKeyPath: "key") as! String
        print("key: \(key)")
        print("number of rows in section")
        print(self.countDropdownOptionsBySettingKey(key: "\(key)"))
        
        return self.countDropdownOptionsBySettingKey(key: key)
        //return 1

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = sectionSet[indexPath.section]["type"]! as String
        let currSection = sectionSet[indexPath.section]
        if cellType == "List" {
            // Uncheck everything in section 'section'
            for _row in 0 ..< tableView.numberOfRows(inSection: indexPath.section) {
                tableView.cellForRow(at: IndexPath(row: _row, section: indexPath.section))?.accessoryType = .none;
            }
            // Check the selection
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark;
            print("tableView.cellForRow(at: indexPath)", tableView.cellForRow(at: indexPath))
           if currSection["key"] == "distance" {
                distancePreference = distanceList[indexPath.row]["code"]!
                print("distancePreference", distancePreference)
            }
            if currSection["key"] == "sort" {
                sortPreference = sortList[indexPath.row]["code"]!
                print("sortPreference", sortPreference)
            }
        }
        
    }
    
    override func tableView(_ filtersTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        //var cell =
        let currSection = sectionSet[indexPath.section]
        let currSectionType = currSection["type"]! as String
        print("currSection, currSectionType" , currSection, currSectionType)
        
        /*if currSectionType == "Switch" {*/
        let switchCell: SwitchCell = filtersTableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
        let ListCell: ListCell = filtersTableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListCell


        print("section asked for is", indexPath.section, indexPath.row)
        
        var options : [[String:String]]!
        
        switch(indexPath.section) {
            case 0:
                switchCell.switchLabel?.text = "Deals"
                //switchCell.switchOption.isOn = false
            case 1:
                options = distanceOptions()
                let optionValue = options[indexPath.row]
                ListCell.listLabel?.text = optionValue["name"]
            case 2:
                options = sortOptions()
                let optionValue = options[indexPath.row]
                ListCell.listLabel?.text = optionValue["name"]
            case 3:
                options = categoryOptions()
                let optionValue = options[indexPath.row]
                switchCell.switchLabel?.text = optionValue["name"]
            default:
                break
        }
        
       /* if (indexPath.section == 1) {
            options = distanceOptions()
            let optionValue = options[indexPath.row]
            cell.listLabel?.text = optionValue["code"]
        } else if (indexPath.section == 2) {
            options = sortOptions()
            let optionValue = options[indexPath.row]
            cell.listLabel?.text = optionValue["code"]
        } else if (indexPath.section == 3) {
            options = categoryOptions()
            let optionValue = options[indexPath.row]
            cell.listLabel?.text = optionValue["code"]
        } else {
            cell.switchLabel?.text = "Deals"
            cell.switchOption.isOn = false
        }*/
        
        if currSectionType == "List" {
            //ListCell.delegate = self
            return ListCell
        }
        else {
            switchCell.delegate = self
            switchCell.switchOption.isOn = categoryStates[indexPath.row] ?? false
            return switchCell
        }
    }
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = filtersTableView.indexPath(for: switchCell)
        let currSection = sectionSet[(indexPath?.section)!]
        if currSection["key"] == "category" {
            categoryStates[indexPath!.row] = value
            print("in switchcell delegate", categoryStates[indexPath!.row])
            print("categoryStates", categoryStates)
        } else if currSection["key"] == "deals" {
            dealState = value
            print("dealState", dealState)
        }
        
    }

    
    /*override func tableView(_ filtersTableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (cell.responds(to: #selector(getter: UIView.tintColor))) {
            let cornerRadius: CGFloat = 5
            cell.backgroundColor = UIColor.clear
            let layer: CAShapeLayer  = CAShapeLayer()
            let pathRef: CGMutablePath  = CGMutablePath()
            let bounds: CGRect  = cell.bounds.insetBy(dx: 10, dy: 0)
            var addLine: Bool  = false
            if (indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
                pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
            } else if (indexPath.row == 0) {
                pathRef.move(to: CGPoint(x:bounds.minX,y:bounds.maxY))
                pathRef.addArc(tangent1End: CGPoint(x:bounds.minX,y:bounds.minY), tangent2End: CGPoint(x:bounds.midX,y:bounds.minY), radius: cornerRadius)
                
                pathRef.addArc(tangent1End: CGPoint(x:bounds.maxX,y:bounds.minY), tangent2End: CGPoint(x:bounds.maxX,y:bounds.midY), radius: cornerRadius)
                pathRef.addLine(to: CGPoint(x:bounds.maxX,y:bounds.maxY))
                addLine = true;
            } else if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
                
                pathRef.move(to: CGPoint(x:bounds.minX,y:bounds.minY))
                pathRef.addArc(tangent1End: CGPoint(x:bounds.minX,y:bounds.maxY), tangent2End: CGPoint(x:bounds.midX,y:bounds.maxY), radius: cornerRadius)
                
                pathRef.addArc(tangent1End: CGPoint(x:bounds.maxX,y:bounds.maxY), tangent2End: CGPoint(x:bounds.maxX,y:bounds.midY), radius: cornerRadius)
                pathRef.addLine(to: CGPoint(x:bounds.maxX,y:bounds.minY))
                
            } else {
                pathRef.addRect(bounds)
                addLine = true
            }
            layer.path = pathRef
            //CFRelease(pathRef)
            //set the border color
            //layer.strokeColor = UIColor.lightGray.cgColor
            layer.strokeColor = UIColor.black.cgColor
            //set the border width
            layer.lineWidth = 1
            layer.fillColor = UIColor(white: 1, alpha: 1.0).cgColor
            
            
            if (addLine == true) {
                let lineLayer: CALayer = CALayer()
                let lineHeight: CGFloat  = (1 / UIScreen.main.scale)
                lineLayer.frame = CGRect(x:bounds.minX, y:bounds.size.height-lineHeight, width:bounds.size.width, height:lineHeight)
                lineLayer.backgroundColor = tableView.separatorColor!.cgColor
                layer.addSublayer(lineLayer)
            }
            
            let testView: UIView = UIView(frame:bounds)
            testView.layer.insertSublayer(layer, at: 0)
            testView.backgroundColor = UIColor.clear
            cell.backgroundView = testView
        }
        
    } */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func countDropdownOptionsBySettingKey(key : String) -> (Int) {
    
        var count = 0;
    
        if (key == "distance") {
            count = distanceOptions().count;
        }
    
        if (key == "sort") {
            count = sortOptions().count;
        }
    
        if (key == "category") {
            count = categoryOptions().count;
        }
        if (key == "deals") {
            count = 1;
        }
    
        return count;
    }
    
    
    func distanceOptions() -> [[String:String]] {
    return [["name" : "Auto", "code" : "Auto"],
            ["name" : "0.3 miles", "code" : "482"],
            ["name" : "1 mile", "code" : "1609"],
            ["name" : "5 miles", "code" : "8046"],
            ["name" : "20 miles", "code" : "32186"]]
    
    }

    
    func sortOptions() -> [[String:String]] {
        return [["name" : "Best matched (default)", "code" : "0"],
                ["name" : "Distance", "code" : "1"],
                ["name" : "Highest rated", "code" : "2"]]
    
    }

    
    
    func categoryOptions() -> [[String:String]] {
    
                return [["name" : "Afghan", "code": "afghani"],
                      ["name" : "African", "code": "african"],
                      ["name" : "American, New", "code": "newamerican"],
                      ["name" : "American, Traditional", "code": "tradamerican"],
                      ["name" : "Arabian", "code": "arabian"],
                      ["name" : "Argentine", "code": "argentine"],
                      ["name" : "Armenian", "code": "armenian"],
                      ["name" : "Asian Fusion", "code": "asianfusion"],
                      ["name" : "Asturian", "code": "asturian"],
                      ["name" : "Australian", "code": "australian"],
                      ["name" : "Austrian", "code": "austrian"],
                      ["name" : "Baguettes", "code": "baguettes"],
                      ["name" : "Bangladeshi", "code": "bangladeshi"],
                      ["name" : "Barbeque", "code": "bbq"],
                      ["name" : "Basque", "code": "basque"],
                      ["name" : "Bavarian", "code": "bavarian"],
                      ["name" : "Beer Garden", "code": "beergarden"],
                      ["name" : "Beer Hall", "code": "beerhall"],
                      ["name" : "Beisl", "code": "beisl"],
                      ["name" : "Belgian", "code": "belgian"],
                      ["name" : "Bistros", "code": "bistros"],
                      ["name" : "Black Sea", "code": "blacksea"],
                      ["name" : "Brasseries", "code": "brasseries"],
                      ["name" : "Brazilian", "code": "brazilian"],
                      ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                      ["name" : "British", "code": "british"],
                      ["name" : "Buffets", "code": "buffets"],
                      ["name" : "Bulgarian", "code": "bulgarian"],
                      ["name" : "Burgers", "code": "burgers"],
                      ["name" : "Burmese", "code": "burmese"],
                      ["name" : "Cafes", "code": "cafes"],
                      ["name" : "Cafeteria", "code": "cafeteria"],
                      ["name" : "Cajun/Creole", "code": "cajun"],
                      ["name" : "Cambodian", "code": "cambodian"],
                      ["name" : "Canadian", "code": "New)"],
                      ["name" : "Canteen", "code": "canteen"],
                      ["name" : "Caribbean", "code": "caribbean"],
                      ["name" : "Catalan", "code": "catalan"],
                      ["name" : "Chech", "code": "chech"],
                      ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                      ["name" : "Chicken Shop", "code": "chickenshop"],
                      ["name" : "Chicken Wings", "code": "chicken_wings"],
                      ["name" : "Chilean", "code": "chilean"],
                      ["name" : "Chinese", "code": "chinese"],
                      ["name" : "Comfort Food", "code": "comfortfood"],
                      ["name" : "Corsican", "code": "corsican"],
                      ["name" : "Creperies", "code": "creperies"],
                      ["name" : "Cuban", "code": "cuban"],
                      ["name" : "Curry Sausage", "code": "currysausage"],
                      ["name" : "Cypriot", "code": "cypriot"],
                      ["name" : "Czech", "code": "czech"],
                      ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                      ["name" : "Danish", "code": "danish"],
                      ["name" : "Delis", "code": "delis"],
                      ["name" : "Diners", "code": "diners"],
                      ["name" : "Dumplings", "code": "dumplings"],
                      ["name" : "Eastern European", "code": "eastern_european"],
                      ["name" : "Ethiopian", "code": "ethiopian"],
                      ["name" : "Fast Food", "code": "hotdogs"],
                      ["name" : "Filipino", "code": "filipino"],
                      ["name" : "Fish & Chips", "code": "fishnchips"],
                      ["name" : "Fondue", "code": "fondue"],
                      ["name" : "Food Court", "code": "food_court"],
                      ["name" : "Food Stands", "code": "foodstands"],
                      ["name" : "French", "code": "french"],
                      ["name" : "French Southwest", "code": "sud_ouest"],
                      ["name" : "Galician", "code": "galician"],
                      ["name" : "Gastropubs", "code": "gastropubs"],
                      ["name" : "Georgian", "code": "georgian"],
                      ["name" : "German", "code": "german"],
                      ["name" : "Giblets", "code": "giblets"],
                      ["name" : "Gluten-Free", "code": "gluten_free"],
                      ["name" : "Greek", "code": "greek"],
                      ["name" : "Halal", "code": "halal"],
                      ["name" : "Hawaiian", "code": "hawaiian"],
                      ["name" : "Heuriger", "code": "heuriger"],
                      ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                      ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                      ["name" : "Hot Dogs", "code": "hotdog"],
                      ["name" : "Hot Pot", "code": "hotpot"],
                      ["name" : "Hungarian", "code": "hungarian"],
                      ["name" : "Iberian", "code": "iberian"],
                      ["name" : "Indian", "code": "indpak"],
                      ["name" : "Indonesian", "code": "indonesian"],
                      ["name" : "International", "code": "international"],
                      ["name" : "Irish", "code": "irish"],
                      ["name" : "Island Pub", "code": "island_pub"],
                      ["name" : "Israeli", "code": "israeli"],
                      ["name" : "Italian", "code": "italian"],
                      ["name" : "Japanese", "code": "japanese"],
                      ["name" : "Jewish", "code": "jewish"],
                      ["name" : "Kebab", "code": "kebab"],
                      ["name" : "Korean", "code": "korean"],
                      ["name" : "Kosher", "code": "kosher"],
                      ["name" : "Kurdish", "code": "kurdish"],
                      ["name" : "Laos", "code": "laos"],
                      ["name" : "Laotian", "code": "laotian"],
                      ["name" : "Latin American", "code": "latin"],
                      ["name" : "Live/Raw Food", "code": "raw_food"],
                      ["name" : "Lyonnais", "code": "lyonnais"],
                      ["name" : "Malaysian", "code": "malaysian"],
                      ["name" : "Meatballs", "code": "meatballs"],
                      ["name" : "Mediterranean", "code": "mediterranean"],
                      ["name" : "Mexican", "code": "mexican"],
                      ["name" : "Middle Eastern", "code": "mideastern"],
                      ["name" : "Milk Bars", "code": "milkbars"],
                      ["name" : "Modern Australian", "code": "modern_australian"],
                      ["name" : "Modern European", "code": "modern_european"],
                      ["name" : "Mongolian", "code": "mongolian"],
                      ["name" : "Moroccan", "code": "moroccan"],
                      ["name" : "New Zealand", "code": "newzealand"],
                      ["name" : "Night Food", "code": "nightfood"],
                      ["name" : "Norcinerie", "code": "norcinerie"],
                      ["name" : "Open Sandwiches", "code": "opensandwiches"],
                      ["name" : "Oriental", "code": "oriental"],
                      ["name" : "Pakistani", "code": "pakistani"],
                      ["name" : "Parent Cafes", "code": "eltern_cafes"],
                      ["name" : "Parma", "code": "parma"],
                      ["name" : "Persian/Iranian", "code": "persian"],
                      ["name" : "Peruvian", "code": "peruvian"],
                      ["name" : "Pita", "code": "pita"],
                      ["name" : "Pizza", "code": "pizza"],
                      ["name" : "Polish", "code": "polish"],
                      ["name" : "Portuguese", "code": "portuguese"],
                      ["name" : "Potatoes", "code": "potatoes"],
                      ["name" : "Poutineries", "code": "poutineries"],
                      ["name" : "Pub Food", "code": "pubfood"],
                      ["name" : "Rice", "code": "riceshop"],
                      ["name" : "Romanian", "code": "romanian"],
                      ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                      ["name" : "Rumanian", "code": "rumanian"],
                      ["name" : "Russian", "code": "russian"],
                      ["name" : "Salad", "code": "salad"],
                      ["name" : "Sandwiches", "code": "sandwiches"],
                      ["name" : "Scandinavian", "code": "scandinavian"],
                      ["name" : "Scottish", "code": "scottish"],
                      ["name" : "Seafood", "code": "seafood"],
                      ["name" : "Serbo Croatian", "code": "serbocroatian"],
                      ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                      ["name" : "Singaporean", "code": "singaporean"],
                      ["name" : "Slovakian", "code": "slovakian"],
                      ["name" : "Soul Food", "code": "soulfood"],
                      ["name" : "Soup", "code": "soup"],
                      ["name" : "Southern", "code": "southern"],
                      ["name" : "Spanish", "code": "spanish"],
                      ["name" : "Steakhouses", "code": "steak"],
                      ["name" : "Sushi Bars", "code": "sushi"],
                      ["name" : "Swabian", "code": "swabian"],
                      ["name" : "Swedish", "code": "swedish"],
                      ["name" : "Swiss Food", "code": "swissfood"],
                      ["name" : "Tabernas", "code": "tabernas"],
                      ["name" : "Taiwanese", "code": "taiwanese"],
                      ["name" : "Tapas Bars", "code": "tapas"],
                      ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                      ["name" : "Tex-Mex", "code": "tex-mex"],
                      ["name" : "Thai", "code": "thai"],
                      ["name" : "Traditional Norwegian", "code": "norwegian"],
                      ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                      ["name" : "Trattorie", "code": "trattorie"],
                      ["name" : "Turkish", "code": "turkish"],
                      ["name" : "Ukrainian", "code": "ukrainian"],
                      ["name" : "Uzbek", "code": "uzbek"],
                      ["name" : "Vegan", "code": "vegan"],
                      ["name" : "Vegetarian", "code": "vegetarian"],
                      ["name" : "Venison", "code": "venison"],
                      ["name" : "Vietnamese", "code": "vietnamese"],
                      ["name" : "Wok", "code": "wok"],
                      ["name" : "Wraps", "code": "wraps"],
                      ["name" : "Yugoslav", "code": "yugoslav"]]
        
    }

}
