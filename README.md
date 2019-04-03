# OLManager

[![CI Status](https://img.shields.io/travis/MaxOstPM/OLManager.svg?style=flat)](https://travis-ci.org/MaxOstPM/OLManager)
[![Version](https://img.shields.io/cocoapods/v/OLManager.svg?style=flat)](https://cocoapods.org/pods/OLManager)
[![License](https://img.shields.io/cocoapods/l/OLManager.svg?style=flat)](https://cocoapods.org/pods/OLManager)
[![Platform](https://img.shields.io/cocoapods/p/OLManager.svg?style=flat)](https://cocoapods.org/pods/OLManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

OLManager is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'OLManager'
```
## Implementation Examples

```swift
import OLManager

enum YourCustomOverlays: OverlayLevelHolder { 
    case successOverlay
    case failurOverlay

    var level: YourCustomOverlays {
        switch self {
            case .successOverlay:
            return .global
            case .failurOverlay:
            return .local
        }
    }
}

final class OverlayFactoryImp: OverlayFactory {

    func makeOverlayWith(type: YourCustomOverlays) -> UIView {
        switch type {
            ...
        }
    }
}

final class OverlayManagerProvider {

    static let provider = OverlayManagerProvider()

    var overlayManager: OverlayManagerOf<OverlayFactoryImp>

    init() {
        let factory = OverlayFactoryImp()
        overlayManager = OverlayManagerOf<OverlayFactoryImp>(factory: factory)
    }
}
```

## Author

MaxOstPM, kurtmo17@gmail.com

## License

OLManager is available under the MIT license. See the LICENSE file for more info.
