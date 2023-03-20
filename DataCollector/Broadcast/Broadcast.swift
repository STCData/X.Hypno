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

class Broadcast: BufferVideoCapturerDelegate, ObservableObject {
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

    @Published
    var isSystemWideInProgress = false {
        didSet {
            if isSystemWideInProgress {
                isInAppInProgress = false
                startSystemWide()
            } else {
                stopSystemWide()
            }
        }
    }

    @Published
    var isInAppInProgress = false {
        didSet {
            if isInAppInProgress {
                isSystemWideInProgress = false
                startInApp()
            } else {
                stopInApp()
            }
        }
    }

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

    private func startInApp() {
        stopSystemWide()
        inAppScreenCapturer = InAppScreenCapturer(options: BufferCaptureOptions())
        guard let inAppScreenCapturer else { return }

        inAppScreenCapturer.delegate = self
        let _ = inAppScreenCapturer.startCapture()
    }

    private func stopInApp() {
        guard let inAppScreenCapturer else { return }
        inAppScreenCapturer.delegate = nil
        let _ = inAppScreenCapturer.stopCapture().then { _ in
            self.inAppScreenCapturer = nil
        }
    }

    private func stopSystemWide() {
        // fixme actually stop
        guard let broadcastScreenCapturer else { return }
        broadcastScreenCapturer.delegate = nil
        broadcastScreenCapturer.stopCapture().then { _ in
            self.broadcastScreenCapturer = nil
        }
    }

    private func startSystemWide() {
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
