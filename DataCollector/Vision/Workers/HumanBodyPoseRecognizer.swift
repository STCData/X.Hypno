//
//  HumanPoseRecognizer.swift
//  DataCollector
//
//  Created by standard on 3/20/23.
//

import Combine
import Foundation
import Vision
private let log = LogLabels.vision.makeLogger()

class HumanBodyPoseRecognizer: VisionWorker {
    var isBusy = false

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
        isBusy = true
        workQueue.async {
            log.trace("heavy human recognizing")

            let request = VNDetectHumanBodyPoseRequest { request, _ in
                guard let observations = request.results as? [VNHumanBodyPoseObservation] else {
                    print("The observations are of an unexpected type.")
                    return
                }
                self.observationsSubject.send(observations)
                self.isBusy = false
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
