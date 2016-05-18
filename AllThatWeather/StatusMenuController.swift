//
//  StatusMenuController.swift
//  AllThatWeahter
//
//  Created by JANGGIWON on May 17, 2016.
//  Copyright © 2016 Handicraft. All rights reserved.
//

import Cocoa

let DEFAULT_CITY = "Seoul, Korea"

class StatusMenuController: NSObject, PreferencesWindowDelegate {//, WeatherAPIDelegate {
	@IBOutlet weak var statusMenu: NSMenu!
	@IBOutlet weak var weatherView: WeatherView!
	var weatherMenuItem: NSMenuItem!
	var preferencesWindow: PreferencesWindow!
	
	let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
	var weatherAPI: WeatherAPI!
	
	var refreshTimer: NSTimer!
	
	deinit {
		NSLog("StatusMenuController.deinit called.")
		refreshTimer?.invalidate()
	}
	
	override func awakeFromNib() {
		let icon = NSImage(named: "statusIcon")
		icon?.template = true
		statusItem.image = icon
		statusItem.menu = statusMenu
		
		//weatherAPI = WeatherAPI(delegate: self)
		weatherAPI = WeatherAPI()
		
		weatherMenuItem = statusMenu.itemWithTitle("Weather")
		weatherMenuItem.view = weatherView
		
		preferencesWindow = PreferencesWindow()
		preferencesWindow.delegate = self
		
		updateWeather()
		startRefreshTimer()
	}
	
	func startRefreshTimer() {
		refreshTimer = NSTimer.scheduledTimerWithTimeInterval(
			1.0 * 60,
			target: self,
			selector: #selector(StatusMenuController.updateWeather),
			userInfo: nil,
			repeats: true
		)
		NSRunLoop.mainRunLoop().addTimer(refreshTimer, forMode: NSRunLoopCommonModes)
	}
	
	func stopRefreshTimer() {
		refreshTimer?.invalidate()
	}
	
	func updateWeather() {
		let defaults = NSUserDefaults.standardUserDefaults()
		let city = defaults.stringForKey("city") ?? DEFAULT_CITY
		weatherAPI.fetchWeather(city) { weather in
			self.weatherView.update(weather)
            //self.statusItem.button!.image = NSImage(named: weather.icon)
            //self.statusItem.button!.title = String(weather.currentTempInCelsius)
		}
	}
	
	@IBAction func quitClicked(sender: NSMenuItem) {
		NSApplication.sharedApplication().terminate(self)
	}
	
	@IBAction func updateClicked(sender: NSMenuItem) {
		updateWeather()
	}
	
	/*func weatherDidUpdate(weather: Weather) {
		NSLog(weather.description)
	}*/

	@IBAction func preferencesClicked(sender: NSMenuItem) {
		preferencesWindow.showWindow(nil)
	}
	
	func preferencesDidUpdate() {
		updateWeather()
	}
}
