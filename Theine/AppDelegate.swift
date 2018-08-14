// Theine - Don't let your Mac fall asleep, like a sir
// Copyright (C) 2018 Lorenzo Villani
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var iconOff: NSImage!
    var iconOn: NSImage!
    var statusItem: NSStatusItem!
    var powerAssertion: PowerAssertion!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        iconOff = NSImage(named: NSImage.Name(rawValue: "Mug-Empty"))
        iconOff.isTemplate = true

        iconOn = NSImage(named: NSImage.Name(rawValue: "Mug"))
        iconOn.isTemplate = true

        statusItem = NSStatusBar.system.statusItem(withLength: -2)
        statusItem.highlightMode = true
        statusItem.image = iconOff
        statusItem.action = #selector(AppDelegate.togglePowerAssertion)
    }

    @objc func togglePowerAssertion() {
        if statusItem.image == iconOff {
            // Grab power assertion
            powerAssertion = PowerAssertion(named: "Brewing Green Tea")
            statusItem.image = iconOn
        } else {
            // Release power assertion
            powerAssertion = nil
            statusItem.image = iconOff
        }
    }
}
