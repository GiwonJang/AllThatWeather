//
//  WeatherView.swift
//  WeahterBar
//
//  Created by JANGGIWON on May 17, 2016.
//  Copyright © 2016 Handicraft. All rights reserved.
//

import Cocoa

class WeatherView: NSView {
	
	@IBOutlet weak var imageView: NSImageView!
	@IBOutlet weak var cityTextField: NSTextField!
	@IBOutlet weak var currentConditionsTextField: NSTextField!

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
	
	func update(weather: Weather) {
		dispatch_async(dispatch_get_main_queue()) {
			NSLog("\(weather.description)")
			self.cityTextField.stringValue = weather.city
			self.currentConditionsTextField.stringValue = "\(weather.currentTempInCelsius)°C and \(weather.conditions)"
			self.imageView.image = NSImage(named: weather.icon)
		}
	}
    
}
