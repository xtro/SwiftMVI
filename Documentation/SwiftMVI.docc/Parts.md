# Parts of the framwork

![Schema about current architecture](./Resources/processing_feature_schema@2x.png)

## Reducers and reducibles
### Reducibles
- ``ReducibleState`` is representing your view as data. 

### Reducers
- ``IntentReducer`` An ability to process incomming intents from user.
- ``AsyncIntentReducer`` An async version of **IntentReducer**.
- ``ActionReducer`` An ability to process incomming action from itself or other reducers.
- ``AsyncActionReducer`` An async version of **ActionReducer**.
- ``ReactionReducer`` An ActionReducer that returns a Reaction.
- ``AsyncReactionReducer`` An async version of **ReactionReducer**.
- ``EffectReducer`` An ability to proccess incomming events from **Processing**.
- ``AsyncEffectReducer`` An async version of **EffectReducer**.

## View

### Feature View
``FeatureView`` is a new view protocol type for your. features, as well, unlike the View implementation, FeatureView has a feature propery and a body function for creating a view from the actual state of the feature. In this type you don't need to implement the standard body getter, its synthesized automaticaly origins from this function. 

```swift
struct MyFeatureView: FeatureView {
    let feature: MyFeature
    init(_ feature: MyFeature) {
        self.feature = feature
        ...
    }
    
    func body(_ state: MyFeature.State) -> some View {
        ...
    }
}
```

As an extra, you can use a specified KeyPath (or a CasePath) for observation, in this case you need to update body function too:

```swift
struct MyFeatureView: FeatureView {
    ...
    var path: AnyPath<MyFeature.State, String> {
        AnyPath(\MyFeature.State.myValue)
    }
    ...
    func body(_ state: String) -> some View {
        ...
    }
    ...
}
```

### State Reducer View
If your feature conforms to ``ReducibleState``, with this view you can display items when state was changed. You can subscribe to the whole state or a part of it, with a given KeyPath (or CasePath for enums).

This way you can use this reduced states in your views:

```swift
StateReducerView(feature.$query) {
    Text("\($0.count) character typed")
}
...
StateReducerView(feature, /AssetsFeature.State.assets) {
    Text("Current state: [assets] \($0.count) loaded.")
}
```

### Event Reducer View
If your feature conforms to ``EventReducer``, with this view you can display items, when an event was fired. You can subscribe to the whole event object or a part of it, with a given KeyPath (or CasePath for enums).

```swift
EventReducerView(feature.$queueFeature) {
    Text("\($0.step)/($2.step)")
}
```

### Published Path View
In the deepest level of view hiearchy you can found the Published Part View, an implementation of a feature observation and a keypath filteration to present a given view.

```swift 
struct PublishedPathView<Content: View, Reducer, Reducible, Reduced, P: Publisher, Value>: View where P.Failure == Never, P.Output == Reducible 
```

```swift 
init(_ reducer: Reducer, persistent: Bool = false, map: @Sendable @escaping (Reducible) -> Reduced, publisher: P, path: AnyPath<Reduced, Value>, @ViewBuilder content: @escaping (Value) -> Content)
```

### SwiftUI Addons

#### Alert
Present an alert for a given ``EventReducer`` and a KeyPath (or CasePath for enums) for the observed value

```swift
func alert<R: EventReducer, V>(_ reducer: R, _ onEvent: KeyPath<R.Event, V>, persistent: Bool = false, map: @escaping (V) -> Alert) -> some View
```

#### Binding
Handle any modulable as a binding.

```swift
Binding.feature<M: Modulable>(_ feature: M) -> Binding<M.Value>
```


## Modules
The key concept behind Modules is to connect small independent features into bigger one as effective as possible, while keep your modules light as possible. 

Here is an example of a generic value feature implementation, only do one thing changing and store a Value over time.

```swift
public class ValueFeature<Value>: ReducibleState {
    public typealias State = Value
    public var state: State
    public var statePublisher: StatePublisher

    required public init(_ state: State) {
        self.state = state
        self.statePublisher = .init(state)
    }
}
extension ValueFeature: IntentReducer & Processing {
    public enum Intent {
        case update(State)
    }
    
    public func reduce(intent: Intent) {
        switch intent {
        case .update(let newState):
            state {
                newState
            }
        }
    }
}
```

by adding this extension to this module we can reach many new possibilities and we can reduce our whole module into a single property:

```swift
extension ValueFeature: Modulable {
    public var value: Property<Value> {
        Property(
            set: { [self] in
                self(.update($0))
            },
            get: { [self] in
                state
            }
        )
    }
}
```

In your parent feature:

```swift
public class MyFeature {
	...
	@StateFeature(ValueFeature("")) var module: String
	@StateFeature(ValueFeature(nil)) var selected: String?
	...
}
```

And thats it, after that definition on the view side, we can use as a binding:

```swift
TextField("Name", text: Binding(feature.$module))
```

and we observe it in a separate state reducer view:

```swift
StateReducerView(feature.$module) { 
    Text("\($0.count) character typed.")
}
```

Creating a new propery for a feature by modifing its getter:

```swift
extension ValueFeature where Value == String {
    public var uppercased: Property<String> {
        value
            .modified(
                get:{ [self] in
                    state.uppercased()
                }
            )
    }
}
```
