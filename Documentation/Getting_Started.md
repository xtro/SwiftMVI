# Getting started
To build a ui feature using the SwiftMVI you define some types and values that model your domain:

- **ImmutableState**: An integer as the state of your UI.
- **Intent**: A type that represents all of the user actions that can happen in your feature.
- **IntentReducer**: A function that handles intents and processes them over time.
- **Processing**: Enable processing functionalities in a feature.

As a basic example, consider a UI that shows a number along with **+** and **−** buttons that increment and decrement the number.

Here we need to define a type for the feature's state, which consists of an integer for the current count:

```swift
import SwiftMVI

class Feature: ObservableObject, ImmutableState {
    var state = 0
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


And then finally we define the view that displays the feature, adding as ``StateObject`` or ``ObservedObject`` and call by passing its ``Intent``:


```swift
struct FeatureView: View {
    @StateObject var feature = Feature()
    
    var body: some View {
        VStack {
            HStack {
                Button("−") { feature(.decrement) }
                Text("\(feature.state)")
                Button("+") { feature(.increment) }
            }
        }
    }
}
```
