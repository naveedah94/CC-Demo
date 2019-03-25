//
//  APIClient.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/24/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
    static func getCurrentWeather(lat: String, lng: String, completion: @escaping(Result<CurrentWeatherModel>) -> Void) {
        let parameters = [K.APIParameterKey.lat:lat,
                          K.APIParameterKey.lng:lng,
                          K.APIParameterKey.appid:K.Constants.open_weather_map_api_key]
        
        AF.request(K.ProductionServer.weatherBaseURL + K.EndPoints.WEATHER, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseDecodable { (response: DataResponse<CurrentWeatherModel>) in
            completion(response.result)
        }
    }
    
    static func getWeatherForecast(lat: String, lng: String, completion: @escaping(Result<ForecastWeatherModel>) -> Void) {
        let parameters = [K.APIParameterKey.lat:lat,
                          K.APIParameterKey.lng:lng,
                          K.APIParameterKey.appid:K.Constants.open_weather_map_api_key]
        
        AF.request(K.ProductionServer.weatherBaseURL + K.EndPoints.FORECAST, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseDecodable { (response: DataResponse<ForecastWeatherModel>) in
            completion(response.result)
        }
    }
    
    static func getVenuesNearBy(lat: String, lng: String, versionApi: String, categoryID: String, completion: @escaping(Result<NearByRestaurantsModel>) -> Void) {
        
        let parameters = [K.APIParameterKey.client_id:K.Constants.four_square_client_id,
                          K.APIParameterKey.client_secret:K.Constants.four_square_client_secret,
                          K.APIParameterKey.lat_lng:lat + "," + lng,
                          K.APIParameterKey.api_version:versionApi]
        
        AF.request(K.ProductionServer.restaurantsBaseURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseDecodable { (response: DataResponse<NearByRestaurantsModel>) in
            completion(response.result)
        }
    }
}
