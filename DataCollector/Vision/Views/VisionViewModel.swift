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
    private var subscriptions = Set<AnyCancellable>()

    init(visionPool: VisionPool) {
        visionPool.observationsSubject
            .receive(on: RunLoop.main)
            .sink { observations in
                self.objects = observations.filter { $0 is VNRecognizedObjectObservation } as! [VNRecognizedObjectObservation]
                self.text = observations.filter { $0 is VNRecognizedTextObservation } as! [VNRecognizedTextObservation]

            }.store(in: &subscriptions)
    }

    func deNormalize(_ rect: CGRect, _ geometry: GeometryProxy) -> CGRect {
        return VNImageRectForNormalizedRect(rect, Int(geometry.size.width), Int(geometry.size.height))
    }
}
