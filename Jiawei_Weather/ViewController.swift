//
//  ViewController.swift
//  Jiawei_Weather
//
//  Created by Clark on 2021-04-04.
//
//Jiawei Yang
//121134183

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet var pkrLocation : UIPickerView!
    @IBOutlet var lblTemp_c : UILabel!
    @IBOutlet var lblFeelslike_c: UILabel!
    @IBOutlet var lblWind_kph : UILabel!
    @IBOutlet var lblWind_dir : UILabel!
    @IBOutlet var lblUV : UILabel!
    @IBOutlet var lblHumidity : UILabel!
    @IBOutlet var lblLast_updated : UILabel!
    @IBOutlet var lblText : UILabel!
    //@IBOutlet var lblIcon : UILabel!
    @IBOutlet weak var imgSymbo : UIImageView!
    
    private var selectedCity : String = "Toronto"


    let locationList = ["Toronto", "London", "Montreal", "Berlin", "Moscow", "Beijing", "Mumbai", "Vancouver", "Winnipeg", "Calgary"]
    
    private let weatherFetcher = WeatherFetcher.getInstance()
    private var weather : Weather = Weather()
    private var cancellables: Set<AnyCancellable> = []

    var firstInitial : Bool = true
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)
        
        self.pkrLocation.dataSource = self
        self.pkrLocation.delegate = self
        
        if(firstInitial){
            self.weatherFetcher.fetchDataFromAPI(location: selectedCity)
            self.receiveChanges()
            self.firstInitial = false
        }

    }

    private func receiveChanges(){
        self.weatherFetcher.$weather.receive(on: RunLoop.main)
            .sink{ (weather) in
                //print(#function, "Received weather : ", weather)
                self.weather = weather
                self.displayChange()
                self.viewDidLoad()
            }
            .store(in : &cancellables)

    }

    func displayChange(){
        self.lblTemp_c.text = "\(self.weather.currentTemp_c) °C"
        self.lblFeelslike_c.text = "\(self.weather.currentFeelslike_c) °C"
        self.lblWind_kph.text = "\(self.weather.currentWind_kph) kph"
         
        switch self.weather.currentWind_dir {
        case "N":
            self.lblWind_dir.text = "North"
        case "NE":
            self.lblWind_dir.text = "North-East"
        case "E":
            self.lblWind_dir.text = "East"
        case "SE":
            self.lblWind_dir.text = "South-East"
        case "S":
            self.lblWind_dir.text = "South"
        case "SW":
            self.lblWind_dir.text = "South-West"
        case "W":
            self.lblWind_dir.text = "West"
        case "NW":
            self.lblWind_dir.text = "North-West"
        default:
            self.lblWind_dir.text = " "
        }
        self.lblUV.text = (self.weather.currentUV as NSNumber).stringValue
        self.lblHumidity.text = (self.weather.currentHumidity as NSNumber).stringValue
        self.lblLast_updated.text = self.weather.currentLast_updated
        if(self.weather.currentConditionText != ""){
            self.lblText.text = self.weather.currentConditionText
            displayImgIcon(conditionIcon: self.weather.currentConditionText)
        }
        else{
            self.lblText.text = " "
        }
        

    }
    
    // Display imgIcon
        func displayImgIcon(conditionIcon: String) {
            switch conditionIcon {
            case "Sunny", "Clear":
                self.imgSymbo.image = UIImage(systemName: "sun.max.fill")
            
            case "Cloudy", "Partly cloudy", "Overcast":
                self.imgSymbo.image = UIImage(systemName: "cloud.sun.fill")

            case "Mist", "Fog", "Freezing fog":
                self.imgSymbo.image = UIImage(systemName: "cloud.fog.fill")
                
            case "Patchy rain possible", "Patchy light rain", "Light rain", "Moderate rain at times", "Moderate rain", "Heavy rain at times", "Heavy rain", "Light freezing rain", "Moderate or heavy freezing rain", "Light rain shower", "Moderate or heavy rain shower", "Torrential rain shower":
                self.imgSymbo.image = UIImage(systemName: "cloud.rain.fill")
            
            case "Patchy freezing drizzle possible", "Patchy light drizzle", "Light drizzle", "Freezing drizzle", "Heavy freezing drizzle":
                self.imgSymbo.image = UIImage(systemName: "cloud.drizzle.fill")
                
            case "Patchy snow possible", "Blowing snow", "Blizzard", "Patchy light snow", "Light snow", "Patchy moderate snow", "Moderate snow", "Patchy heavy snow", "Heavy snow", "Light snow showers", "Moderate or heavy snow showers":
                self.imgSymbo.image = UIImage(systemName: "snow")
            
            case "Patchy sleet possible", "Light sleet", "Moderate or heavy sleet", "Ice pellets", "Light sleet showers", "Moderate or heavy sleet showers", "Light showers of ice pellets", "Moderate or heavy showers of ice pellets":
                self.imgSymbo.image = UIImage(systemName: "cloud.sleet.fill")
            
            case "Thundery outbreaks possible", "Patchy light rain with thunder", "Moderate or heavy rain with thunder", "Patchy light snow with thunder", "Moderate or heavy snow with thunder":
                self.imgSymbo.image = UIImage(systemName: "cloud.bolt.rain.fill")
                
            default:
                self.imgSymbo.isHidden = false
            }
        }

}



extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.locationList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.locationList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCity = self.locationList[row]
        self.weatherFetcher.fetchDataFromAPI(location: selectedCity)
        self.receiveChanges()
    }
}
