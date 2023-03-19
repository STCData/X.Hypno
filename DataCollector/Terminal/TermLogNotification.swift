//
//  TermLogNotification.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import Foundation

public extension NSNotification.Name {
    static let TermLogNotification = NSNotification.Name("TermLogNotificationDidUpdate")
}

let TermLogNotificationUserInfoLogString = "TermLogNotificationUserInfoLogString"

let TermLogNotificationUserInfoLogLevel = "TermLogNotificationUserInfoLogLevel"
