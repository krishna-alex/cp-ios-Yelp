//
//  ListCell.swift
//  Yelp
//
//  Created by Krishna Alex on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var listImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
