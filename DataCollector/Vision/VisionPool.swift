//
//  VisionPool.swift
//  DataCollector
//
//  Created by standard on 3/20/23.
//

import Combine
import Foundation
import Vision

private let log = LogLabels.vision.makeLogger()

final class VisionPool: VisionWorker {
    let observationsSubject = PassthroughSubject<[VNObservation], Never>()

    func receive(completion: Subscribers.Completion<Never>) {
        log.trace("VisionPool completion \(completion)")
    }

    static let shared = makeFullPoolSubscribedToSharedBroadcast()

    typealias Input = CVPixelBuffer
    typealias Failure = Never

    func receive(subscription: Subscription) {
        log.trace("VisionPool subscribed \(subscription)")
        subscription.request(.max(1))
    }

    func receive(_ input: CVPixelBuffer) -> Subscribers.Demand {
        log.trace("VisionPool received input ")
        process(cvPixelBuffer: input)
        return Subscribers.Demand.max(1)
    }

    func process(cvPixelBuffer: CVPixelBuffer) {
        for worker in workers {
            let _ = worker.receive(cvPixelBuffer)
        }
    }

    private var workers: [any VisionWorker]
    private var workersSubscriptions = Set<AnyCancellable>()

    required init(workers: [any VisionWorker]) {
        self.workers = workers

        CombineLatestMany(workers.map { $0.observationsSubject.eraseToAnyPublisher() })
            .sink { observations in
                let flatObservations = observations.flatMap { $0 }
                self.observationsSubject.send(flatObservations)
            }.store(in: &workersSubscriptions)
    }

    static func makeFullPool() -> Self {
        Self(workers: [
            TextRecognizer(),
            TextRecognizer(),
            TextRecognizer(),
            try! YOLOObjectRecognizer(),
            try! YOLOObjectRecognizer(),
            try! YOLOObjectRecognizer(),
            try! YOLOObjectRecognizer(),
        ])
    }
}

extension VisionPool {
    static func makeFullPoolSubscribedToSharedBroadcast() -> Self {
        let fullPool = makeFullPool()
        Broadcast.shared.cvBufferSubject
            .throttle(for: 1.0, scheduler: RunLoop.main, latest: true)
            .subscribe(fullPool)
        return fullPool
    }
}
