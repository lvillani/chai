// SPDX-License-Identifier: GPL-3.0-only
//
// Chai - Don't let your Mac fall asleep, like a sir
// Copyright (C) 2023 Chai authors
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

class MenuItem: NSMenuItem {
  var timerDuration: TimeInterval = 0

  required init(coder decoder: NSCoder) {
    super.init(coder: decoder)
  }

  override init(title string: String, action selector: Selector?, keyEquivalent charCode: String) {
    super.init(title: string, action: selector, keyEquivalent: charCode)
  }
}
