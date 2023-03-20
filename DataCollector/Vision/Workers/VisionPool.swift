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
    public static let broadcastThrottle = RunLoop.SchedulerTimeType.Stride(0.9)
    public static let cameraThrottle = RunLoop.SchedulerTimeType.Stride(0.9)

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

extension CVPixelBuffer {
    func isAlmostEqual(to another: CVPixelBuffer) -> Bool {
        let old = self
        let new = another
        CVPixelBufferLockBaseAddress(old, .readOnly)
        CVPixelBufferLockBaseAddress(new, .readOnly)
        let oldP = CVPixelBufferGetBaseAddress(old)
        let newP = CVPixelBufferGetBaseAddress(new)

        let oldBuf = unsafeBitCast(oldP, to: UnsafeMutablePointer<UInt8>.self)
        let newBuf = unsafeBitCast(newP, to: UnsafeMutablePointer<UInt8>.self)

        let oldLen = CVPixelBufferGetDataSize(old)
        let newLen = CVPixelBufferGetDataSize(new)

        var isEqual = (oldLen == newLen)

        var differentBytes = 0
        let differentBytesTreshold = newLen / 100

        if oldLen == newLen && oldLen > 0 {
            for i in 0 ..< oldLen {
                if oldBuf[i] != newBuf[i] {
                    differentBytes += 1
                    if differentBytes >= differentBytesTreshold {
                        isEqual = false
                        break
                    }
                }
            }
        }

        CVPixelBufferUnlockBaseAddress(old, .readOnly)
        CVPixelBufferUnlockBaseAddress(new, .readOnly)

        return isEqual
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
            HumanBodyPoseRecognizer(),
            try! YOLOObjectRecognizer(),
//            try! YOLOObjectRecognizer(),
//            try! YOLOObjectRecognizer(),
//            try! YOLOObjectRecognizer(),
        ])
    }

    static func makeFullPoolSubscribedToSharedBroadcast() -> Self {
        let fullPool = makeFullPool()
        Publishers.RemoveDuplicates(upstream: Broadcast.shared.cvBufferSubject
            .throttle(for: VisionPool.broadcastThrottle, scheduler: RunLoop.main, latest: true))
        { old, new in
            let isEqual = old.isAlmostEqual(to: new)
            log.trace("heavy skipping broadcast frame recognizing: \(isEqual)")

            return isEqual
        }
        .subscribe(fullPool)

        return fullPool
    }

    static func makeCameraPool() -> Self {
        let yoloWorker = try! YOLOObjectRecognizer()
        let visionPool = Self(workers: [yoloWorker, HandRecognizer()])
        return visionPool
    }
}
