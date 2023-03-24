//
//  TextRecognizer.swift
//  DataCollector
//
//  Created by standard on 3/20/23.
//

import Combine
import Foundation
import Vision
private let log = LogLabels.vision.makeLogger()

class TextRecognizer: VisionWorker {
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
            log.trace("heavy text recognizing")

            let textRecognitionRequest = VNRecognizeTextRequest { request, _ in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    print("The observations are of an unexpected type.")
                    return
                }
                self.observationsSubject.send(observations)
                self.isBusy = false
            }
            textRecognitionRequest.recognitionLevel = .fast

            let requestHandler = VNImageRequestHandler(cvPixelBuffer: cvPixelBuffer, options: [:])

            do {
                try requestHandler.perform([textRecognitionRequest])
            } catch {
                print(error)
            }
        }
    }
}
