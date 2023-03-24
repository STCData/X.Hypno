//
//  RecognizedTextObservation.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

class RecognizedTextObservation: DetectedObjectObservation {
    let text: String

    init(textObservation: VNRecognizedTextObservation) {
        text = textObservation.topCandidates(1).first?.string ?? ""
        super.init(textObservation)
    }

    required init(from _: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
