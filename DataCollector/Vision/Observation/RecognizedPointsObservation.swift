//
//  RecognizedPointsObservation.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

class RecognizedPointsObservation: Observation {
    let recognizedPoints: [VNRecognizedPointKey: ObservationPoint]

    init(pointsObservation: VNRecognizedPointsObservation) {
        var p = [VNRecognizedPointKey: ObservationPoint]()
        for key in pointsObservation.availableKeys {
            p[key] = ObservationPoint(recognizedPoint: try! pointsObservation.recognizedPoint(forKey: key))
        }
        recognizedPoints = p
        super.init(pointsObservation)
    }

    required init(from _: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
