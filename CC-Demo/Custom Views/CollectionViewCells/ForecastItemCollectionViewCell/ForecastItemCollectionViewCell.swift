//
//  ForecastItemCollectionViewCell.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/24/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import UIKit
import SDWebImage

class ForecastItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    
    var forecastViewModel: ForecastViewModel! {
        didSet {
            self.dayLabel.text = forecastViewModel.dayString
            self.maxTempLabel.text = forecastViewModel.maxTempString
            self.minTempLabel.text = forecastViewModel.minTempString
            if let url = forecastViewModel.imageUrl {
                self.weatherImage.sd_setImage(with: url, completed: nil)
            }
        }
    }
}
