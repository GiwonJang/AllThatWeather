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
	
	let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
	var weatherAPI: WeatherAPI!
	
	var refreshTimer: Timer!
	
	deinit {
		NSLog("StatusMenuController.deinit called.")
		refreshTimer?.invalidate()
	}
	
	override func awakeFromNib() {
		let icon = NSImage(named: "statusIcon")
		icon?.isTemplate = true
		statusItem.image = icon
		statusItem.menu = statusMenu
		
		//weatherAPI = WeatherAPI(delegate: self)
		weatherAPI = WeatherAPI()
		
		weatherMenuItem = statusMenu.item(withTitle: "Weather")
		weatherMenuItem.view = weatherView
		
		preferencesWindow = PreferencesWindow()
		preferencesWindow.delegate = self
		
		updateWeather()
		startRefreshTimer()
	}
	
	func startRefreshTimer() {
		refreshTimer = Timer.scheduledTimer(
			timeInterval: 1.0 * 60,
			target: self,
			selector: #selector(StatusMenuController.updateWeather),
			userInfo: nil,
			repeats: true
		)
		RunLoop.main.add(refreshTimer, forMode: RunLoopMode.commonModes)
	}
	
	func stopRefreshTimer() {
		refreshTimer?.invalidate()
	}
	
	func updateWeather() {
		let defaults = UserDefaults.standard
		let city = defaults.string(forKey: "city") ?? DEFAULT_CITY
		weatherAPI.fetchWeather(city) { weather in
			self.weatherView.update(weather)
            //self.statusItem.button!.image = NSImage(named: weather.icon)
            //self.statusItem.button!.title = String(weather.currentTempInCelsius)
		}
	}
	
	@IBAction func quitClicked(_ sender: NSMenuItem) {
		NSApplication.shared().terminate(self)
	}
	
	@IBAction func updateClicked(_ sender: NSMenuItem) {
		updateWeather()
	}
	
	/*func weatherDidUpdate(weather: Weather) {
		NSLog(weather.description)
	}*/

	@IBAction func preferencesClicked(_ sender: NSMenuItem) {
		preferencesWindow.showWindow(nil)
	}
	
	func preferencesDidUpdate() {
		updateWeather()
	}
}
