# SwiftMVI

**SwiftMVI** is an open-source library of conformables and extensions for swift, which provides an ability to build an MVI architecture with independent ``UseCases`` in SwiftUI.

## Overview

**SwiftMVI** provides the following features:
- Lightweight & scalable: Wide range of possible implementations from a single reducer to complex feature with child modules.
- Customizable workflows: You can build many variations by conform to ``Reducibles`` and ``Reducers``.
- A simple but very effective API bind parts together, including your existing combine publishers.
- Usable view protocols to implement your own feature driven view.

The main goal is a set of protocols for archiving structured data-flow with minimal effort.
But if you familiar with MVI architecture, there are some important differences compared to other MVI implementations. 

- an SwiftMVI State can be reference or value type. The reducers mutating the actual state via `Processing`, using `state()` methods, and a reducer always returns Void, if you must to handle an effect use `effect()` method.
- On the view side, you can choose between`ObservableObject` or `statePublisher` for updating.
- Your existing Combine publishers can be connected using `bind` method to a ``Feature``, and a ``Feature`` can behave as a `Publisher`, when your feature comforms to `EventReducer`.

## Installation
You can use Swift Package Manager to integrate the library by adding the following dependency in your Package.swift file or by adding directly within Xcode:

```swift
.Package(url: "https://github.com/xtro/SwiftMVI.git", majorVersion: 1)
```
