# DesignOverlay

DesignOverlay is a debug tool to check design.


## Features

* Easy to use like: `DesignOverlay.show()`
* Grid view is shown as overlay.

## How it looks

screenshot here.

## Requirements

* iOS 9.0 or later

## Installation and Setup

### Installing with Carthage

Just add to your Cartfile:

```
github "himaratsu/DesignOverlayKit"
```

## Usage

### Basic 

To start using DesignOverlayKit, write the following line wherever you want to use design overlay.

```
import DesignOverlayKit
```

Then invoke DesignOverlay, by calling:

```
DesignOverlay.show()
```

### Parameter

DesignOvelay can be customizable with `DesignOverlay.Parameter`.

```
let parameter = DesignOverlay.Parameter()
parameter.gridSize = 50
parameter.gridColor = UIColor.green

DesignOverlay.show(with: parameter)
```

## License

DesignOverlay is released under the MIT license. Go read the LICENSE file for more information.
