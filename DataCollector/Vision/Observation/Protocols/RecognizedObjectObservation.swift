//
//  RecognizedObjectObservation.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

protocol RecognizedObjectObservationProtocol: DetectedObjectObservationProtocol {}

struct RecognizedObjectObservation: RecognizedObjectObservationProtocol, Codable {
    var type = "RecognizedObject"

    var boundingBox: CGRect

    var timestamp: Date
    var confidence: Double

    init(recognizedObjectObservation: VNRecognizedObjectObservation, denormalizeFor: CGSize) {
        timestamp = Date()
        confidence = Double(recognizedObjectObservation.confidence)
        boundingBox = DenormalizedRect(recognizedObjectObservation.boundingBox, forSize: denormalizeFor)
    }
}

extension RecognizedObjectObservation: NaturalLanguageDescribable {
    var naturalLanguageDescription: String {
        NaturalLanguageDescribe(self)!
    }
}
