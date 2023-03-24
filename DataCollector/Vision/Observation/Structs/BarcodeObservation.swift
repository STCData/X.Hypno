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

    init(barcodeObservation: VNBarcodeObservation) {
        timestamp = Date()
        confidence = Double(barcodeObservation.confidence)
        payloadStringValue = barcodeObservation.payloadStringValue ?? ""
        symbology = barcodeObservation.symbology.rawValue
        bottomLeft = barcodeObservation.bottomLeft
        bottomRight = barcodeObservation.bottomRight
        topLeft = barcodeObservation.topLeft
        topRight = barcodeObservation.topRight
        boundingBox = barcodeObservation.boundingBox
    }
}
