//
//  RectangleObservation.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

protocol RectangleObservationProtocol: DetectedObjectObservationProtocol {
    var bottomLeft: ObservationPoint { get set }
    var bottomRight: ObservationPoint { get set }
    var topLeft: ObservationPoint { get set }
    var topRight: ObservationPoint { get set }
}

struct RectangleObservation: RectangleObservationProtocol, Codable {
    var boundingBox: CGRect

    var bottomLeft: ObservationPoint
    var bottomRight: ObservationPoint
    var topLeft: ObservationPoint
    var topRight: ObservationPoint

    var timestamp: Date
    var confidence: Double

    init(rectangleObservation: VNRectangleObservation, denormalizeFor: CGSize) {
        timestamp = Date()
        confidence = Double(rectangleObservation.confidence)
        bottomLeft = ObservationPoint(rectangleObservation.bottomLeft, denormalizeFor: denormalizeFor)
        bottomRight = ObservationPoint(rectangleObservation.bottomRight, denormalizeFor: denormalizeFor)
        topLeft = ObservationPoint(rectangleObservation.topLeft, denormalizeFor: denormalizeFor)
        topRight = ObservationPoint(rectangleObservation.topRight, denormalizeFor: denormalizeFor)
        boundingBox = DenormalizedRect(rectangleObservation.boundingBox, forSize: denormalizeFor)
    }
}
