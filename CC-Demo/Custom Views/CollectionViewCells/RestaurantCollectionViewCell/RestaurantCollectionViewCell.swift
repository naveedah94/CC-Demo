//
//  RestaurantCollectionViewCell.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/25/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import UIKit

class RestaurantCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemLocationLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var navigateBtn: UIButton!
    
    var restaurantViewModel: RestaurantItemViewModel! {
        didSet {
            self.itemNameLabel.text = restaurantViewModel.nameString
            self.itemLocationLabel.text = restaurantViewModel.locationString
            self.categoryLabel.text = restaurantViewModel.categoryString
            if let url = restaurantViewModel.imageUrl {
                self.itemImage.sd_setImage(with: url, completed: nil)
            } else {
                self.itemImage.image = nil
            }
        }
    }
}
