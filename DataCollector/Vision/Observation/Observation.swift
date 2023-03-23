//
//  Observation.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

class Observation: Codable {
    let timestamp: Date
    let confidence: Double

    init(_ vnObservation: VNObservation) {
        timestamp = Date()
        confidence = Double(vnObservation.confidence)
    }
}

extension Observation {
    static func from(vnObservation: VNObservation) -> Observation {
        switch vnObservation {
        case let handObservation as VNHumanHandPoseObservation:
            return HumanHandPoseObservation(handObservation)
        case let barcodeObservation as VNBarcodeObservation:
            return BarcodeObservation(barcodeObservation)
        case let faceObservation as VNFaceObservation:
            return FaceObservation(faceObservation)
        case let textObservation as VNRecognizedTextObservation:
            return RecognizedTextObservation(textObservation)
        case let rectangleObservation as VNRectangleObservation:
            return RectangleObservation(rectangleObservation)
        case let recognizedObjectObservation as VNRecognizedObjectObservation:
            return RecognizedObjectObservation(recognizedObjectObservation)
        // add more cases for other known subclasses of VNObservation
        default:
            fatalError("unknown observation")
        }
    }
}
