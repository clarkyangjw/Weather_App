//
//  Weather.swift
//  Jiawei_Weather
//
//  Created by Clark on 2021-04-03.
//
//Jiawei Yang
//121134183

import Foundation

struct Weather : Codable {

    var locationName : String

    var currentTemp_c : Double
    var currentFeelslike_c : Double
    var currentWind_kph : Double
    var currentWind_dir : String
    var currentUV : Double
    var currentHumidity : Int
    var currentLast_updated : String
    
    var currentConditionText : String
    var currentConditionIcon : String


    init(){
        self.locationName = ""

        self.currentTemp_c = 0.0
        self.currentFeelslike_c = 0.0
        self.currentWind_kph = 0.0
        self.currentWind_dir = ""
        self.currentUV = 0.0
        self.currentHumidity = 0
        self.currentLast_updated = ""
        self.currentConditionText = ""
        self.currentConditionIcon = ""
    }

    enum CodingKeys : String, CodingKey{
        case location = "location"
        case locationName = "name"

        case current = "current"
        case currentTemp_c = "temp_c"
        case currentFeelslike_c = "feelslike_c"
        case currentWind_kph = "wind_kph"
        case currentWind_dir = "wind_dir"
        case currentUV = "uv"
        case currentHumidity = "humidity"
        case currentLast_updated = "last_updated"
        
        //case currentCondition = "condition"
        case currentConditionText = "text"
        case currentConditionIcon = "icon"

    }

    func encode(to encoder: Encoder) throws {
        //nothing to encode
    }

    init(from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: CodingKeys.self)

        let locationContainer = try response.decodeIfPresent(Location.self, forKey: .location)
        self.locationName = locationContainer?.name ?? "Unavailable"

        let currentContainer = try response.decodeIfPresent(Current.self, forKey: .current)
        self.currentTemp_c = currentContainer?.tempe_c ?? 0.0
        self.currentFeelslike_c = currentContainer?.feelslike_c ?? 0.0
        self.currentWind_kph = currentContainer?.wind_kph ?? 0.0
        self.currentWind_dir = currentContainer?.wind_dir ?? "Unavailable"
        self.currentUV = currentContainer?.uv ?? 0.0
        self.currentHumidity = currentContainer?.humidity ?? 0
        self.currentLast_updated = currentContainer?.last_updated ?? "Unavailable"
        
        self.currentConditionText = currentContainer?.text ?? "Unavailable"
        self.currentConditionIcon = currentContainer?.icon ?? "Unavailable"

    }

}

struct Location : Codable{
    let name : String
    //let country : String
    
    init(from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try response.decodeIfPresent(String.self, forKey: .name) ?? "Unavailable"
        //self.country = try response.decodeIfPresent(String.self, forKey: .country) ?? "Unavailable"
    }

    enum CodingKeys: String, CodingKey {
        case name = "name"
        //case country = "country"
    }

    func encode(to encoder: Encoder) throws {
        //nothing to encode
    }
}

struct Current : Codable{
    let tempe_c : Double
    let feelslike_c : Double
    let wind_kph : Double
    let wind_dir : String
    let uv : Double
    let humidity : Int
    let last_updated : String
    
    let text : String
    let icon : String


    init(from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: CodingKeys.self)

        self.tempe_c = try response.decodeIfPresent(Double.self, forKey: .tempe_c) ?? 0.0
        self.feelslike_c = try response.decodeIfPresent(Double.self, forKey: .feelslike_c) ?? 0.0
        self.wind_kph = try response.decodeIfPresent(Double.self, forKey: .wind_kph) ?? 0.0
        self.wind_dir = try response.decodeIfPresent(String.self, forKey: .wind_dir) ?? "Unavailable"
        self.uv = try response.decodeIfPresent(Double.self, forKey: .uv) ?? 0.0
        self.humidity = try response.decodeIfPresent(Int.self, forKey: .humidity) ?? 0
        self.last_updated = try response.decodeIfPresent(String.self, forKey: .last_updated) ?? "Unavailable"
        
        let conditionContainer = try response.decodeIfPresent(Condition.self, forKey: .condition)
    
        self.text = conditionContainer?.text ?? "Unavailable"
        self.icon = conditionContainer?.icon ?? "Unavailable"

    }

    enum CodingKeys: String, CodingKey {
        case tempe_c = "temp_c"
        case feelslike_c = "feelslike_c"
        case wind_kph = "wind_kph"
        case wind_dir = "wind_dir"
        case uv = "uv"
        case humidity = "humidity"
        case last_updated = "last_updated"
        
        case condition = "condition"
        case conditionText = "text"
        case conditionIcon = "icon"

    }


    func encode(to encoder: Encoder) throws {
        //nothing to encode
    }
}


struct Condition : Codable{
    let text : String
    let icon : String

    init(){
        self.text = ""
        self.icon = ""
    }
    
    init(from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try response.decodeIfPresent(String.self, forKey: .text) ?? "Unavailable"
        self.icon = try response.decodeIfPresent(String.self, forKey: .icon) ?? "Unavailable"
    }

    enum CodingKeys: String, CodingKey {
        case text = "text"
        case icon = "icon"
    }

    func encode(to encoder: Encoder) throws {
        //nothing to encode
    }
}
