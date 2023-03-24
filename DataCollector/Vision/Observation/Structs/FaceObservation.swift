//
//  FaceObservation.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

struct FaceObservation: DetectedObjectObservationProtocol, Codable {
    var boundingBox: CGRect

    var timestamp: Date
    var confidence: Double

    init(faceObservation: VNFaceObservation, denormalizeFor: CGSize) {
        timestamp = Date()
        confidence = Double(faceObservation.confidence)
        boundingBox = DenormalizedRect(faceObservation.boundingBox, forSize: denormalizeFor)
    }
}
