# DesignOverlay

DesignOverlay is a debug tool to check design.


## Features

* Easy to use like: `DesignOverlay.show()`
* Grid view is shown as overlay.

## How it looks

<img src="https://raw.githubusercontent.com/himaratsu/DesignOverlayKit/master/misc/demo.gif" width="320px">

<img src="https://raw.githubusercontent.com/himaratsu/DesignOverlayKit/master/misc/screenshot1.png" width="240px"> <img src="https://raw.githubusercontent.com/himaratsu/DesignOverlayKit/master/misc/screenshot2.png" width="240px"> <img src="https://raw.githubusercontent.com/himaratsu/DesignOverlayKit/master/misc/screenshot3.png" width="240px">

## Requirements

* iOS 9.0 or later

## Demo

Git clone or download this repository and open DesignLayoutKitSample.xcodeproj . You can try DesignOverkay in your Mac or iPhone.

## Installation and Setup

### Installing with CocoaPods

CocoaPods is a centralised dependency manager.
To integrate DesignOverlay into your Xcode project using CocoaPods, specify it in your Podfile and run `pod install`.

```
platform :ios, '8.0'
use_frameworks!

pod 'DesignOverlayKit'
```

### Installing with Carthage

Just add to your Cartfile:

```
github "himaratsu/DesignOverlayKit"
```

## Usage

### Basic 

To start using DesignOverlayKit, write the following line wherever you want to use design overlay.

```swift
import DesignOverlayKit
```

Then invoke DesignOverlay, by calling:

```swift
DesignOverlay.show()
```

And following line to dismiss overlay.

```swift
DesignOverlay.hide()
```

### Parameter

DesignOvelay can be customizable with `DesignOverlay.Parameter`.

```swift
let parameter = DesignOverlay.Parameter()
parameter.gridSize = 50
parameter.gridColor = UIColor.green

DesignOverlay.show(with: parameter)
```

## License

DesignOverlay is released under the MIT license. Go read the LICENSE file for more information.
