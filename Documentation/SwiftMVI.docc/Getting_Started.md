# Getting started
To build a ui feature using the SwiftMVI you define some types and values that model your domain:

- **ImmutableState**: An integer as the state of your UI.
- **IntentReducer**: A function for increase/decrease the inteder.
- **Processing**: A conformable protocol which enable processing functionalities in the feature.

As a basic example, consider a UI that shows a number along with **+** and **−** buttons that increment and decrement the number.

Here you need to define a type for the feature's state, which consists of an integer for the current count:

```swift
import SwiftMVI

class CounterFeature: ReducibleState {
    @Observed var state: Int
    
    init(state: Int = 0) {
        self.state = state
    }
}
```

You also need to define a type for the feature's intents, there are two intents one for the increase and one for decrease:

```swift
extension CounterFeature: IntentReducer {
    enum Intent {
        case increment
        case decrement
    }
}
```

And then you implement the reduce method which is responsible for handling the behaviour of the feature. In this example to change the state you need to add `Processing` protocol and call `state`:

```swift
extension CounterFeature: IntentReducer, Processing {
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


And then finally you can define a view which presenting your feature:

```swift
struct MyView: View {
    let feature: CounterFeature
    ...
    
    var body: some View {
    	...
        VStack {
            HStack {
                Button("−") { feature(.decrement) }
                Text("\(feature.state)")
                Button("+") { feature(.increment) }
            }
        }
        ...
    }
}
```

or create a feature view component that using the state publisher:

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
