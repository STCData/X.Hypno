//
//  Broadcast.swift
//  DataCollector
//
//  Created by standard on 3/20/23.
//

import Combine
import Foundation
import Logging
import Promises
import ReplayKit

private let logger = LogLabels.broadcast.makeLogger()
class Broadcast: BufferVideoCapturerDelegate {
    static let shared = Broadcast()

    let cvBufferSubject = PassthroughSubject<CVPixelBuffer, Never>()
    let cmBufferSubject = PassthroughSubject<CMSampleBuffer, Never>()

    func capturer(_: BufferCapturer, didCapture cmBuffer: CMSampleBuffer) {
        logger.info("broadcast captured cmBuffer \(cmBuffer)")
        cmBufferSubject.send(cmBuffer)
    }

    func capturer(_: BufferCapturer, didCapture cvBuffer: CVPixelBuffer, timeStampNs: Int64) {
        logger.info("broadcast captured cvbuffer \(CVPixelBufferGetWidth(cvBuffer))x\(CVPixelBufferGetHeight(cvBuffer)) @\(timeStampNs)")
        cvBufferSubject.send(cvBuffer)
    }

    var broadcastScreenCapturer: BroadcastScreenCapturer
    init() {
        broadcastScreenCapturer = BroadcastScreenCapturer(options: BufferCaptureOptions())
        broadcastScreenCapturer.delegate = self
    }

    func start() {
        let screenShareExtensionId = Bundle.main.infoDictionary?[BroadcastScreenCapturer.kRTCScreenSharingExtension] as? String
        RPSystemBroadcastPickerView.show(for: screenShareExtensionId,
                                         showsMicrophoneButton: false)

        let _ = VisionPool.broadcastPool

        let started = broadcastScreenCapturer.startCapture()
        started.then(on: .main) { _ in
            logger.info("broadcast caputerstarted!")
        }
    }
}
