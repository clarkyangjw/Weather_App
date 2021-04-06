//
//  WeatherFetcher.swift
//  Jiawei_Weather
//
//  Created by Clark on 2021-04-03.
//
//Jiawei Yang
//121134183

import Foundation
class WeatherFetcher : ObservableObject{
    var apiURL = "https://api.weatherapi.com/v1/current.json"
    var apiKey = "4fbb7d851ff14b148f4184303210304"

    @Published var weather = Weather()

    //singleton instance
    private static var shared : WeatherFetcher?

    static func getInstance() -> WeatherFetcher{
        if shared != nil{
            //instance already exists
            return shared!
        }else{
            // create a new singlton instance
            return WeatherFetcher()
        }
    }

    func fetchDataFromAPI(location : String){
        let fetchString = "\(apiURL)?key=\(apiKey)&q=\(location)&aqi=no"

        guard let api = URL(string: fetchString) else{
            return
        }

        URLSession.shared.dataTask(with: api){ (data: Data?, respone: URLResponse?, error: Error?) in
            if let err = error{
                print(#function, "Couldn't fetch data" , err)
            }else{
                //received data or resopnse
                DispatchQueue.global().async {
                    do{
                        if let jsonData = data{
                            let decoder = JSONDecoder()
                            let decodedList = try decoder.decode(Weather.self, from: jsonData)

                            DispatchQueue.main.async {
                                self.weather = decodedList
                            }

                        }else{
                            print(#function, "No JSON data received")
                        }
                    }catch let error{
                        print(#function, error)
                    }
                }
            }
        }.resume()
    }
}
