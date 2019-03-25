//
//  RestaurantCollectionViewCell.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/25/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import UIKit
import SDWebImage

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
                SDWebImageDownloader.shared().downloadImage(with: url, options: .highPriority, progress: nil) { (image, data, error, status) in
                    if error == nil {
                        self.itemImage.image = self.grayscaleImage(image: image!)
                    } else {
                        self.itemImage.image = nil
                        print(error?.localizedDescription as Any)
                    }
                }
            } else {
                self.itemImage.image = nil
            }
        }
    }
    
    func grayscaleImage(image: UIImage) -> UIImage {
        let mImage = CIImage(image: image)
        let grayscale = mImage!.applyingFilter("CIColorControls",
                                               parameters: [ kCIInputSaturationKey: 0.0 ])
        return UIImage(ciImage: grayscale)
    }
}
