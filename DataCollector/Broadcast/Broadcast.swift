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
private let logger = Logger(label: "broadcast")
class Broadcast {
    static let shared = Broadcast()

    let broadcastScreenCapturer = BroadcastScreenCapturer(options: BufferCaptureOptions())

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
