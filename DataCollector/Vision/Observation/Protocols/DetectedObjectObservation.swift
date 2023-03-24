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
    var boundingBox: CGRect

    var timestamp: Date
    var confidence: Double

    init(detectedObjectObservation: VNDetectedObjectObservation) {
        timestamp = Date()
        confidence = Double(detectedObjectObservation.confidence)
        boundingBox = detectedObjectObservation.boundingBox
    }
}
