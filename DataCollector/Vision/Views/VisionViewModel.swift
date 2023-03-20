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

class VisionViewModel: ObservableObject {
    @Published var objects: [VNRecognizedObjectObservation] = []
    @Published var text: [VNRecognizedTextObservation] = []
    @Published var hands: [VNHumanHandPoseObservation] = []
    private var subscriptions = Set<AnyCancellable>()

    init(visionPool: VisionPool) {
        visionPool.observationsSubject
            .receive(on: RunLoop.main)
            .sink { observations in
                self.objects = observations.filter { $0 is VNRecognizedObjectObservation } as! [VNRecognizedObjectObservation]
                self.text = observations.filter { $0 is VNRecognizedTextObservation } as! [VNRecognizedTextObservation]
                self.hands = observations.filter { $0 is VNHumanHandPoseObservation } as! [VNHumanHandPoseObservation]

            }.store(in: &subscriptions)
    }
}
