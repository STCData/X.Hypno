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

final class VisionPool: VisionWorker, ObservableObject {
    @Published
    var isOn = true

    public static let broadcastThrottle =
        RunLoop.SchedulerTimeType.Stride(0.8)
    public static let cameraThrottle =
        RunLoop.SchedulerTimeType.Stride(0.8)

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
        observationsSubject.send([]) // reset observations!
        if isOn {
            process(cvPixelBuffer: input)
        }
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
