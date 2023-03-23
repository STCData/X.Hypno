//
//  VisionPool+Camera.swift
//  DataCollector
//
//  Created by standard on 3/20/23.
//

import Foundation

import Combine
import CoreMedia

private let log = LogLabels.vision.makeLogger()

extension VisionPool {
    static let cameraPool = makeCameraPool()

    static func subscribeCameraPool(to cmBufferSubject: PassthroughSubject<CMSampleBuffer, Never>) {
        cmBufferSubject
            .drop(untilOutputFrom: VisionPool.cameraPool.observationsSubject)
            .throttle(for: VisionPool.cameraThrottle, scheduler: RunLoop.main, latest: true)
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .compactMap { cmBuffer in
                if let pixelBuffer = CMSampleBufferGetImageBuffer(cmBuffer) {
                    return pixelBuffer
                } else {
                    return nil
                }
            }
            .subscribe(VisionPool.cameraPool)
        VisionPool.cameraPool.observationsSubject.send([])
    }

    static func makeCameraPool() -> Self {
        let yoloWorker = try! YOLOObjectRecognizer()
        let visionPool = Self(workers: [yoloWorker, HandRecognizer()])
        return visionPool
    }
}
