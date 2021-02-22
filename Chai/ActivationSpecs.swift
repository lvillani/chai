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

let oneHourInterval = TimeInterval(3600)  // Seconds

struct ActivationSpec {
    let title: String
    let timeInterval: TimeInterval
    let label: String
}

enum ActivationSpecs: String, CaseIterable {
    case forever = "Forever"
    case halfHour = "30 Minutes"
    case oneHour = "1 Hour"
    case twoHours = "2 Hours"
    case fourHours = "4 Hours"
    case eightHours = "8 Hours"

    static func spec(for title: String) -> ActivationSpec? {
        return self.init(rawValue: title)?.spec
    }

    var spec: ActivationSpec {
        switch self {
        case .forever:
            return ActivationSpec(
                title: rawValue,
                timeInterval: 0,
                label: "0"
            )
        case .halfHour:
            return ActivationSpec(
                title: rawValue,
                timeInterval: oneHourInterval / 2,
                label: ""
            )
        case .oneHour:
            return ActivationSpec(
                title: rawValue,
                timeInterval: oneHourInterval,
                label: "1"
            )
        case .twoHours:
            return ActivationSpec(
                title: rawValue,
                timeInterval: 2 * oneHourInterval,
                label: "2"
            )
        case .fourHours:
            return ActivationSpec(
                title: rawValue,
                timeInterval: 4 * oneHourInterval,
                label: "4"
            )
        case .eightHours:
            return ActivationSpec(
                title: rawValue,
                timeInterval: 8 * oneHourInterval,
                label: "8"
            )
        }
    }
}
