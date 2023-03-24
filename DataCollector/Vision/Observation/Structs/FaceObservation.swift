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

    init(faceObservation: VNFaceObservation) {
        timestamp = Date()
        confidence = Double(faceObservation.confidence)
        boundingBox = faceObservation.boundingBox
    }
}
