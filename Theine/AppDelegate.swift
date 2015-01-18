//
// The MIT License (MIT)
//
// Copyright (c) 2015 Lorenzo Villani
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var iconOff: NSImage!
    var iconOn: NSImage!
    var statusItem: NSStatusItem!
    var powerAssertion: PowerAssertion!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        iconOff = NSImage(named: "Mug-Empty")
        iconOff.setTemplate(true)

        iconOn = NSImage(named: "Mug")
        iconOn.setTemplate(true)

        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
        statusItem.highlightMode = true
        statusItem.image = iconOff
        statusItem.action = "togglePowerAssertion"
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }

    func togglePowerAssertion() {
        if statusItem.image == iconOff {
            // Grab power assertion
            powerAssertion = PowerAssertion(named: "Brewing Green Tea")
            statusItem.image = iconOn
        } else {
            // Release power assertion
            powerAssertion = nil
            statusItem.image = iconOff
        }
    }
}
