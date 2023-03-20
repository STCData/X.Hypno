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
    private let cmBufferSubject = PassthroughSubject<CMSampleBuffer, Never>()

    private var cmBufferConversionSubscriptions = Set<AnyCancellable>()

    func capturer(_: BufferCapturer, didCapture cmBuffer: CMSampleBuffer) {
        logger.info("broadcast captured cmBuffer \(cmBuffer)")
        cmBufferSubject.send(cmBuffer)
    }

    func capturer(_: BufferCapturer, didCapture cvBuffer: CVPixelBuffer, timeStampNs: Int64) {
        logger.info("broadcast captured cvbuffer \(CVPixelBufferGetWidth(cvBuffer))x\(CVPixelBufferGetHeight(cvBuffer)) @\(timeStampNs)")
        cvBufferSubject.send(cvBuffer)
    }

    var broadcastScreenCapturer: BroadcastScreenCapturer? = nil
    var inAppScreenCapturer: InAppScreenCapturer? = nil

    init() {
        cmBufferSubject
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .sink { cmBuffer in
                if let pixelBuffer = CMSampleBufferGetImageBuffer(cmBuffer) {
                    self.cvBufferSubject.send(pixelBuffer)
                }
            }
            .store(in: &cmBufferConversionSubscriptions)
    }

    func startInApp() {
        stopSystemWide()
        inAppScreenCapturer = InAppScreenCapturer(options: BufferCaptureOptions())
        guard let inAppScreenCapturer else { return }

        inAppScreenCapturer.delegate = self
        let _ = inAppScreenCapturer.startCapture()
    }

    func stopInApp() {
        guard let inAppScreenCapturer else { return }
        inAppScreenCapturer.delegate = nil
        let _ = inAppScreenCapturer.stopCapture()
        self.inAppScreenCapturer = nil
    }

    func stopSystemWide() {
        // fixme actually stop
        guard let broadcastScreenCapturer else { return }
        broadcastScreenCapturer.delegate = nil
        let _ = broadcastScreenCapturer.stopCapture()
        self.broadcastScreenCapturer = nil
    }

    func startSystemWide() {
        stopInApp()
        broadcastScreenCapturer = BroadcastScreenCapturer(options: BufferCaptureOptions())
        guard let broadcastScreenCapturer else { return }
        broadcastScreenCapturer.delegate = self

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
