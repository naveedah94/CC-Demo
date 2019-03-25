//
//  WeatherViewController.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/24/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreLocation
import SDWebImage

class WeatherViewController: UIViewController {

    //Outlets Start
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!
    
    @IBOutlet weak var restaurantsBtn: UIButton!
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    //Outlets End
    
    var cityName: String?
    
    var currentWeatherData: CurrentWeatherModel?
    var forecastWeatherData: [WeatherForecastItem]?
    
    var currenWeatherViewModel: CurrentWeatherViewModel?
    var forecastViewModels: [ForecastViewModel]?
    
    var lat: Double?
    var lng: Double?
    var isFetchingCityDetails = false
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupCollectionView()
        self.setupBtn()
        self.getLocationUpdates()
    }
    
    func setupCollectionView() {
        self.forecastCollectionView.delegate = self
        self.forecastCollectionView.dataSource = self
    }
    
    func setupBtn() {
        self.restaurantsBtn.clipsToBounds = true
        self.restaurantsBtn.layer.cornerRadius = 16
        self.restaurantsBtn.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func getLocationUpdates() {
        MBProgressHUD .showAdded(to: self.view, animated: true)
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // Get Weather Current & Forecast Data
    // Using Dispatch Group to Notify When All Service Calls Are Completed
    func getDataFromService(lat: String, lng: String) {
        let serviceGroup = DispatchGroup()
        var configError:Error?
        
        //Showing Progress
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        serviceGroup.enter()
        APIClient.getCurrentWeather(lat: lat, lng: lng) { (result) in
            switch(result) {
            case .success(let data):
                guard let code = data.cod else {
                    serviceGroup.leave()
                    Helper.init().displayAlert(title: "Alert", message: "Failed to get data, Some error occured", positive: "OK", postiveListener: {
                        
                    }, viewController: self)
                    break
                }
                if code == 200 {
                    self.currentWeatherData = data
                    self.currenWeatherViewModel = CurrentWeatherViewModel.init(currentWeatherData: data)
                    self.setDataOnView()
                }
                serviceGroup.leave()
            case .failure(let error):
                configError = error
                serviceGroup.leave()
            }
        }
        
        serviceGroup.enter()
        APIClient.getWeatherForecast(lat: lat, lng: lng) { (result) in
            switch(result) {
            case .success(let data):
                guard let code = data.cod else {
                    serviceGroup.leave()
                    Helper.init().displayAlert(title: "Alert", message: "Failed to get data, Some error occured", positive: "OK", postiveListener: {
                        
                    }, viewController: self)
                    break
                }
                if code == "200" {
                    let filteredData = self.filterForecastArray(originalArray: data.forecastArray!)
                    self.forecastWeatherData = filteredData
                    self.forecastViewModels = []
                    self.forecastViewModels = filteredData.map({ForecastViewModel(item: $0)})
                }
                serviceGroup.leave()
            case .failure(let error):
                configError = error
                serviceGroup.leave()
            }
        }
        
        serviceGroup.notify(queue: .main) {
            //Removing Progress + All Service Group Workers Finished
            MBProgressHUD.hide(for: self.view, animated: true)
            if configError != nil{
                print(configError?.localizedDescription as Any)
                Helper.init().displayAlert(title: "Alert", message: "Failed to get data, Some error occured", positive: "OK", postiveListener: {
                    
                }, viewController: self)
            } else {
                if self.currenWeatherViewModel != nil && self.forecastViewModels != nil {
                    //Yay Got All Data
                    self.setDataOnView()
                } else {
                    //Oops Missed Some Data
                    Helper.init().displayAlert(title: "Alert", message: "Failed to get data, Some error occured", positive: "OK", postiveListener: {
                        
                    }, viewController: self)
                }
            }
        }
    }
    
    func filterForecastArray(originalArray: [WeatherForecastItem]) -> [WeatherForecastItem] {
        var filteredArray:[WeatherForecastItem] = []
        for item in originalArray {
            let formatter  = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss"
            
            let timeString = timeFormatter.string(from: formatter.date(from: item.dateText!)!)
            
            if timeString == "12:00:00" {
                filteredArray.append(item)
            }
        }
        print(filteredArray as Any)
        return filteredArray
    }
    
    func getCity(from location: CLLocation, completion: @escaping (_ city: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       error)
        }
    }
    
    func setDataOnView() {
        self.forecastCollectionView.reloadData()
        if let data = self.currenWeatherViewModel {
            if let val = self.cityName {
                self.cityNameLabel.text = val
            } else {
                self.cityNameLabel.text = "-"
            }
            
            self.dayLabel.text = data.dayString
            self.weatherDescLabel.text = data.weatherDescriptionString
            self.temperatureLabel.text = data.temperatureString
            self.visibilityLabel.text = data.visibilityString
            self.humidityLabel.text = data.humidityString
            self.windLabel.text = data.windString
            
            if let url = data.imageUrl {
                self.weatherImage.sd_setImage(with: url, completed: nil)
            }
        }
    }
    
    
    //IBAction Start
    
    
    @IBAction func celciusBtnClicked(_ sender: Any) {
        UserDefaults.standard.set(K.Constants.celcius, forKey: K.Constants.temperature_preference)
        if let forecast = self.forecastWeatherData {
            self.forecastViewModels = forecast.map({ForecastViewModel(item: $0)})
        }
        if let currentData = self.currentWeatherData {
            self.currenWeatherViewModel = CurrentWeatherViewModel.init(currentWeatherData: currentData)
        }
        self.setDataOnView()
    }
    
    @IBAction func fahrenheitBtnClicked(_ sender: Any) {
        UserDefaults.standard.set(K.Constants.fahrenheit, forKey: K.Constants.temperature_preference)
        if let forecast = self.forecastWeatherData {
            self.forecastViewModels = forecast.map({ForecastViewModel(item: $0)})
        }
        if let currentData = self.currentWeatherData {
            self.currenWeatherViewModel = CurrentWeatherViewModel.init(currentWeatherData: currentData)
        }
        self.setDataOnView()
    }
    
    @IBAction func restaurantsBtnClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantsViewController") as! RestaurantsViewController
        controller.lat = self.lat
        controller.lng = self.lng
        controller.cityName = self.cityName
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //IBAction End

}


extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let val = self.forecastViewModels {
            return val.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ForecastItemCollectionViewCell
        
        cell.forecastViewModel = self.forecastViewModels![indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width / 5, height: collectionView.frame.size.height)
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !isFetchingCityDetails {
            isFetchingCityDetails = true
            let location = locations[0]
            self.lat = location.coordinate.latitude
            self.lng = location.coordinate.longitude
            self.getCity(from: CLLocation.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) { (cityName, error) in
                self.locationManager.stopUpdatingLocation()
                self.locationManager.delegate = nil
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == nil {
                    self.cityName = cityName
                    self.getDataFromService(lat: String(self.lat!), lng: String(self.lng!))
                }
            }
        }
    }
    
}
