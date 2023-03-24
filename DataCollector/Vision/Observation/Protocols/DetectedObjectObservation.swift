//
//  DetectedObjectObservation.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

protocol DetectedObjectObservationProtocol: ObservationProtocol {
    var boundingBox: CGRect { get set }
}

struct DetectedObjectObservation: DetectedObjectObservationProtocol, Codable {
    var type = "DetectedObject"

    var boundingBox: CGRect

    var timestamp: Date
    var confidence: Double

    init(detectedObjectObservation: VNDetectedObjectObservation, denormalizeFor: CGSize) {
        timestamp = Date()
        confidence = Double(detectedObjectObservation.confidence)
        boundingBox = DenormalizedRect(detectedObjectObservation.boundingBox, forSize: denormalizeFor)
    }
}

extension DetectedObjectObservation: NaturalLanguageDescribable {
    var naturalLanguageDescription: String {
        NaturalLanguageDescribe(self)!
    }
}
