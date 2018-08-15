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
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let defaults = Defaults()
    var powerAssertion: PowerAssertion?

    var iconOff: NSImage!
    var iconOn: NSImage!
    var statusItem: NSStatusItem!
    var statusMenu: NSMenu!
    var statusMenuLoginItem: NSMenuItem!

    func applicationDidFinishLaunching(_: Notification) {
        iconOff = NSImage(named: NSImage.Name("Mug-Empty"))
        iconOff.isTemplate = true

        iconOn = NSImage(named: NSImage.Name("Mug"))
        iconOn.isTemplate = true

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.action = #selector(statusItemClicked)
        statusItem.image = iconOff
        statusItem.sendAction(on: [.leftMouseUp, .rightMouseUp])

        statusMenuLoginItem = NSMenuItem(title: "Start on login", action: #selector(statusMenuLoginItemClicked), keyEquivalent: "")
        statusMenuLoginItem.state = defaults.loginItemEnabled ? .on : .off

        statusMenu = NSMenu(title: "Theine")
        statusMenu.addItem(statusMenuLoginItem)
    }

    @objc func statusItemClicked() {
        guard let eventType = NSApp.currentEvent?.type else {
            return
        }

        if eventType == .leftMouseUp {
            togglePowerAssertion()
        } else if eventType == .rightMouseUp {
            showMenu()
        }
    }

    func togglePowerAssertion() {
        if statusItem.button?.image == iconOff {
            powerAssertion = PowerAssertion(named: "Brewing Green Tea")
            statusItem.button?.image = iconOn
        } else {
            powerAssertion = nil
            statusItem.button?.image = iconOff
        }
    }

    func showMenu() {
        statusItem.menu = statusMenu
        statusItem.popUpMenu(statusMenu)
        statusItem.menu = nil
    }

    @objc func statusMenuLoginItemClicked() {
        let newState = !defaults.loginItemEnabled

        if !SMLoginItemSetEnabled("me.villani.lorenzo.apple.TheineHelper" as CFString, newState) {
            let alert = NSAlert()
            alert.alertStyle = .warning
            alert.messageText = "Cannot start Theine on login"
            alert.runModal()

            return
        }

        statusMenuLoginItem.state = newState ? .on : .off
        defaults.loginItemEnabled = newState
    }
}
