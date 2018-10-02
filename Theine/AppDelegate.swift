// Theine - Don't let your Mac fall asleep, like a sir
// Copyright (C) 2018 Lorenzo Villani
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 3 of the License.
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

    let iconOff = NSImage(imageLiteralResourceName: "Mug-Empty")
    let iconOn = NSImage(imageLiteralResourceName: "Mug")
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let statusMenu = NSMenu(title: "Theine")

    let headerItem = NSMenuItem(title: "Keep This Mac Awake", action: nil, keyEquivalent: "")

    let foreverItem = NSMenuItem(title: "Forever", action: #selector(activateAction), keyEquivalent: "a")
    let launchAtLoginItem = NSMenuItem(title: "Launch at Login", action: #selector(launchAtLoginAction), keyEquivalent: "")

    var powerAssertion: PowerAssertion?

    func applicationDidFinishLaunching(_: Notification) {
        iconOff.isTemplate = true
        iconOn.isTemplate = true
        headerItem.isEnabled = false
        statusItem.image = iconOff
        statusItem.menu = statusMenu

        statusMenu.addItem(headerItem)
        statusMenu.addItem(foreverItem)
        statusMenu.addItem(NSMenuItem.separator())
        statusMenu.addItem(launchAtLoginItem)
        statusMenu.addItem(withTitle: "Quit Theine", action: #selector(quitAction), keyEquivalent: "q")
    }

    @objc func activateAction() {
        if statusItem.button?.image == iconOff {
            foreverItem.state = .on
            powerAssertion = PowerAssertion(named: "Brewing Green Tea")
            statusItem.button?.image = iconOn
        } else {
            foreverItem.state = .off
            powerAssertion = nil
            statusItem.button?.image = iconOff
        }
    }

    @objc func launchAtLoginAction() {
        let newState = !defaults.loginItemEnabled

        if !SMLoginItemSetEnabled("me.villani.lorenzo.apple.TheineHelper" as CFString, newState) {
            let alert = NSAlert()
            alert.alertStyle = .warning
            alert.messageText = "Cannot start Theine on login"
            alert.runModal()

            return
        }

        launchAtLoginItem.state = newState ? .on : .off
        defaults.loginItemEnabled = newState
    }

    @objc func quitAction() {
        NSRunningApplication.current.terminate()
    }
}
