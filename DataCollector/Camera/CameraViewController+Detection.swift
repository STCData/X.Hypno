//
//  CameraViewController+Detection.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import AVFoundation
import Logging
import UIKit
import Vision

private let log = Logger(label: LogLabels.camera.rawValue)

extension CameraViewController {
    func setupDetector() {
        let modelURL = Bundle.main.url(forResource: "YOLOv3TinyInt8LUT", withExtension: "mlmodelc")

        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL!))
            let recognitions = VNCoreMLRequest(model: visionModel, completionHandler: detectionDidComplete)

            requests = [recognitions]
        } catch {
            log.error("\(error)")
        }
    }

    func detectionDidComplete(request: VNRequest, error _: Error?) {
        DispatchQueue.main.async {
            if let results = request.results {
                self.extractDetections(results)
            }
        }
    }

    func extractDetections(_ results: [VNObservation]) {
        detectionLayer.sublayers = nil

        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else { continue }

            // Transformations
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(screenRect.size.width), Int(screenRect.size.height))
            let transformedBounds = CGRect(x: objectBounds.minX, y: screenRect.size.height - objectBounds.maxY, width: objectBounds.maxX - objectBounds.minX, height: objectBounds.maxY - objectBounds.minY)

            if let firstObservation = objectObservation.labels.first {
                log.info("📷 \(objectObservation.boundingBox.origin.x)  \(firstObservation.confidence) \(firstObservation.identifier)")
            }
            let boxLayer = self.drawBoundingBox(transformedBounds)

            detectionLayer.addSublayer(boxLayer)
        }
    }

    func updateLayers() {
        detectionLayer?.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
    }

    func drawBoundingBox(_ bounds: CGRect) -> CALayer {
        let boxLayer = CALayer()
        boxLayer.frame = bounds
        boxLayer.borderWidth = 3.0
        boxLayer.borderColor = CGColor(red: 0.9, green: 0.1, blue: 0.0, alpha: 1.0)
        boxLayer.cornerRadius = 4
        return boxLayer
    }

    func captureOutput(_: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from _: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:]) // Create handler to perform request on the buffer
        do {
            try imageRequestHandler.perform(requests) // Schedules vision requests to be performed
        } catch {
            log.error("\(error)")
        }
    }
}
