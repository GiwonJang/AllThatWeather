//
//  WeatherAPI.swift
//  WeahterBar
//
//  Created by JANGGIWON on May 17, 2016.
//  Copyright © 2016 Handicraft. All rights reserved.
//

import Foundation

struct Weather: CustomStringConvertible {
	var city: String
	var currentTemp: Float
	var currentTempInCelsius: Float
	var conditions: String
	var icon: String
	
	var description: String {
		return "\(city): \(currentTempInCelsius)C and \(conditions)"
	}
}

protocol WeatherAPIDelegate {
	func weatherDidUpdate(weather: Weather)
}

class WeatherAPI {
	let API_KEY = "c88b71053c56e296798fe19278b268a8"
	let BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
	var delegate: WeatherAPIDelegate?
	
	/*init(delegate: WeatherAPIDelegate) {
		self.delegate = delegate
	}*/
	
	func fetchWeather(query: String, success: (Weather) -> Void) {
		let session = NSURLSession.sharedSession()
		// url-escape the query string we're passed
		let escapedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
		let url = NSURL(string: "\(BASE_URL)?APPID=\(API_KEY)&units=imperial&q=\(escapedQuery!)")
		let task = session.dataTaskWithURL(url!) { data, response, err in
			// first check for a hard error
			if let error = err {
				NSLog("weather api error: \(error)")
			}
			
			// then check the response code
			if let httpResponse = response as? NSHTTPURLResponse {
				switch httpResponse.statusCode {
				case 200: // all good!
					/*let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
					NSLog(dataString)*/
					/*if let weather = self.weatherFromJSONData(data!) {
						NSLog("\(weather)")
					}*/
					/*if let weather = self.weatherFromJSONData(data!) {
						self.delegate?.weatherDidUpdate(weather)
					}*/
					if let weather = self.weatherFromJSONData(data!) {
						success(weather)
					}
				case 401: // unauthorized
					NSLog("weather api returned an 'unauthorized' response. Did you set your API key?")
				default:
					NSLog("weather api returned response: %d %@", httpResponse.statusCode, NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode))
				}
			}
		}
		task.resume()
	}
	
	func weatherFromJSONData(data: NSData) -> Weather? {
		typealias JSONDict = [String:AnyObject]
		let json: JSONDict
		
		do {
			json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! JSONDict
		} catch {
			NSLog("JSON parsing failed: \(error)")
			return nil
		}
		
		var mainDict = json["main"] as! JSONDict
		var weatherList = json["weather"] as! [JSONDict]
		var weatherDict = weatherList[0]
		
		let currentTempInCelsius = Float(round(convertFahrenheitToCelsius(mainDict["temp"] as! Float) * 10) / 10)
		
		let weather = Weather(
			city: json["name"] as! String,
			currentTemp: mainDict["temp"] as! Float,
			currentTempInCelsius: currentTempInCelsius,
			conditions: weatherDict["main"] as! String,
			icon: weatherDict["icon"] as! String
		)
		
		return weather
	}
	
	func convertFahrenheitToCelsius(fahrenheitTempature: Float) -> Float {
		return ((fahrenheitTempature - 32.0) / 1.8)
	}
}