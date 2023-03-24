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
    var type = "RecognizedPoints"

    var timestamp: Date
    var confidence: Double
    var recognizedPoints: [VNRecognizedPointKey: ObservationPoint]

    init(recognizedPointsObservation: VNRecognizedPointsObservation, denormalizeFor: CGSize) {
        timestamp = Date()
        confidence = Double(recognizedPointsObservation.confidence)
        recognizedPoints = RecognizedPointsFrom(recognizedPointsObservation: recognizedPointsObservation, denormalizeFor: denormalizeFor)
    }
}

func RecognizedPointsFrom(recognizedPointsObservation: VNRecognizedPointsObservation, denormalizeFor: CGSize) -> [VNRecognizedPointKey: ObservationPoint] {
    var p = [VNRecognizedPointKey: ObservationPoint]()
    for key in recognizedPointsObservation.availableKeys {
        p[key] = ObservationPoint(recognizedPoint: try! recognizedPointsObservation.recognizedPoint(forKey: key), denormalizeFor: denormalizeFor)
    }
    return p
}

extension RecognizedPointsObservation: NaturalLanguageDescribable {
    var naturalLanguageDescription: String {
        NaturalLanguageDescribe(self)!
    }
}
