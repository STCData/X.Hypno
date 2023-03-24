//
//  RecognizedTextObservation.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

struct RecognizedTextObservation: DetectedObjectObservationProtocol, Codable {
    var boundingBox: CGRect

    let text: String
    var bottomLeft: ObservationPoint
    var bottomRight: ObservationPoint
    var topLeft: ObservationPoint
    var topRight: ObservationPoint

    var timestamp: Date
    var confidence: Double

    init(textObservation: VNRecognizedTextObservation, denormalizeFor: CGSize) {
        text = textObservation.topCandidates(1).first?.string ?? ""
        timestamp = Date()
        confidence = Double(textObservation.confidence)
        bottomLeft = ObservationPoint(textObservation.bottomLeft, denormalizeFor: denormalizeFor)
        bottomRight = ObservationPoint(textObservation.bottomRight, denormalizeFor: denormalizeFor)
        topLeft = ObservationPoint(textObservation.topLeft, denormalizeFor: denormalizeFor)
        topRight = ObservationPoint(textObservation.topRight, denormalizeFor: denormalizeFor)
        boundingBox = DenormalizedRect(textObservation.boundingBox, forSize: denormalizeFor)
    }
}
