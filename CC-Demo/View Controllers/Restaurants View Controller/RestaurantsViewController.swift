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
import CoreLocation
import MapKit

class RestaurantsViewController: UIViewController {
    //Outlets Start
    
    
    @IBOutlet weak var restaurantsCollectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    //Outlets End
    
    
    var lat:Double?
    var lng:Double?
    
    var places: [PlaceItem]?
    
    var originalViewModels: [RestaurantItemViewModel]?
    var filteredViewModels: [RestaurantItemViewModel]?
    var cityName: String?
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupCollectionView()
        self.setupSearchBar()
        self.getDataFromService()
    }
    
    func setupSearchBar() {
        self.searchBar.delegate = self
    }
    
    func setupCollectionView() {
        self.restaurantsCollectionView.delegate = self
        self.restaurantsCollectionView.dataSource = self
    }
    
    func getLocationUpdates() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    func getDataFromService() {
        guard let _ = self.lat else {
            self.getLocationUpdates()
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let version = formatter.string(from: Date())
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        APIClient.getVenuesNearBy(lat: String(lat!), lng: String(lng!), versionApi: version, categoryID: K.Constants.four_square_category_id) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch(result) {
            case .success(let data):
                if let groups = data.response?.groups {
                    if groups.count > 0 {
                        self.places = groups[0].items

                        self.originalViewModels = groups[0].items!.map({return RestaurantItemViewModel(data: $0, cityName: self.cityName ?? "")})
                        self.filteredViewModels = self.originalViewModels
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
    
    func filterListWith(keyword: String) {
        if keyword != "" {
            self.filteredViewModels = []
            for item in self.originalViewModels! {
                if (item.nameString.lowercased().contains(keyword.lowercased())) {
                    self.filteredViewModels?.append(item)
                }
            }
        } else {
            self.filteredViewModels = self.originalViewModels
        }
        self.restaurantsCollectionView.reloadData()
    }
    
    func getCity(from location: CLLocation, completion: @escaping (_ city: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       error)
        }
    }

}

extension RestaurantsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let str = searchBar.text
        self.filterListWith(keyword: str!)
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text != "" {
            let str = searchBar.text! + text
            self.filterListWith(keyword: str)
        } else {
            let value = searchBar.text!
            let endIndex = value.index(value.endIndex, offsetBy: -1)
            self.filterListWith(keyword: value.substring(to: endIndex))
        }
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.filterListWith(keyword: "")
    }
    
}

extension RestaurantsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let array = self.filteredViewModels {
            return array.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RestaurantCollectionViewCell
        
        let data = self.filteredViewModels![indexPath.row]
        cell.restaurantViewModel = data
        
        print(data.imageUrl!)
        
        cell.navigateBtn.tag = indexPath.row
        cell.navigateBtn.addTarget(self, action: #selector(self.navigateToLocation(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width, height: 125)
    }
    
    @objc func navigateToLocation(sender: UIButton) {
        let index = sender.tag
        let data = self.filteredViewModels![index]
        
        let coordinate = CLLocationCoordinate2DMake(data.lat, data.lng)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.02))
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)]
        mapItem.name = data.nameString
        mapItem.openInMaps(launchOptions: options)
    }
    
}

extension RestaurantsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        self.lat = location.coordinate.latitude
        self.lng = location.coordinate.longitude
        
        self.getCity(from: CLLocation.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) { (cityName, error) in
            self.locationManager.stopUpdatingLocation()
            self.locationManager.delegate = nil
            MBProgressHUD.hide(for: self.view, animated: true)
            self.getDataFromService()
            if error == nil {
                self.cityName = cityName
            }
        }
        
    }
    
}
