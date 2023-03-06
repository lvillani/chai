# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 3.3.0 - 2023-01-24

This release should be identical to 3.3.0-beta.1.

## 3.3.0-beta.1 - 2023-01-24

### Added

- Support for Apple Silicon. The application is now distributed as a Universal Binary.

### Changed

- Updated to build with Xcode 14 and Swift 5.

### Removed

- The application binary is no longer signed or notarized.

## 3.2.0 - 2019-09-07

### Added

- The application binary is now notarized.

### Changed

- Left-clicking on the menu item activates the application with no time limit
  (equivalent to clicking on "Forever" inside the menu). The menu can be
  accessed by right-clicking on the menu bar icon.
