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
    typealias Input = CVPixelBuffer
    typealias Failure = Never
    let observationsSubject = PassthroughSubject<[VNObservation], Never>()

    private var workers: [any VisionWorker]
    private var workersSubscriptions = Set<AnyCancellable>()

    func receive(completion: Subscribers.Completion<Never>) {
        log.trace("VisionPool completion \(completion)")
    }

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

    required init(workers: [any VisionWorker]) {
        self.workers = workers

        CombineLatestMany(workers.map { $0.observationsSubject.eraseToAnyPublisher() })
            .sink { observations in
                let flatObservations = observations.flatMap { $0 }
                self.observationsSubject.send(flatObservations)
            }.store(in: &workersSubscriptions)
    }
}

extension VisionPool {
    static let broadcastPool = makeFullPoolSubscribedToSharedBroadcast()
    static let cameraPool = makeCameraPool()

    static func makeFullPool() -> Self {
        Self(workers: [
            //            TextRecognizer(),
//            TextRecognizer(),
            TextRecognizer(),
            try! YOLOObjectRecognizer(),
//            try! YOLOObjectRecognizer(),
//            try! YOLOObjectRecognizer(),
//            try! YOLOObjectRecognizer(),
        ])
    }

    static func makeFullPoolSubscribedToSharedBroadcast() -> Self {
        let fullPool = makeFullPool()
        Broadcast.shared.cvBufferSubject
            .throttle(for: 0.9, scheduler: RunLoop.main, latest: true)
            .subscribe(fullPool)

        return fullPool
    }

    static func makeCameraPool() -> Self {
        let yoloWorker = try! YOLOObjectRecognizer()
        let visionPool = Self(workers: [yoloWorker])
        return visionPool
    }
}
