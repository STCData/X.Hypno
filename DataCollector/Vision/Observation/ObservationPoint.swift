//
//  ObservationPoint.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

extension VNRecognizedPointKey: Codable {}

func DenormalizedPoint(_ normalized: CGPoint, forSize: CGSize) -> CGPoint {
    return VNImagePointForNormalizedPoint(normalized, Int(forSize.width), Int(forSize.height))
}

func DenormalizedRect(_ normalized: CGRect, forSize: CGSize) -> CGRect {
    return VNImageRectForNormalizedRect(normalized, Int(forSize.width), Int(forSize.height))
}

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
        let pointDenormalized = VNImagePointForNormalizedPoint(CGPoint(x: point.x, y: point.y), Int(denormalizeFor.width), Int(denormalizeFor.height))
        x = pointDenormalized.x
        y = pointDenormalized.y
    }
}
