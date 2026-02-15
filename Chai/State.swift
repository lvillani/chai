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

import Foundation
import Observation

@Observable
@MainActor
final class AppState {
  private enum DefaultsKey {
    static let disableAfterSuspend = "DisableAfterSuspend"
    static let loginItemEnabled = "LoginItemEnabled"
  }

  var isActive: Bool = false
  var activeSpec: ActivationSpec? = nil
  var isDisableAfterSuspendEnabled: Bool = false
  var isLoginItemEnabled: Bool = false

  init() {
    isDisableAfterSuspendEnabled = UserDefaults.standard.bool(forKey: DefaultsKey.disableAfterSuspend)
    isLoginItemEnabled = UserDefaults.standard.bool(forKey: DefaultsKey.loginItemEnabled)
  }

  func activate(spec: ActivationSpec?) {
    isActive = true
    activeSpec = spec
  }

  func deactivate() {
    isActive = false
    activeSpec = nil
  }

  func setDisableAfterSuspend(_ enabled: Bool) {
    UserDefaults.standard.set(enabled, forKey: DefaultsKey.disableAfterSuspend)
    isDisableAfterSuspendEnabled = enabled
  }

  func setLoginItemEnabled(_ enabled: Bool) {
    UserDefaults.standard.set(enabled, forKey: DefaultsKey.loginItemEnabled)
    isLoginItemEnabled = enabled
  }
}
