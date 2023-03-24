//
//  RectangleObservation.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

protocol RectangleObservationProtocol: DetectedObjectObservationProtocol {
    var bottomLeft: CGPoint { get set }
    var bottomRight: CGPoint { get set }
    var topLeft: CGPoint { get set }
    var topRight: CGPoint { get set }
}

struct RectangleObservation: RectangleObservationProtocol, Codable {
    var boundingBox: CGRect

    var bottomLeft: CGPoint
    var bottomRight: CGPoint
    var topLeft: CGPoint
    var topRight: CGPoint

    var timestamp: Date
    var confidence: Double

    init(rectangleObservation: VNRectangleObservation) {
        timestamp = Date()
        confidence = Double(rectangleObservation.confidence)
        bottomLeft = rectangleObservation.bottomLeft
        bottomRight = rectangleObservation.bottomRight
        topLeft = rectangleObservation.topLeft
        topRight = rectangleObservation.topRight
        boundingBox = rectangleObservation.boundingBox
    }
}
