//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 04/02/2022.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var myCityStackView: UIStackView!
    @IBOutlet weak var researchCityStackView: UIStackView!
    @IBOutlet weak var myCityLabel: UILabel!
    @IBOutlet weak var myTempLabel: UILabel!
    @IBOutlet weak var myDetailLabel: UILabel!
    @IBOutlet weak var myCityMinTempLabel: UILabel!
    @IBOutlet weak var myCityMaxTempLabel: UILabel!
    @IBOutlet weak var myWeatherIcon: UIImageView!
    @IBOutlet weak var researchCityLabel: UILabel!
    @IBOutlet weak var researchTempLabel: UILabel!
    @IBOutlet weak var researchDetailLabel: UILabel!
    @IBOutlet weak var researchCityMinTempLabel: UILabel!
    @IBOutlet weak var researchCityMaxTempLabel: UILabel!
    @IBOutlet weak var researchWeatherIcon: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var weatherDetails: [String: WeatherModel] = [:]

    // MARK: - viewDidLoad & viewWillAppear
    override func viewDidLoad() {
        super.viewDidLoad()
        myCityLabel.text = MyCities.myCity
        myCityStackView.layer.cornerRadius = 10
        researchCityLabel.text = MyCities.myTravelCity
        researchCityStackView.layer.cornerRadius = 10
        activityIndicator.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
            self.myCityLabel.text = MyCities.myCity
            self.researchCityLabel.text = MyCities.myTravelCity
            getMyWeather()
    }
    
    // MARK: - IBAction
    @IBAction func editMyCity(_ sender: Any) {
        self.performSegue(withIdentifier: "myCity", sender: self)
    }
    @IBAction func editMyTravelCity(_ sender: Any) {
        self.performSegue(withIdentifier: "myTravelCity", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if (segue.identifier == "myCity") {
         if let destination = segue.destination as? CityViewController {
             destination.buttonTag = 1
     }
     if (segue.identifier == "myTravelCity") {
         if let destination = segue.destination as? CityViewController {
             destination.buttonTag = 2
     }
    }}}
    
    
    // MARK: - Request API
    private func getMyWeather() {
        activityIndicator.isHidden = false
        
        NetWorker.shared.query(API: .weather, input: createParameters(city: myCityLabel.text!)) { [self] (success, weather) in
            if success, let weather = weather as? WeatherModel {
                self.activityIndicator.isHidden = true
                weatherDetails[myCityLabel.text!] = weather
                getResearchWeather()
            } else {
                self.activityIndicator.isHidden = true
                self.presentAlert(alert: LeBaluchonAlertVC.weatherErrorNetwork)
            }
        }
    }
    
    private func getResearchWeather(){
        
        NetWorker.shared.query(API: .weather, input: createParameters(city: researchCityLabel.text!)) { [self] (success, weather) in
            if success, let weather = weather as? WeatherModel {
                weatherDetails[researchCityLabel.text!] = weather
                update()
            } else {
                self.presentAlert(alert: LeBaluchonAlertVC.weatherErrorNetwork)
            }
        }
    }
    
    // MARK: - setUp UI with response
    private func update() {
        let myWeather = weatherDetails[myCityLabel.text!]!
        let researchWeather = weatherDetails[researchCityLabel.text!]!
        var myTemp = myWeather.main.temp
        var myTempMin = myWeather.main.temp_min
        var myTempMax = myWeather.main.temp_max
        var researchTemp = researchWeather.main.temp
        var researchTempMin = researchWeather.main.temp_min
        var researchTempMax = researchWeather.main.temp_max

        // Round the temp
        myTemp = Double(round(10*myTemp/10))
        researchTemp = Double(round(10*researchTemp/10))
        myTempMin = Double(round(10*myTempMin/10))
        researchTempMin = Double(round(10*researchTempMin/10))
        myTempMax = Double(round(10*myTempMax/10))
        researchTempMax = Double(round(10*researchTempMax/10))

        // Update UI
        self.myTempLabel.text! = String(myTemp) + "°"
        self.myDetailLabel.text! = myWeather.weather[0].description.capitalizingFirstLetter()
        self.myWeatherIcon.image = self.setImage(for: myWeather.weather[0])
        self.myCityMinTempLabel.text! = "Min: " + String(myTempMin) + "°"
        self.myCityMaxTempLabel.text! = "Max: " + String(myTempMax) + "°"
        self.researchTempLabel.text! = String(researchTemp) + "°"
        self.researchDetailLabel.text! = researchWeather.weather[0].description.capitalizingFirstLetter()
        self.researchWeatherIcon.image = self.setImage(for: researchWeather.weather[0])
        self.researchCityMinTempLabel.text! = "Min: " + String(researchTempMin) + "°"
        self.researchCityMaxTempLabel.text! = "Max: " + String(researchTempMax) + "°"
    }
    
    private func createParameters(city:String) -> String {
        let completeParameters = WeatherAPI.city + city
        
        return completeParameters
    }
    
    // Set image for weather description
    private func setImage(for weatherElement: WeatherElement) -> UIImage {
        let main = weatherElement.main

         if main.contains("Clear") {
            return #imageLiteral(resourceName: "Sun")
        } else if main.contains("Clouds") {
            return #imageLiteral(resourceName: "Clouds")
        } else if main.contains("Rain") {
            return #imageLiteral(resourceName: "Rain")
        } else if main.contains("Thunderstorm") {
            return #imageLiteral(resourceName: "Thunderstorm")
        } else if main.contains("Snow") {
            return #imageLiteral(resourceName: "Snow")
        } else if main.contains("Mist") {
            return #imageLiteral(resourceName: "Drizzle")
        }
        return #imageLiteral(resourceName: "Few clouds")
    }
}
