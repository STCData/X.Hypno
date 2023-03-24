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
    var bottomLeft: CGPoint
    var bottomRight: CGPoint
    var topLeft: CGPoint
    var topRight: CGPoint

    var timestamp: Date
    var confidence: Double

    init(textObservation: VNRecognizedTextObservation) {
        text = textObservation.topCandidates(1).first?.string ?? ""
        timestamp = Date()
        confidence = Double(textObservation.confidence)
        bottomLeft = textObservation.bottomLeft
        bottomRight = textObservation.bottomRight
        topLeft = textObservation.topLeft
        topRight = textObservation.topRight
        boundingBox = textObservation.boundingBox
    }
}
