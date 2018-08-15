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
    func applicationDidFinishLaunching(_: Notification) {
        let bundlePath = NSString(string: Bundle.main.bundlePath).pathComponents
        let parentPath = Array(bundlePath[..<(bundlePath.count - 4)])

        NSWorkspace.shared.launchApplication(NSString.path(withComponents: parentPath))
        NSRunningApplication.current.terminate()
    }
}
