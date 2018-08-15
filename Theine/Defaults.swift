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

import Foundation

class Defaults {
    private let keyLoginItemEnabled = "LoginItemEnabled"
    private let userDefaults = UserDefaults()

    var loginItemEnabled: Bool {
        get {
            return userDefaults.bool(forKey: keyLoginItemEnabled)
        }

        set {
            userDefaults.set(newValue, forKey: keyLoginItemEnabled)
        }
    }
}
