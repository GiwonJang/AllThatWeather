//
//  WeatherView.swift
//  AllThatWeahter
//
//  Created by JANGGIWON on May 17, 2016.
//  Copyright © 2016 Handicraft. All rights reserved.
//

import Cocoa

class WeatherView: NSView {
	
	@IBOutlet weak var imageView: NSImageView!
	@IBOutlet weak var cityTextField: NSTextField!
	@IBOutlet weak var currentConditionsTextField: NSTextField!

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
	
	func update(_ weather: Weather) {
		DispatchQueue.main.async {
			NSLog("\(weather.description)")
			self.cityTextField.stringValue = weather.city
			self.currentConditionsTextField.stringValue = "\(weather.currentTempInCelsius)°C and \(weather.conditions)"
			self.imageView.image = NSImage(named: weather.icon)
		}
	}
    
}
