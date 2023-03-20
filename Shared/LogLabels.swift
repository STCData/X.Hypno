//
//  LogLabels.swift
//  DataCollector
//
//  Created by standard on 3/20/23.
//

import Foundation
import Logging
enum LogLabels: String {
    case general = "stc.data.general"
    case webview = "stc.data.webview"
    case camera = "stc.data.camera"
    case ml = "stc.data.ml"
    case network = "stc.data.network"
    case broadcast = "stc.data.broadcast"
    case broadcastUpload = "stc.data.broadcast.upload"
}

extension LogLabels {
    func makeLogger() -> Logger {
        Logger(label: rawValue)
    }
}
