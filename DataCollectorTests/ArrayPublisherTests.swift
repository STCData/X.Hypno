//
//  ArrayPublisherTests.swift
//  DataCollectorTests
//
//  Created by standard on 3/20/23.
//

import Combine
import Foundation
import XCTest
@testable
import DataCollector

class ArrayPublisherTests: XCTestCase {
    func testCombineLatest() {
        let publisher1 = PassthroughSubject<String, Never>()
        let publisher2 = PassthroughSubject<String, Never>()
        let publisher3 = PassthroughSubject<String, Never>()

        var receivedOutput: [[String]] = []
        var receivedCompletion: Subscribers.Completion<Never>?

        let cancellable = CombineLatestMany([publisher1, publisher2, publisher3])
            .sink(
                receiveCompletion: { receivedCompletion = $0 },
                receiveValue: { receivedOutput.append($0) }
            )

        publisher1.send("a")
        publisher2.send("b")
        publisher1.send("c")
        publisher2.send("d")
        publisher3.send("e")
        publisher3.send(completion: .finished)

        XCTAssertEqual(receivedOutput, [["c", "d", "e"]])
//        XCTAssertEqual(receivedCompletion, .finished)

        cancellable.cancel()
    }
}
