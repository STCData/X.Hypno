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
    var bottomLeft: ObservationPoint
    var bottomRight: ObservationPoint
    var topLeft: ObservationPoint
    var topRight: ObservationPoint

    var timestamp: Date
    var confidence: Double

    init(barcodeObservation: VNBarcodeObservation, denormalizeFor: CGSize) {
        timestamp = Date()
        confidence = Double(barcodeObservation.confidence)
        payloadStringValue = barcodeObservation.payloadStringValue ?? ""
        symbology = barcodeObservation.symbology.rawValue
        bottomLeft = ObservationPoint(barcodeObservation.bottomLeft, denormalizeFor: denormalizeFor)
        bottomRight = ObservationPoint(barcodeObservation.bottomRight, denormalizeFor: denormalizeFor)
        topLeft = ObservationPoint(barcodeObservation.topLeft, denormalizeFor: denormalizeFor)
        topRight = ObservationPoint(barcodeObservation.topRight, denormalizeFor: denormalizeFor)
        boundingBox = DenormalizedRect(barcodeObservation.boundingBox, forSize: denormalizeFor)
    }
}
