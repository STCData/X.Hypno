//
//  Broadcast.swift
//  DataCollector
//
//  Created by standard on 3/20/23.
//

import Foundation
import Logging
import Promises
import ReplayKit
private let logger = Logger(label: LogLabels.broadcast)
class Broadcast: BufferVideoCapturerDelegate {
    func capturer(_: BufferCapturer, didCapture cmBuffer: CMSampleBuffer) {
        logger.info("broadcast captured cmBuffer \(cmBuffer)")
    }

    func capturer(_: BufferCapturer, didCapture cvBuffer: CVPixelBuffer, timeStampNs: Int64) {
        logger.info("broadcast captured cvbuffer \(CVPixelBufferGetWidth(cvBuffer))x\(CVPixelBufferGetHeight(cvBuffer)) @\(timeStampNs)")
    }

    static let shared = Broadcast()

    var broadcastScreenCapturer: BroadcastScreenCapturer
    init() {
        broadcastScreenCapturer = BroadcastScreenCapturer(options: BufferCaptureOptions())
        broadcastScreenCapturer.delegate = self
    }

    func start() {
        let screenShareExtensionId = Bundle.main.infoDictionary?[BroadcastScreenCapturer.kRTCScreenSharingExtension] as? String
        RPSystemBroadcastPickerView.show(for: screenShareExtensionId,
                                         showsMicrophoneButton: false)

        let started = broadcastScreenCapturer.startCapture()
        started.then(on: .main) { _ in
            logger.info("broadcast caputerstarted!")
        }
    }
}
