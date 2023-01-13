// Processing+UseCase.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import Foundation
import SwiftUseCase

public extension Processing {
    @discardableResult
    /// Execute a usecase without any ``Parameter``.
    /// - Parameters:
    ///   - usecase: An executable UseCase
    /// - Returns: Result of the executed usecase
    func run<U: SyncUseCase>(_ usecase: U) -> U.Result where U.Parameter == Void {
        return run(usecase, ())
    }

    @discardableResult
    /// Execute a usecase.
    /// - Parameters:
    ///   - usecase: An executable UseCase
    /// - Returns: Result of the executed usecase
    func run<U: SyncUseCase>(_ usecase: U, _ parameters: U.Parameter) -> U.Result {
        usecase(parameters)
    }
}

public extension Processing {
    @discardableResult
    /// Execute a throwing usecase without any ``Parameter``.
    /// - Parameters:
    ///   - usecase: An executable UseCase
    /// - Returns: Result of the executed usecase
    func run<U: SyncThrowingUseCase>(_ usecase: U) throws -> U.Result where U.Parameter == Void {
        return try run(usecase, ())
    }

    @discardableResult
    /// Execute a throwing usecase.
    /// - Parameters:
    ///   - usecase: An executable UseCase
    /// - Returns: Result of the executed usecase
    func run<U: SyncThrowingUseCase>(_ usecase: U, _ parameters: U.Parameter) throws -> U.Result {
        try usecase(parameters)
    }
}

public extension Processing {
    @discardableResult
    /// Execute an asycnronous usecase assyncronously without any ``Parameter``.
    /// - Parameters:
    ///   - usecase: An executable AsyncUseCase
    /// - Returns: Result of the executed usecase
    func run<U: AsyncUseCase>(_ usecase: U) async -> U.Result where U.Parameter == Void {
        return await run(usecase, ())
    }

    @discardableResult
    /// Execute an asycnronous usecase assyncronously.
    /// - Parameters:
    ///   - usecase: An executable AsyncUseCase
    ///   - parameters: Execution parameter for the UseCase
    /// - Returns: Result of the executed usecase
    func run<U: AsyncUseCase>(_ usecase: U, _ parameters: U.Parameter) async -> U.Result {
        await usecase(parameters)
    }
}

public extension Processing {
    @discardableResult
    /// Execute an asycnronous throwing usecase assyncronously without any ``Parameter``.
    /// - Parameters:
    ///   - usecase: An executable AsyncThrowingUseCase
    /// - Returns: Result of the executed usecase
    func run<U: AsyncThrowingUseCase>(_ usecase: U) async throws -> U.Result where U.Parameter == Void {
        return try await run(usecase, ())
    }

    @discardableResult
    /// Execute an asycnronous throwing usecase assyncronously.
    /// - Parameters:
    ///   - usecase: An executable AsyncThrowingUseCase
    ///   - parameters: Execution parameter for the UseCase
    /// - Returns: Result of the executed usecase
    func run<U: AsyncThrowingUseCase>(_ usecase: U, _ parameters: U.Parameter) async throws -> U.Result {
        try await usecase(parameters)
    }
}

public extension Processing {
    /// Execute a given ``AnyUseCase``
    /// - Parameters:
    ///   - usecase: An executable UseCase
    ///   - parameters: Execution parameter for the UseCase
    ///   - onCancel: Executes on cancellation
    ///   - onFailure: Executes when UseCase is a throwing usecase
    ///   - onComplete: Executes with the result of UseCase
    func run<U: AnyUseCaseType>(_ usecase: U, _: U.Parameter, onCancel: U.Cancellation? = nil, onFailure: U.Failure? = nil, onComplete: @escaping U.Completion) {
        let completion = usecase.onComplete
        let failure = usecase.onFailure
        let cancellation = usecase.cancellation
        var usecase = usecase
        usecase.onComplete = {
            completion?($0)
            onComplete($0)
        }
        if let failure {
            usecase.onFailure = {
                failure($0)
                onFailure?($0)
            }
        }
        usecase.cancellation = {
            _ = cancellation?()
            return onCancel?() ?? true
        }
//        usecase.execute(parameters)
    }

    /// Execute a given ``AnyUseCase``without any ``Parameter``.
    /// - Parameters:
    ///   - usecase: An executable UseCase
    ///   - onCancel: Executes on cancellation
    ///   - onFailure: Executes when UseCase is a throwing usecase
    ///   - onComplete: Executes with the result of UseCase
    func run<U: AnyUseCaseType>(_ usecase: U, onCancel: U.Cancellation? = nil, onFailure: U.Failure? = nil, onComplete: @escaping U.Completion) where U.Parameter == Void {
        run(usecase, (), onCancel: onCancel, onFailure: onFailure, onComplete: onComplete)
    }
}
