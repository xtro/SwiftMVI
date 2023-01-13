![SwiftMVI Logo](./Documentation/SwiftMVI.docc/Resources/swiftmvi_icon_338@2x.png)
# SwiftMVI


[![Swift](https://github.com/xtro/SwiftMVI/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/xtro/SwiftMVI/actions/workflows/swift.yml) ![platforms](https://img.shields.io/badge/platform-iOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20macOS-333333) [![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager) ![GitHub](https://img.shields.io/github/license/xtro/SwiftMVI) ![Current version](https://img.shields.io/github/v/tag/xtro/SwiftMVI)

**SwiftMVI** is an open-source library of conformables and extensions for swift, which provides an ability to build an MVI architecture with independent ``UseCases`` in SwiftUI.

## Overview

**SwiftMVI** provides the following features:
- Lightweight & scalable: Wide range of possible implementations from a single reducer to complex feature with child modules.
- Customizable workflows: You can build many variations by conform to ``Reducibles`` and ``Reducers``.
- A simple but very effective API bind parts together, including your existing combine publishers.
- Usable view protocols to implement your own feature driven view.

The main goal is a set of protocols for archiving structured data-flow with minimal effort.
But if you familiar with MVI architecture, there are some important differences compared to other MVI implementations:

- a State can be reference or value type. The reducers mutating the actual state via `Processing`, using `state()` methods, and a reducer always returns Void, if you must to handle an effect use `effect()` method.
- On the view side, you can choose between`ObservableObject` or `statePublisher` for updating.
- Your existing Combine publishers can be connected using `bind` method to a ``Feature``, and a ``Feature`` can behave as a `Publisher`, when your feature comforms to `EventReducer`.

## Installation
You can use Swift Package Manager to integrate the library by adding the following dependency in your Package.swift file or by adding directly within Xcode:

```swift
.package(url: "https://github.com/xtro/SwiftMVI.git", .upToNextMajor(from: "0.2.0"))
```

## Usage
- [Example application](https://github.com/xtro/SwiftMVI-Examples)
- [Getting Started](Documentation/SwiftMVI.docc/Getting_Started.md)
- [Parts of SwiftMVI](Documentation/SwiftMVI.docc/Parts.md)

### Example

Feature:

```swift
class CounterFeature: ReducibleState, IntentReducer, Processing {
    var state: Int
    var statePublisher: StatePublisher
    
    init(state: Int = 0) {
        self.state = state
        self.statePublisher = .init(state)
    }
    enum Intent {
        case increment
        case decrement
    }
    func reduce(intent: Intent) {
        switch intent {
        case .increment:
            state {
                $0 + 1
            }
        case .decrement:
            state {
                $0 - 1
            }
        }
    }
}
```

View:

```swift
struct CounterView: FeatureView {
    let feature: CounterFeature
    
    func body(_ newState: Int) -> some View {
        VStack {
            HStack {
                Button("−") { feature(.decrement) }
                Text("\(newState)")
                Button("+") { feature(.increment) }
            }
        }
    }
}
```

## Sponsors
SwiftMVI is an MIT-licensed open-source project with its ongoing development made possible entirely by the support of awesome backers. If you'd like to join them, please consider sponsoring this development.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
This library is released under the [MIT](https://choosealicense.com/licenses/mit/) license. See LICENSE for details.

