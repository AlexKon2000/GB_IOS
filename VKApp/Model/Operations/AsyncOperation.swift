//
//  AsyncOperation.swift
//  VKApp
//
//  Created by Aleksey Kondratev on 11.04.2022.
//

import Foundation

class AsyncOperation: Operation {
    enum State: String {
        case ready, executing, finished

        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized }
    }

    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }

        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }

    override var isAsynchronous: Bool {
        true
    }

    override var isReady: Bool {
        super.isReady && state == .ready
    }

    override var isExecuting: Bool {
        state == .executing
    }

    override var isFinished: Bool {
        state == .finished
    }

    override func start() {
        if isCancelled {
            state = .finished
        } else {
            main()
            state = .executing
        }
    }

    override func cancel() {
        super.cancel()
        state = .finished
    }
}
