//
//  HandRecognizer.swift
//  DataCollector
//
//  Created by standard on 3/20/23.
//

import Combine
import Foundation
import Vision
private let log = LogLabels.vision.makeLogger()

class HandRecognizer: VisionWorker {
    func receive(subscription _: Subscription) {}

    func receive(_ input: CVBuffer) -> Subscribers.Demand {
        process(cvPixelBuffer: input)
        return .max(1)
    }

    func receive(completion _: Subscribers.Completion<Never>) {}

    let observationsSubject = PassthroughSubject<[VNObservation], Never>()

    init() {}

    private let workQueue = makeWorkQueue()

    func process(cvPixelBuffer: CVPixelBuffer) {
        workQueue.async {
            log.trace("heavy hand recognizing")

            let request = VNDetectHumanHandPoseRequest { request, _ in
                guard let observations = request.results as? [VNHumanHandPoseObservation] else {
                    print("The observations are of an unexpected type.")
                    return
                }
                self.observationsSubject.send(observations)
            }

            let requestHandler = VNImageRequestHandler(cvPixelBuffer: cvPixelBuffer, options: [:])

            do {
                try requestHandler.perform([request])
            } catch {
                print(error)
            }
        }
    }
}
