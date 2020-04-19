//
//  CategoryCell.swift
//  HeroStats
//
//  Created by Rayyan Maretan on 19/04/20.
//  Copyright © 2020 Rayyan Maretan. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet var categoryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryLabel.layer.cornerRadius = categoryLabel.frame.height/2
        categoryLabel.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        categoryLabel.layer.cornerRadius = categoryLabel.frame.height/2
        categoryLabel.layer.masksToBounds = true
        super.layoutSubviews()
    }
}
