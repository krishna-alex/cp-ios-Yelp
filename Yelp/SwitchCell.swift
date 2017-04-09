//
//  SwitchCell.swift
//  Yelp
//
//  Created by Krishna Alex on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var switchOption: UISwitch!
    
    weak var delegate: SwitchCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // switchOption.addTarget(self, action: "switchValueChanged", for: UIControlEvents.valueChanged)
        switchOption.addTarget(self, action: #selector(SwitchCell.switchValueToggled), for: UIControlEvents.valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchValueToggled() {
        print("switchValueChanged")
            delegate?.switchCell?(switchCell: self, didChangeValue: switchOption.isOn)    
    }
}
