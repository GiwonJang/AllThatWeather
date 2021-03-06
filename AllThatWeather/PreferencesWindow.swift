//
//  PreferencesWindow.swift
//  AllThatWeahter
//
//  Created by JANGGIWON on May 17, 2016.
//  Copyright © 2016 Handicraft. All rights reserved.
//

import Cocoa

protocol PreferencesWindowDelegate {
	func preferencesDidUpdate()
}

class PreferencesWindow: NSWindowController, NSWindowDelegate {

	@IBOutlet weak var cityTextField: NSTextField!
	
	var delegate: PreferencesWindowDelegate?
	
	override var windowNibName: String! {
		return "PreferencesWindow"
	}
	
    override func windowDidLoad() {
        super.windowDidLoad()

		self.window?.center()
		self.window?.makeKeyAndOrderFront(nil)
		NSApp.activate(ignoringOtherApps: true)
    }
	
	func windowWillClose(_ notification: Notification) {
		let defaults = UserDefaults.standard
		defaults.setValue(cityTextField.stringValue, forKey: "city")
		
		delegate?.preferencesDidUpdate()
	}
	
}
