//
//  RectangleObservation.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

class RectangleObservation: DetectedObjectObservation {
    let bottomLeft: CGPoint
    let bottomRight: CGPoint
    let topLeft: CGPoint
    let topRight: CGPoint

    init(rectangleObservation: VNRectangleObservation) {
        bottomLeft = rectangleObservation.bottomLeft
        bottomRight = rectangleObservation.bottomRight
        topLeft = rectangleObservation.topLeft
        topRight = rectangleObservation.topRight
        super.init(rectangleObservation)
    }

    enum CodingKeys: String, CodingKey {
        case bottomLeft
        case bottomRight
        case topLeft
        case topRight
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        bottomLeft = try container.decode(CGPoint.self, forKey: .bottomLeft)
        bottomRight = try container.decode(CGPoint.self, forKey: .bottomRight)
        topLeft = try container.decode(CGPoint.self, forKey: .topLeft)
        topRight = try container.decode(CGPoint.self, forKey: .topRight)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bottomLeft, forKey: .bottomLeft)
        try container.encode(bottomRight, forKey: .bottomRight)
        try container.encode(topLeft, forKey: .topLeft)
        try container.encode(topRight, forKey: .topRight)
        try super.encode(to: encoder)
    }
}
