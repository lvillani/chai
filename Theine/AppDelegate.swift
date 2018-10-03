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
import os

let oneHour = TimeInterval(3600) // Seconds

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    // Globals
    let defaults = Defaults()
    let store = Store()

    var powerAssertion: PowerAssertion?
    var timer: Timer?

    // UI
    let iconOff = NSImage(imageLiteralResourceName: "Mug-Empty")
    let iconOn = NSImage(imageLiteralResourceName: "Mug")
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let statusMenu = NSMenu(title: "Theine")

    let headerItem = NSMenuItem(title: "Keep This Mac Awake", action: nil, keyEquivalent: "")
    let launchAtLoginItem = NSMenuItem(title: "Launch at Login", action: #selector(launchAtLoginAction), keyEquivalent: "")

    // Activation timers
    let activationSpecs: [(String, TimeInterval, String)] = [
        ("Forever", 0, "0"),
        ("30 Minutes", oneHour / 2, ""),
        ("1 Hour", oneHour, "1"),
        ("2 Hours", 2 * oneHour, "2"),
        ("4 Hours", 4 * oneHour, "4"),
        ("8 Hours", 8 * oneHour, "8"),
    ]

    var activationItems: [TEMenuItem] = []

    func applicationDidFinishLaunching(_: Notification) {
        initUi()
    }

    func initUi() {
        iconOff.isTemplate = true
        iconOn.isTemplate = true

        headerItem.isEnabled = false

        statusItem.menu = statusMenu

        statusMenu.addItem(headerItem)
        initMenuItems()

        statusMenu.addItem(NSMenuItem.separator())
        statusMenu.addItem(launchAtLoginItem)
        statusMenu.addItem(withTitle: "Quit Theine", action: #selector(quitAction), keyEquivalent: "q")

        updateUi()
    }

    func initMenuItems() {
        for itemSpec in activationSpecs {
            let item = TEMenuItem(title: itemSpec.0, action: #selector(activateAction(sender:)), keyEquivalent: itemSpec.2)
            item.timerDuration = itemSpec.1

            activationItems.append(item)
            statusMenu.addItem(item)
        }
    }

    @objc func activateAction(sender: TEMenuItem) {
        var newActivationState = !store.active
        if store.activeItem != sender {
            newActivationState = true
        }

        deactivate()
        if !newActivationState {
            return
        }

        store.active = true
        store.activeItem = sender

        powerAssertion = PowerAssertion(named: "Brewing Green Tea")

        if sender.timerDuration > 0 {
            os_log("Scheduling deactivation in %f seconds", sender.timerDuration)
            timer = Timer.scheduledTimer(withTimeInterval: sender.timerDuration, repeats: false, block: { (_) in
                self.deactivate()
            })
        }

        updateUi()

        os_log("Activated")
    }

    func deactivate() {
        if let _ = powerAssertion {
            powerAssertion = nil
        }

        if let t = timer {
            t.invalidate()
            timer = nil
        }

        store.active = false
        store.activeItem = nil
        updateUi()

        os_log("Deactivated")
    }

    func updateUi() {
        for item in activationItems {
            item.state = .off
        }

        if store.active {
            statusItem.image = iconOn
            store.activeItem?.state = .on
        } else {
            statusItem.image = iconOff
        }

        launchAtLoginItem.state = defaults.loginItemEnabled ? .on : .off
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

        os_log("Launch at login: %{public}s", newState ? "enabled" : "disabled")
        defaults.loginItemEnabled = newState

        updateUi()
    }

    @objc func quitAction() {
        NSRunningApplication.current.terminate()
    }
}
