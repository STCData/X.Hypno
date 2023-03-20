//
//  VisionPool+Broadcast.swift
//  DataCollector
//
//  Created by standard on 3/20/23.
//

import Combine
import Foundation
private let log = LogLabels.vision.makeLogger()

extension VisionPool {
    static let broadcastPool = makeFullPoolSubscribedToSharedBroadcast()

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
}
