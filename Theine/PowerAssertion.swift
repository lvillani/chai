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

import Foundation
import IOKit

// This is seemingly not exposed to Swift
enum Assertion: String {
    case NoDisplaySleep = "NoDisplaySleepAssertion"
}

// This is seemingly not exposed to Swift
enum AssertionLevel: UInt32 {
    case Off = 0
    case On = 255
}

class PowerAssertion {
    var assertion: IOPMAssertionID = 0

    init(named name: String) {
        let ret = IOPMAssertionCreateWithName(Assertion.NoDisplaySleep.rawValue, AssertionLevel.On.rawValue, name, &assertion)

        // FIXME: Make this a fallible initializer
        if ret != kIOReturnSuccess {
            println("Oops: Couldn't grab the power assertion")
        }
    }

    deinit {
        let ret = IOPMAssertionRelease(assertion)

        if ret != kIOReturnSuccess {
            println("Oops: Couldn't release the power assertion")
        }
    }
}