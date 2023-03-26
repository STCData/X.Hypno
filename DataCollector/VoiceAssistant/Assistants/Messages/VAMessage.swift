//
//  VAMessage.swift
//  DataCollector
//
//  Created by standard on 3/22/23.
//

import Foundation

enum VAMessageRole {
    case assistant
    case assistantClientSideService
    case assistantCode
    case user
    case userRecordingInProcess
    case userTyping
    case userExpectingResponse
    case error
}

struct VAMessage: Identifiable {
    let id = UUID()
    let text: String
    let role: VAMessageRole
}
