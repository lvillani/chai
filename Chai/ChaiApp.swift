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

import os
import ServiceManagement
import SwiftUI

@main
struct ChaiApp: App {
  @State private var appState = AppState()
  @State private var powerAssertion: PowerAssertion?
  @State private var deactivationTask: Task<Void, Never>?

  private let didWakePublisher = NSWorkspace.shared.notificationCenter
    .publisher(for: NSWorkspace.didWakeNotification)

  var body: some Scene {
    MenuBarExtra {
      MenuBarMenu(
        appState: appState,
        activate: activate,
        deactivate: deactivate,
        toggleDisableAfterSuspend: toggleDisableAfterSuspend,
        toggleLaunchAtLogin: toggleLaunchAtLogin
      )
      .onReceive(didWakePublisher) { _ in
        guard appState.isDisableAfterSuspendEnabled else { return }
        os_log("System wakeup detected, disabling according to config")
        deactivate()
      }
    } label: {
      Image(appState.isActive ? "Mug" : "Mug-Empty")
        .renderingMode(.template)
    }
  }

  // MARK: - Actions

  private func activate(spec: ActivationSpec) {
    // If already active with the same spec, toggle off
    if appState.isActive && appState.activeSpec == spec {
      deactivate()
      return
    }

    // Deactivate any existing assertion first
    deactivate()

    powerAssertion = PowerAssertion(named: "Brewing Tea")

    if spec.timeInterval > 0 {
      os_log("Scheduling deactivation in %f seconds", spec.timeInterval)
      deactivationTask = Task { @MainActor in
        try? await Task.sleep(for: .seconds(spec.timeInterval))
        guard !Task.isCancelled else { return }
        os_log("Timer fired, deactivating")
        deactivate()
      }
    }

    appState.activate(spec: spec)
    os_log("Activated")
  }

  private func deactivate() {
    powerAssertion = nil
    deactivationTask?.cancel()
    deactivationTask = nil
    appState.deactivate()
    os_log("Deactivated")
  }

  private func toggleDisableAfterSuspend() {
    appState.setDisableAfterSuspend(!appState.isDisableAfterSuspendEnabled)
  }

  private func toggleLaunchAtLogin() {
    let newState = !appState.isLoginItemEnabled

    do {
      if newState {
        try SMAppService.mainApp.register()
      } else {
        try SMAppService.mainApp.unregister()
      }
    } catch {
      os_log("Failed to update login item: %{public}@", error.localizedDescription)
      return
    }

    appState.setLoginItemEnabled(newState)
    os_log("Launch at login: %{public}s", newState ? "enabled" : "disabled")
  }
}

// MARK: - Menu View

struct MenuBarMenu: View {
  let appState: AppState
  let activate: (ActivationSpec) -> Void
  let deactivate: () -> Void
  let toggleDisableAfterSuspend: () -> Void
  let toggleLaunchAtLogin: () -> Void

  var body: some View {
    Text("Keep This Mac Awake")
      .font(.headline)

    Divider()

    ForEach(ActivationSpecs.allCases, id: \.self) { specCase in
      let spec = specCase.spec
      Button {
        activate(spec)
      } label: {
        HStack {
          Text(spec.title)
          if appState.activeSpec == spec {
            Spacer()
            Image(systemName: "checkmark")
          }
        }
      }
      .if(!spec.label.isEmpty) { view in
        view.keyboardShortcut(KeyEquivalent(Character(spec.label)), modifiers: [])
      }
    }

    Divider()

    Menu("Preferences") {
      Toggle("Disable After Suspend", isOn: Binding(
        get: { appState.isDisableAfterSuspendEnabled },
        set: { _ in toggleDisableAfterSuspend() }
      ))
    }

    Divider()

    Toggle("Launch at Login", isOn: Binding(
      get: { appState.isLoginItemEnabled },
      set: { _ in toggleLaunchAtLogin() }
    ))

    Button("Quit Chai") {
      NSApplication.shared.terminate(nil)
    }
    .keyboardShortcut("q")
  }
}

// MARK: - Conditional View Modifier

extension View {
  @ViewBuilder
  func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }
}
