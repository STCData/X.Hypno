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
        let backgroundQueue = DispatchQueue.global(qos: .userInteractive)

        let fullPool = makeFullPool()
        Broadcast.shared.cvBufferSubject
            .throttle(for: 0.1, scheduler: RunLoop.main, latest: true)
            .receive(on: backgroundQueue)
            .removeDuplicates(by: { old, new in

                let isEqual = old.isAlmostEqual(to: new)
                log.trace("heavy skipping broadcast frame recognizing: \(isEqual)")
//                if !isEqual {
//                    fullPool.resetObservations()
//                }
                return isEqual
            })

            .throttle(for: VisionPool.broadcastThrottle, scheduler: RunLoop.main, latest: true)
            .subscribe(fullPool)

        return fullPool
    }
}