//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = ""
    /***Get your own App ID at https://openweathermap.org/appid ****/
    

    //TODO: Declare instance variables here
    var locationManager = CLLocationManager()
    var weatherDataModelObj = WeatherDataModel()

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(parameters: [String : String]){
        Alamofire.request(WEATHER_URL, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success!")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
                
            } else{
                print("Error: \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json : JSON) {
        if let tempResult = json["main"]["temp"].double {
            weatherDataModelObj.tempFahrenheit = kelvinToFahrenheit(kelvin: tempResult)
            weatherDataModelObj.city = json["name"].stringValue
            weatherDataModelObj.condition = json["weather"][0]["id"].intValue
            weatherDataModelObj.weatherIconName = weatherDataModelObj.updateWeatherIcon(condition: weatherDataModelObj.condition)
            
            updateUIWithWeatherData()
        }else{
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData(){
        cityLabel.text = weatherDataModelObj.city
        temperatureLabel.text = String(weatherDataModelObj.tempFahrenheit) + "°F"
        weatherIcon.image = UIImage(named: weatherDataModelObj.weatherIconName)
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[locations.count - 1]
        
        // If we obtain a valid result
        if currentLocation.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            print(currentLocation.coordinate)
            let latitute = currentLocation.coordinate.latitude
            let longitude = currentLocation.coordinate.longitude
            let params: [String:String] = ["lat": String(latitute),
                                           "lon": String(longitude),
                                           "appid": APP_ID]
            
            getWeatherData(parameters: params)
            
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
        cityLabel.text = "Location Unavailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredCityName(cityName: String){
        print(cityName)
        
        let params: [String:String] = ["q": cityName,
                                       "appid": APP_ID]
        
        getWeatherData(parameters: params)
    }

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "changeCityName") {
            let destination = segue.destination as! ChangeCityViewController
            
            destination.delegate = self
        }
    }
    
    func kelvinToFahrenheit(kelvin: Double) -> Int {
        return Int((kelvin - 273.15) * (9/5) + 32)
    }
}


