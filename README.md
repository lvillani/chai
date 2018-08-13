# Theine

<img align="right" alt="logo" src="Theine/Images.xcassets/AppIcon.appiconset/128x128@2x.png" width="128" height="128">

_Don't let your Mac fall asleep, like a sir_

[![License](https://img.shields.io/badge/license-GPLv3-blue.svg?style=flat)](https://choosealicense.com/licenses/gpl-3.0/)
[![Semver](https://img.shields.io/badge/version-v1.0.1-blue.svg)](CHANGELOG.md)
![Bugs](https://img.shields.io/badge/bugs-nope-ff69b4.svg)
![Mojave Ready](https://img.shields.io/badge/mojave-ready-yellowgreen.svg)

--------------------------------------------------------------------------------

## Introduction

Theine is a lightweight app that lives in your menu bar. It looks like a cup:

![Menubar with Theine](theine-menubar.png)

---

When the cup is full, Theine won't let your Mac fall asleep:

![Theine is on](theine-on.png)

---

When the cup is empty, Theine will let your Mac fall asleep:

![Theine is off](theine-off.png)


## Installation

Download the latest release (a .zip file) from
[here](https://github.com/lvillani/theine/releases/latest) and move the application to
`/Applications`.

### Start at Login

To start Theine at login:

* Open System Preferences;
* Click "Users & Groups";
* Click "Login Items";
* Drag and Drop Theine from the Finder to the list.


## Don't We Have Caffeine Already?

Theine is better than [Caffeine](http://lightheadsw.com/caffeine/) in a number of ways:

* It's open source, we have nothing to hide.
* The monochrome icon adapts nicely to light and dark themes. It's ready for Mojave.
* Uses [power assertions][IOPMLib]
  to keep your Mac awake.
* It runs in the [sandbox][sandbox] to keep your Mac secure.
* Tea is supposedly better than coffee.


## Icons

Icons are licensed from [Glyphish](http://glyphish.com) and cannot be used outside this project.

[IOPMLib]: https://developer.apple.com/library/mac/documentation/IOKit/Reference/IOPMLib_header_reference/
[sandbox]: https://developer.apple.com/library/mac/documentation/Security/Conceptual/AppSandboxDesignGuide/AboutAppSandbox/AboutAppSandbox.html
