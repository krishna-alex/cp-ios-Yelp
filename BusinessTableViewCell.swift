//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Krishna Alex on 4/6/17.
//  Copyright © 2017 Krishna Alex. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {
    
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessDistanceLabel: UILabel!
    @IBOutlet weak var businessReviewCountLabel: UILabel!
    @IBOutlet weak var businessCategoriesLabel: UILabel!
    @IBOutlet weak var businessAddressLabel: UILabel!

    @IBOutlet weak var businessRatingImageView: UIImageView!
    
    private var _business: Business?
    
    var businessItem: Business {
        get {
            return self._business!
        }
        set(businessItem) {
            self._business = businessItem
            
            if (self._business != nil) {
                if let businessName = _business?.name{
                    self.businessNameLabel?.text = businessName
                }
                if let businessDistance = _business?.distance{
                    self.businessDistanceLabel?.text = "\(businessDistance)"
                }
                if let businessReviewCount = _business?.reviewCount{
                    self.businessReviewCountLabel?.text = "\(businessReviewCount) Reviews"
                }
                if let businessAddress = _business?.address{
                    self.businessAddressLabel?.text = businessAddress
                }
                if let businessCategory = _business?.categories{
                    self.businessCategoriesLabel?.text = businessCategory
                }
                if let businessImageURL = _business?.imageURL{
                    businessImageView.setImageWith(businessImageURL)
                }
                if let businessRatingImageURL = _business?.ratingImageURL{
                 businessRatingImageView.setImageWith(businessRatingImageURL)
                }
            }
        }
    }



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
