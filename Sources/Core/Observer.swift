// Observer.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import Combine
import Foundation
import SwiftUI

public protocol Observer: AnyObject {
    var cancellables: Set<AnyCancellable> { set get }
}
