//
//  TermLogger.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//
import Puppy

@preconcurrency import Dispatch
import Foundation

public struct TermLogger: Loggerable, Sendable {
    public let label: String
    public let queue: DispatchQueue
    public let logLevel: LogLevel
    public let logFormat: LogFormattable?

    public init(_ label: String, logLevel: LogLevel = .trace, logFormat: LogFormattable? = nil) {
        self.label = label
        queue = DispatchQueue(label: label)
        self.logLevel = logLevel
        self.logFormat = logFormat
    }

    public func log(_ level: LogLevel, string: String) {
        NotificationCenter.default.post(Notification(name: Notification.Name.TermLogNotification, userInfo: [
            TermLogNotificationUserInfoLogString: string,
            TermLogNotificationUserInfoLogLevel: level,
        ]))
    }
}
