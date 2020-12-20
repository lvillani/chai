// Chai - Don't let your Mac fall asleep, like a sir
// Copyright (C) 2020 Lorenzo Villani
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

let oneHour = TimeInterval(3600)  // Seconds

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, StoreDelegate {
  // Globals
  static let appName =
    Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String

  var powerAssertion: PowerAssertion?
  var timer: Timer?

  // UI
  let iconOff = NSImage(imageLiteralResourceName: "Mug-Empty")
  let iconOn = NSImage(imageLiteralResourceName: "Mug")
  let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
  let statusMenu = NSMenu(title: appName)

  let headerItem = NSMenuItem(title: "Keep This Mac Awake", action: nil, keyEquivalent: "")
  let launchAtLoginItem = NSMenuItem(
    title: "Launch at Login", action: #selector(launchAtLoginAction), keyEquivalent: "")

  let preferences = NSMenuItem(title: "Preferences", action: nil, keyEquivalent: "")
  let disableAfterSuspend = NSMenuItem(
    title: "Disable After Suspend", action: #selector(disableAfterSuspendAction), keyEquivalent: "")

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

  func applicationWillTerminate(_ notification: Notification) {
    globalStore.unsubscribe(storeDelegate: self)
  }

  func applicationDidFinishLaunching(_: Notification) {
    initUi()

    registerDidWakeNotification()

    globalStore.dispatch(action: .initialize)
    globalStore.subscribe(storeDelegate: self)
  }

  func initUi() {
    iconOff.isTemplate = true
    iconOn.isTemplate = true

    headerItem.isEnabled = false

    statusItem.action = #selector(statusItemClicked)
    statusItem.sendAction(on: [.leftMouseUp, .rightMouseDown])

    // Timers
    statusMenu.addItem(headerItem)
    initMenuItems()

    // Preferences
    preferences.submenu = NSMenu(title: "Preferences")
    preferences.submenu?.addItem(disableAfterSuspend)

    statusMenu.addItem(NSMenuItem.separator())
    statusMenu.addItem(preferences)

    // Global
    statusMenu.addItem(NSMenuItem.separator())
    statusMenu.addItem(launchAtLoginItem)
    statusMenu.addItem(
      withTitle: "Quit \(AppDelegate.appName)", action: #selector(quitAction), keyEquivalent: "q")
  }

  @objc func statusItemClicked() {
    guard let eventType = NSApp.currentEvent?.type else {
      return
    }

    if eventType == .leftMouseUp {
      // HACK: item at 1 is
      activateAction(sender: statusMenu.item(at: 1) as! TEMenuItem)
    } else if eventType == .rightMouseDown {
      // HACK: This allows showing the menu on right click.
      statusItem.menu = statusMenu
      statusItem.button?.performClick(nil)
      statusItem.menu = nil  // NOTE: Must set to nil to be able to handle left clicks again
    }
  }

  func initMenuItems() {
    for itemSpec in activationSpecs {
      let item = TEMenuItem(
        title: itemSpec.0, action: #selector(activateAction(sender:)), keyEquivalent: itemSpec.2)
      item.timerDuration = itemSpec.1

      activationItems.append(item)
      statusMenu.addItem(item)
    }
  }

  func registerDidWakeNotification() {
    os_log("Registering system wakeup notification handler")

    NSWorkspace.shared.notificationCenter.addObserver(
      self,
      selector: #selector(receiveDidWakeNotification),
      name: NSWorkspace.didWakeNotification,
      object: nil
    )
  }

  @objc func receiveDidWakeNotification() {
    if !globalStore.state.isDisableAfterSuspendEnabled {
      return
    }

    os_log("System wakeup detected, disabling according to config")
    deactivate()
  }

  func stateChanged(state: State) {
    // Icon
    statusItem.image = state.active ? iconOn : iconOff

    // Timers
    for item in activationItems {
      item.state = .off
    }

    state.activeItem?.state = .on

    // Disable after suspend
    disableAfterSuspend.state = state.isDisableAfterSuspendEnabled ? .on : .off

    // Login Item
    launchAtLoginItem.state = state.isLoginItemEnabled ? .on : .off
  }

  @objc func activateAction(sender: TEMenuItem) {
    var newActivationState = !globalStore.state.active
    if globalStore.state.activeItem != sender {
      newActivationState = true
    }

    deactivate()
    if !newActivationState {
      return
    }

    powerAssertion = PowerAssertion(named: "Brewing Tea")

    if sender.timerDuration > 0 {
      os_log("Scheduling deactivation in %f seconds", sender.timerDuration)
      timer = Timer.scheduledTimer(
        withTimeInterval: sender.timerDuration, repeats: false,
        block: { (_) in
          self.deactivate()
        })
    }

    globalStore.dispatch(action: .activate(sender))
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

    globalStore.dispatch(action: .deactivate)
    os_log("Deactivated")
  }

  @objc func disableAfterSuspendAction() {
    globalStore.dispatch(
      action: .setDisableAfterSuspendEnabled(!globalStore.state.isDisableAfterSuspendEnabled))
  }

  @objc func launchAtLoginAction() {
    let newState = !globalStore.state.isLoginItemEnabled

    if !SMLoginItemSetEnabled("me.villani.lorenzo.ChaiHelper" as CFString, newState) {
      let alert = NSAlert()
      alert.alertStyle = .warning
      alert.messageText = "Cannot start Chai on login"
      alert.runModal()

      return
    }

    globalStore.dispatch(action: .setLoginItemEnabled(newState))
    os_log("Launch at login: %{public}s", newState ? "enabled" : "disabled")
  }

  @objc func quitAction() {
    NSRunningApplication.current.terminate()
  }
}
