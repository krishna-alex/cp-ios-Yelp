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
                    businessNameLabel?.text = _business?.name
                    businessDistanceLabel?.text = _business?.distance
                    businessReviewCountLabel?.text = "\((_business?.reviewCount)!) Reviews"
                    businessAddressLabel?.text = _business?.address
                    businessCategoriesLabel?.text = _business?.categories
                    businessImageView.setImageWith((_business?.imageURL)!)
                    businessRatingImageView.setImageWith((_business?.ratingImageURL)!)
            }
        }
    }



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        businessImageView.layer.cornerRadius = 3
        businessImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
