//
//  VisionWorker.swift
//  DataCollector
//
//  Created by standard on 3/20/23.
//

import Combine
import Foundation
import Vision

protocol VisionWorker: Subscriber where Input == CVPixelBuffer, Failure == Never {
    var observationsSubject: PassthroughSubject<[VNObservation], Never> { get }
    var isBusy: Bool { get }
}

extension VisionWorker {
    static func makeWorkQueue() -> DispatchQueue {
        DispatchQueue(label: "VisionWorkerQueue-\(UUID())",
                      qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    }
}

//
// class VisionWorker {
//    var requests = [VNRequest]()
//
//    static func makeYOLORequest() -> VNRequest {
//            return VNCoreMLRequest(model: visionModel, completionHandler: detectionDidComplete)
//    }
//
//    static func makeHandRequest() -> VNRequest {
//        VNH
//    }
// }
