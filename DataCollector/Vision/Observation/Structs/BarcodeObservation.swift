//
//  BarcodeObservation.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

struct BarcodeObservation: RectangleObservationProtocol, Codable {
    var boundingBox: CGRect

    let payloadStringValue: String
    let symbology: String
    var bottomLeft: CGPoint
    var bottomRight: CGPoint
    var topLeft: CGPoint
    var topRight: CGPoint

    var timestamp: Date
    var confidence: Double

    init(barcodeObservation: VNBarcodeObservation, denormalizeFor: CGSize) {
        timestamp = Date()
        confidence = Double(barcodeObservation.confidence)
        payloadStringValue = barcodeObservation.payloadStringValue ?? ""
        symbology = barcodeObservation.symbology.rawValue
        bottomLeft = DenormalizedPoint(barcodeObservation.bottomLeft, forSize: denormalizeFor)
        bottomRight = DenormalizedPoint(barcodeObservation.bottomRight, forSize: denormalizeFor)
        topLeft = DenormalizedPoint(barcodeObservation.topLeft, forSize: denormalizeFor)
        topRight = DenormalizedPoint(barcodeObservation.topRight, forSize: denormalizeFor)
        boundingBox = DenormalizedRect(barcodeObservation.boundingBox, forSize: denormalizeFor)
    }
}
