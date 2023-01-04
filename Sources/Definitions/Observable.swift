//
//  File.swift
//  
//
//  Created by Gabor Nagy on 2023. 01. 02..
//

import Foundation
import Combine

public protocol Observable {
    var cancellables: Set<AnyCancellable> { set get }
}
