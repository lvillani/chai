// SPDX-License-Identifier: GPL-3.0-only
//
// Chai - Don't let your Mac fall asleep, like a sir
// Copyright (C) 2021 Chai authors
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
import IOKit

// This is seemingly not exposed to Swift
enum Assertion: String {
  case NoDisplaySleep = "NoDisplaySleepAssertion"
}

// This is seemingly not exposed to Swift
enum AssertionLevel: UInt32 {
  case off = 0
  case on = 255
}

class PowerAssertion {
  var assertion: IOPMAssertionID = 0

  init(named name: String) {
    let ret = IOPMAssertionCreateWithName(
      Assertion.NoDisplaySleep.rawValue as CFString, AssertionLevel.on.rawValue, name as CFString,
      &assertion)

    // FIXME: Make this a fallible initializer
    if ret != kIOReturnSuccess {
      NSLog("Oops: Couldn't grab the power assertion")
    }
  }

  deinit {
    let ret = IOPMAssertionRelease(assertion)

    if ret != kIOReturnSuccess {
      NSLog("Oops: Couldn't release the power assertion")
    }
  }
}
