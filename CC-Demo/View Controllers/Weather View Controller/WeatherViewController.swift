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
    
    let lat = 24.935142
    let lng = 67.137402
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.forecastCollectionView.delegate = self
        self.forecastCollectionView.dataSource = self
        
        self.restaurantsBtn.clipsToBounds = true
        self.restaurantsBtn.layer.cornerRadius = 16
        self.restaurantsBtn.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.getCity(from: CLLocation.init(latitude: self.lat, longitude: self.lng)) { (cityName, error) in
            if error == nil {
                self.cityName = cityName
                self.getDataFromService(lat: String(self.lat), lng: String(self.lng))
            }
        }
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
                    break
                }
                if code == 200 {
                    self.currentWeatherData = data
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
                    break
                }
                if code == "200" {
                    self.forecastWeatherData = self.filterForecastArray(originalArray: data.forecastArray!)
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
                if self.currentWeatherData != nil && self.forecastWeatherData != nil {
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
            
            if timeString == "06:00:00" {
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
        if let data = self.currentWeatherData {
            if let val = self.cityName {
                self.cityNameLabel.text = val
            } else {
                self.cityNameLabel.text = "-"
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            
            self.dayLabel.text = formatter.string(from: Date())
            if let weather = data.weather {
                if weather.count > 0 {
                    self.weatherDescLabel.text = weather[0].description
                    self.weatherImage.sd_setImage(with: URL.init(string: K.ProductionServer.weatherImageUrl + weather[0].icon! + ".png"), completed: nil)
                } else {
                    self.weatherDescLabel.text = "-"
                }
            } else {
                self.weatherDescLabel.text = "-"
            }
            
            self.temperatureLabel.text = String.init(format: "%d", Int(self.getConvertedTemperatureFrom(kelvin: (data.main?.temp)!)))
            
            self.visibilityLabel.text = String(data.visibility! / 1000)
            self.humidityLabel.text = String((data.main?.humidity)!)
            self.windLabel.text = String.init(format: "%.2f", (data.wind?.speed!)! * 3.6)//String((data.wind?.speed!)! * 3.6)
            
            
        }
    }
    
    func getConvertedTemperatureFrom(kelvin: Double) -> Double {
        guard let tempPreference = UserDefaults.standard.object(forKey: K.Constants.temperature_preference) as? String else {
            UserDefaults.standard.set(K.Constants.celcius, forKey: K.Constants.temperature_preference)
            return self.getCelciusFrom(kelvin: kelvin)
        }
        if tempPreference == K.Constants.celcius {
            return self.getCelciusFrom(kelvin: kelvin)
        } else {
            return self.getFahrenheitFrom(kelvin: kelvin)
        }
    }
    
    func getCelciusFrom(kelvin: Double) -> Double {
        return kelvin - 273.15
    }
    
    func getFahrenheitFrom(kelvin: Double) -> Double {
        return ((kelvin - 273.15) * (9/5)) + 32
    }
    
    //IBAction Start
    
    
    @IBAction func celciusBtnClicked(_ sender: Any) {
        UserDefaults.standard.set(K.Constants.celcius, forKey: K.Constants.temperature_preference)
        self.setDataOnView()
    }
    
    @IBAction func fahrenheitBtnClicked(_ sender: Any) {
        UserDefaults.standard.set(K.Constants.fahrenheit, forKey: K.Constants.temperature_preference)
        self.setDataOnView()
    }
    
    @IBAction func restaurantsBtnClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantsViewController") as! RestaurantsViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //IBAction End

}


extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let val = self.forecastWeatherData {
            return val.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ForecastItemCollectionViewCell
        
        let item = self.forecastWeatherData![indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE"
        
        cell.dayLabel.text = dayFormatter.string(from: formatter.date(from: item.dateText!)!)
        cell.maxTempLabel.text = String.init(format: "%d °", Int(self.getConvertedTemperatureFrom(kelvin: (item.main?.maxTemp)!)))
        cell.minTempLabel.text = String.init(format: "%d °", Int(self.getConvertedTemperatureFrom(kelvin: (item.main?.minTemp)!)))
        
        cell.weatherImage.sd_setImage(with: URL.init(string: K.ProductionServer.weatherImageUrl + item.weather![0].icon! + ".png"), completed: nil)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width / 5, height: collectionView.frame.size.height)
    }
    
}
