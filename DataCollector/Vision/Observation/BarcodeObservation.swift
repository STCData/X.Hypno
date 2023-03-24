//
//  BarcodeObservation.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

class BarcodeObservation: RectangleObservation {
    let payloadStringValue: String
    let symbology: String

    init(barcodeObservation: VNBarcodeObservation) {
        payloadStringValue = barcodeObservation.payloadStringValue ?? ""
        symbology = barcodeObservation.symbology.rawValue
        super.init(rectangleObservation: barcodeObservation)
    }

    required init(from _: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
