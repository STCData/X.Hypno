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

    init(recognizedPoint: VNRecognizedPoint, denormalizeFor: CGSize) {
        self.init(detectedPoint: recognizedPoint, denormalizeFor: denormalizeFor)
        identifier = recognizedPoint.identifier
    }

    init(detectedPoint: VNDetectedPoint, denormalizeFor: CGSize) {
        self.init(point: detectedPoint, denormalizeFor: denormalizeFor)
        confidence = Double(detectedPoint.confidence)
    }

    init(point: VNPoint, denormalizeFor: CGSize) {
        let pointDenormalized = DenormalizedPoint(CGPoint(x: point.x, y: point.y), forSize: denormalizeFor)
        x = pointDenormalized.x
        y = pointDenormalized.y
    }

    init(_ cgPoint: CGPoint, denormalizeFor: CGSize) {
        let pointDenormalized = DenormalizedPoint(cgPoint, forSize: denormalizeFor)
        x = pointDenormalized.x
        y = pointDenormalized.y
    }
}
