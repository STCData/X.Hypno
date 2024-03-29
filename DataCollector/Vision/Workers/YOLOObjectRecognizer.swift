//
//  YOLOObjectRecognizer.swift
//  DataCollector
//
//  Created by standard on 3/20/23.
//

import Combine
import Foundation
import Vision
private let log = LogLabels.vision.makeLogger()

class YOLOObjectRecognizer: VisionWorker {
    var isBusy = false

    func receive(subscription _: Subscription) {}

    func receive(_ input: CVBuffer) -> Subscribers.Demand {
        process(cvPixelBuffer: input)
        return .max(1)
    }

    func receive(completion _: Subscribers.Completion<Never>) {}

    let observationsSubject = PassthroughSubject<[VNObservation], Never>()

    private let visionModel: VNCoreMLModel

    init() throws {
        let modelURL = Bundle.main.url(forResource: "YOLOv3TinyInt8LUT", withExtension: "mlmodelc")

        visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL!))
    }

    private let workQueue = makeWorkQueue()

    func process(cvPixelBuffer: CVPixelBuffer) {
        isBusy = true
        workQueue.async {
            log.trace("heavy yolo recognizing")

            let recognitionRequest = VNCoreMLRequest(model: self.visionModel) { request, _ in
                guard let observations = request.results as? [VNRecognizedObjectObservation] else {
                    print("The observations are of an unexpected type.")
                    return
                }
                self.observationsSubject.send(observations)
                self.isBusy = false
            }

            let requestHandler = VNImageRequestHandler(cvPixelBuffer: cvPixelBuffer, options: [:])

            do {
                try requestHandler.perform([recognitionRequest])
            } catch {
                print(error)
            }
        }
    }
}
