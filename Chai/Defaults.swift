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

import Foundation

class Defaults {
  private let keyDisableAfterSuspend = "DisableAfterSuspend"
  private let keyLoginItemEnabled = "LoginItemEnabled"
  private let keyIsEnabledByDefault = "IsEnabledByDefault"
  private let keyLastSession = "LastSession"
  private let userDefaults = UserDefaults()

  var isDisableAfterSuspendEnabled: Bool {
    get {
      return userDefaults.bool(forKey: keyDisableAfterSuspend)
    }

    set {
      userDefaults.set(newValue, forKey: keyDisableAfterSuspend)
    }
  }

  var isLoginItemEnabled: Bool {
    get {
      return userDefaults.bool(forKey: keyLoginItemEnabled)
    }

    set {
      userDefaults.set(newValue, forKey: keyLoginItemEnabled)
    }
  }

  var isEnabledByDefault: Bool {
    get {
      return userDefaults.bool(forKey: keyIsEnabledByDefault)
    }

    set {
      userDefaults.set(newValue, forKey: keyIsEnabledByDefault)
    }
  }

  var lastSession: String? {
    get {
      return userDefaults.string(forKey: keyLastSession)
    }

    set {
      userDefaults.set(newValue, forKey: keyLastSession)
    }
  }
}
