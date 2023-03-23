//
//  VisionViewModel.swift
//  DataCollector
//
//  Created by standard on 3/20/23.
//

import Combine
import Foundation
import SwiftUI
import Vision

import Vision

extension Array where Element == VNRectangleObservation {
    func isAlmostEqual(with insets: UIEdgeInsets, to other: [VNRectangleObservation]) -> Bool {
        guard count == other.count else { return false }
        for (index, observation) in enumerated() {
            let otherObservation = other[index]
            let rect = observation.boundingBox
            let otherRect = otherObservation.boundingBox
            let insetRect = rect.inset(by: insets)
            let otherInsetRect = otherRect.inset(by: insets)
            if insetRect != otherInsetRect {
                return false
            }
        }
        return true
    }
}

class VisionViewModel: ObservableObject {
    @Published var objects: [VNRecognizedObjectObservation] = []
    @Published var text: [VNRecognizedTextObservation] = []
    @Published var hands: [VNHumanHandPoseObservation] = []
    @Published var humanBodyPoses: [VNHumanBodyPoseObservation] = []
    private var subscriptions = Set<AnyCancellable>()

    init(visionPool: VisionPool) {
        Publishers.RemoveDuplicates(upstream: visionPool.observationsSubject, predicate: {
            guard let rects1 = $0 as? [VNRectangleObservation],
                  let rects2 = $1 as? [VNRectangleObservation]
            else {
                return $0 == $1
            }
            let isEqual = rects1.isAlmostEqual(with: UIEdgeInsets(top: 1.2, left: 10, bottom: 1.3, right: 10), to: rects2)
            if isEqual, rects1.count > 0 {
                print("is equal")
            }

            return isEqual
        })
        .receive(on: RunLoop.main)
        .sink { observations in
            self.objects = observations.filter { $0 is VNRecognizedObjectObservation } as! [VNRecognizedObjectObservation]
            self.text = observations.filter { $0 is VNRecognizedTextObservation } as! [VNRecognizedTextObservation]
            self.hands = observations.filter { $0 is VNHumanHandPoseObservation } as! [VNHumanHandPoseObservation]
            self.humanBodyPoses = observations.filter { $0 is VNHumanBodyPoseObservation } as! [VNHumanBodyPoseObservation]

        }.store(in: &subscriptions)
    }
}