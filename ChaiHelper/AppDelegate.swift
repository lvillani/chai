// SPDX-License-Identifier: GPL-3.0-only
//
// Chai - Don't let your Mac fall asleep, like a sir
// Copyright (C) 2026 Chai authors
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
import os

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_: Notification) {
    // Find whether parent application is running
    let isRunning = NSWorkspace.shared.runningApplications.contains {
      $0.bundleIdentifier == "me.villani.lorenzo.Chai"
    }

    if isRunning {
      os_log("Parent application already running")
      return
    }

    // Launch parent application
    os_log("Launching parent application")

    let bundlePath = NSString(string: Bundle.main.bundlePath).pathComponents
    let parentPath = Array(bundlePath[..<(bundlePath.count - 4)])

    let path = NSString.path(withComponents: parentPath)
    let url = URL(fileURLWithPath: path)
    NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration()) { _, _ in
        DispatchQueue.main.async {
            NSRunningApplication.current.terminate()
        }
    }
  }
}
