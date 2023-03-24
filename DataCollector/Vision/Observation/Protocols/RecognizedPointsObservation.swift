//
//  RecognizedPointsObservation.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

protocol RecognizedPointsObservationProtocol: ObservationProtocol {
    var recognizedPoints: [VNRecognizedPointKey: ObservationPoint] { get set }
}

struct RecognizedPointsObservation: RecognizedPointsObservationProtocol, Codable {
    var timestamp: Date
    var confidence: Double
    var recognizedPoints: [VNRecognizedPointKey: ObservationPoint]

    init(recognizedPointsObservation: VNRecognizedPointsObservation) {
        timestamp = Date()
        confidence = Double(recognizedPointsObservation.confidence)
        recognizedPoints = RecognizedPointsFrom(recognizedPointsObservation: recognizedPointsObservation)
    }
}

func RecognizedPointsFrom(recognizedPointsObservation: VNRecognizedPointsObservation) -> [VNRecognizedPointKey: ObservationPoint] {
    var p = [VNRecognizedPointKey: ObservationPoint]()
    for key in recognizedPointsObservation.availableKeys {
        p[key] = ObservationPoint(recognizedPoint: try! recognizedPointsObservation.recognizedPoint(forKey: key))
    }
    return p
}
