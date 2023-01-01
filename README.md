# SwiftMVI

[![Swift](https://github.com/xtro/SwiftMVI/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/xtro/SwiftMVI/actions/workflows/swift.yml) ![platforms](https://img.shields.io/badge/platform-iOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20macOS-333333) [![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager) ![GitHub](https://img.shields.io/github/license/xtro/SwiftMVI) ![Current version](https://img.shields.io/github/v/release/xtro/SwiftMVI?display_name=tag&sort=semver)

**SwiftMVI** is an open-source library of definitions and related extensions for modern swift application development.

## Overview

**SwiftMVI** provides the following features:
- Lightweight & scalable: Wide range of possible implementations from a single reducer to complex feature
- Able to publish events  
- A simple but very effective API bind your combine publishers to reducers and publishers.

![Schema about current architecture](./Documentation/SwiftMVI.docc/Resources/processing_feature_schema@2x.png)

The goal is a set of protocols for archiving structured data flow that takes minimal effort.
There are some important differences compared to other MVI implementations. 
First of all, in SwiftMVI state is a mutable ``ObservableObject``, therefore the reducers are not return anything not even an effect. The reducers can connect using the ``Processing`` protocol and its api. Your existing Combine publishers can be connected using ```.bind``` method and your implemented ``Feature`` can be inserted as A **Publisher** instance. in any process using ``EventReducer``.


## Installation
You can use Swift Package Manager to integrate the library by adding the following dependency in your Package.swift file or by adding directly within Xcode:

```swift
.Package(url: "https://github.com/xtro/SwiftMVI.git", majorVersion: 1)
```

## Usage
To build a ui feature using the SwiftMVI you define some types and values that model your domain:

- **ReducibleState**: A type that describes the state of your UI.
- **Intent**: A type that represents all of the actions that can happen in your feature, such as user actions, notifications, event sources and more.
- **IntentReducer**: A function that handles intents and processes them over time.
- **Processing**: Enable processing functionalities in a feature.

As a basic example, consider a UI that shows a number along with "+" and "−" buttons that increment and decrement the number.

Here we need to define a type for the feature's state, which consists of an integer for the current count:

```swift
import SwiftMVI

class Feature: ObservableObject, ReducibleState {
    class State {
        var count = 0
    }
    var state = State()
}
```

We also need to define a type for the feature's intents, there are two intents one for the increase and one for decrease:

```swift
extension Feature: IntentReducer {
    enum Intent {
        case increment
        case decrement
    }
}
```

And then we implement the reduce method which is responsible for handling the behaviour of the feature. In this example to change the state we need to add ``Processing`` protocol and call ``.state``:

```swift
extension Feature: IntentReducer, Processing {
    enum Intent { ... }
    func reduce(intent: Intent) {
        switch intent {
        case .increment:
            state {
                $0.count += 1
            }
        case .decrement:
            state {
                $0.count -= 1
            }
        }
    }
}
```


And then finally we define the view that displays the feature, adding as ``StateObject`` or ``ObservedObject`` and call by passing its ``Intent``:


```swift
struct FeatureView: View {
    @StateObject var feature = Feature()
    
    var body: some View {
        VStack {
            HStack {
                Button("−") { feature(.decrement) }
                Text("\(feature.state.count)")
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

Please make sure to update tests as appropriate.

## License
This library is released under the [MIT](https://choosealicense.com/licenses/mit/) license. See LICENSE for details.

