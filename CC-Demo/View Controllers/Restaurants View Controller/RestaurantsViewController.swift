//
//  RestaurantsViewController.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/24/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage

class RestaurantsViewController: UIViewController {
    //Outlets Start
    
    
    @IBOutlet weak var restaurantsCollectionView: UICollectionView!
    
    //Outlets End
    
    
    let lat = 24.935142
    let lng = 67.137402
    
    var places: [PlaceItem]?
    var cityName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.restaurantsCollectionView.delegate = self
        self.restaurantsCollectionView.dataSource = self
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        let version = formatter.string(from: Date())
        
        APIClient.getVenuesNearBy(lat: String(lat), lng: String(lng), versionApi: version, categoryID: K.Constants.four_square_category_id) { (result) in
            switch(result) {
            case .success(let data):
                print("Got the data")
                if let groups = data.response?.groups {
                    if groups.count > 0 {
                        self.places = groups[0].items
                        self.restaurantsCollectionView.reloadData()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.title = "Nearby Restaurants"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}


extension RestaurantsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let array = self.places {
            return array.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RestaurantCollectionViewCell
        
        let data = self.places![indexPath.row]
        
        cell.itemNameLabel.text = data.venue?.name
        if let value = self.cityName {
            cell.itemLocationLabel.text = value
        } else {
            cell.itemLocationLabel.text = "-"
        }
        
        if let categories = data.venue?.categories {
            if categories.count > 0 {
                cell.categoryLabel.text = categories[0].name
            } else {
                cell.categoryLabel.text = "-"
            }
        } else {
            cell.categoryLabel.text = "-"
        }
        
        cell.itemImage.sd_setImage(with: URL.init(string: (data.venue?.categories![0].icon?.prefix)! +  "100" + (data.venue?.categories![0].icon?.suffix)!), completed: nil)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width, height: 125)
    }
    
}
