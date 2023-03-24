//
//  ObservationPoint.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

extension VNRecognizedPointKey: Codable {}

struct ObservationPoint: Codable {
    let x: Double
    let y: Double
    var confidence: Double? = nil
    var identifier: VNRecognizedPointKey? = nil

    init(recognizedPoint: VNRecognizedPoint) {
        self.init(detectedPoint: recognizedPoint)
        identifier = recognizedPoint.identifier
    }

    init(detectedPoint: VNDetectedPoint) {
        self.init(point: detectedPoint)
        confidence = Double(detectedPoint.confidence)
    }

    init(point: VNPoint) {
        x = point.x
        y = point.y
    }
}
