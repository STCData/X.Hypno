//
//  ObservationPoint.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

extension VNRecognizedPointKey: Codable {}

// func DenormalizedPoint(_ normalized: CGPoint, forSize: CGSize) -> CGPoint {
//    return VNImagePointForNormalizedPoint(normalized, Int(forSize.width), Int(forSize.height))
// }
//
// func DenormalizedRect(_ normalized: CGRect, forSize: CGSize) -> CGRect {
//    return VNImageRectForNormalizedRect(normalized, Int(forSize.width), Int(forSize.height))
// }

// func DenormalizedPoint(_ normalized: CGPoint, forSize: CGSize) -> CGPoint {
//    return CGPoint(x: normalized.x * forSize.width, y: forSize.height)
// }
//
// func DenormalizedRect(_ normalized: CGRect, forSize: CGSize) -> CGRect {
//    let x = normalized.origin.x * forSize.width
//    let y = (1 - normalized.origin.y) * forSize.height
//    let width = normalized.width * forSize.width
//    let height = normalized.height * forSize.height
//    return CGRect(x: x, y: y, width: width, height: height)
// }

func DenormalizedPoint(_ normalized: CGPoint, forSize: CGSize) -> CGPoint {
    return VNImagePointForNormalizedPoint(normalized, Int(forSize.width), Int(forSize.height)).applying(.init(scaleX: 1, y: -1)).applying(.init(translationX: 0, y: forSize.height))
}

func DenormalizedRect(_ normalized: CGRect, forSize: CGSize) -> CGRect {
    return VNImageRectForNormalizedRect(normalized, Int(forSize.width), Int(forSize.height)).applying(.init(scaleX: 1, y: -1)).applying(.init(translationX: 0, y: forSize.height))
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
