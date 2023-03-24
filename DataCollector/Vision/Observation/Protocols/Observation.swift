//
//  Observation.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

enum Observation {
    case humanHandPose(HumanHandPoseObservation)
    case barcode(BarcodeObservation)
    case recognizedText(RecognizedTextObservation)
    case face(FaceObservation)
    case recognizedObject(RecognizedObjectObservation)
    case recognizedPoints(RecognizedPointsObservation)
    case rectangle(RectangleObservation)
    case detectedObject(DetectedObjectObservation)
}

extension Observation: NaturalLanguageDescribable {
    var naturalLanguageClass: String {
        switch self {
        case let .humanHandPose(observation):
            return observation.naturalLanguageClass
        case let .barcode(observation):
            return observation.naturalLanguageClass
        case let .recognizedText(observation):
            return observation.naturalLanguageClass
        case let .face(observation):
            return observation.naturalLanguageClass
        case let .recognizedObject(observation):
            return observation.naturalLanguageClass
        case let .recognizedPoints(observation):
            return observation.naturalLanguageClass
        case let .rectangle(observation):
            return observation.naturalLanguageClass
        case let .detectedObject(observation):
            return observation.naturalLanguageClass
        }
    }

    var naturalLanguageDescription: String {
        switch self {
        case let .humanHandPose(observation):
            return observation.naturalLanguageDescription
        case let .barcode(observation):
            return observation.naturalLanguageDescription
        case let .recognizedText(observation):
            return observation.naturalLanguageDescription
        case let .face(observation):
            return observation.naturalLanguageDescription
        case let .recognizedObject(observation):
            return observation.naturalLanguageDescription
        case let .recognizedPoints(observation):
            return observation.naturalLanguageDescription
        case let .rectangle(observation):
            return observation.naturalLanguageDescription
        case let .detectedObject(observation):
            return observation.naturalLanguageDescription
        }
    }
}

extension Observation: Encodable {
    func encode(to encoder: Encoder) throws {
        var singleContainer = encoder.singleValueContainer()

        switch self {
        case let .humanHandPose(observation):
            try singleContainer.encode(observation)
        case let .barcode(observation):
            try singleContainer.encode(observation)
        case let .recognizedText(observation):
            try singleContainer.encode(observation)
        case let .face(observation):
            try singleContainer.encode(observation)
        case let .recognizedObject(observation):
            try singleContainer.encode(observation)
        case let .recognizedPoints(observation):
            try singleContainer.encode(observation)
        case let .rectangle(observation):
            try singleContainer.encode(observation)
        case let .detectedObject(observation):
            try singleContainer.encode(observation)
        }
    }

    static func from(_ vnObservation: VNObservation, denormalizeFor: CGSize) -> Observation {
        switch vnObservation {
        case let handObservation as VNHumanHandPoseObservation:
            return .humanHandPose(HumanHandPoseObservation(humanHandPoseObservation: handObservation, denormalizeFor: denormalizeFor))
        case let barcodeObservation as VNBarcodeObservation:
            return .barcode(BarcodeObservation(barcodeObservation: barcodeObservation, denormalizeFor: denormalizeFor))
        case let faceObservation as VNFaceObservation:
            return .face(FaceObservation(faceObservation: faceObservation, denormalizeFor: denormalizeFor))
        case let textObservation as VNRecognizedTextObservation:
            return .recognizedText(RecognizedTextObservation(textObservation: textObservation, denormalizeFor: denormalizeFor))
        case let objectObservation as VNRecognizedObjectObservation:
            return .recognizedObject(RecognizedObjectObservation(recognizedObjectObservation: objectObservation, denormalizeFor: denormalizeFor))
        case let pointsObservation as VNRecognizedPointsObservation:
            return .recognizedPoints(RecognizedPointsObservation(recognizedPointsObservation: pointsObservation, denormalizeFor: denormalizeFor))
        case let rectangleObservation as VNRectangleObservation:
            return .rectangle(RectangleObservation(rectangleObservation: rectangleObservation, denormalizeFor: denormalizeFor))
        case let detectedObjectObservation as VNDetectedObjectObservation:
            return .detectedObject(DetectedObjectObservation(detectedObjectObservation: detectedObjectObservation, denormalizeFor: denormalizeFor))
        default:
            fatalError("Unknown observation")
        }
    }
}

protocol ObservationProtocol {
    var timestamp: Date { get set }
    var confidence: Double { get set }
    var type: String { get }
}
